import DeviceActivity
import FamilyControls
import Flutter
import ManagedSettings
import SwiftUI
import UIKit
import UserNotifications

/// Screen time for "Digital detox" habits on iPhone; the Dart side is
/// screen_time_service.dart (same channel as Android's MainActivity.kt).
///
/// Apple's Screen Time API (iOS 16+, Family Controls entitlement) never
/// gives the app usage minutes. Instead the user picks which apps count,
/// the app starts a daily DeviceActivity per limit habit, and the
/// DeviceActivityMonitor extension notifies when a limit is reached.
/// Older iOS versions report "not supported" and the habit is checked
/// in by hand.
enum ScreenTimeBridge {
  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "com.codesapience.streakflow/screen_time",
      binaryMessenger: messenger
    )

    channel.setMethodCallHandler { call, result in
      if #available(iOS 16.0, *) {
        ScreenTimeController.shared.handle(call, result: result)
      } else {
        switch call.method {
        case "isSupported", "hasUsageAccess", "openUsageAccessSettings":
          result(false)
        default:
          result(nil)
        }
      }
    }
  }
}

@available(iOS 16.0, *)
final class ScreenTimeController {
  static let shared = ScreenTimeController()

  private let center = DeviceActivityCenter()
  private let selectionKey = "screen_time.selection"
  private let monitorKey = "screen_time.monitor_key"

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]

    switch call.method {
    case "isSupported":
      result(true)

    case "hasUsageAccess":
      result(isReady)

    // On iPhone: ask for Screen Time permission, then pick the apps.
    case "openUsageAccessSettings":
      setUp(result: result)

    // Apple doesn't share usage minutes with apps.
    case "screenTimeMinutes":
      result(nil)

    case "syncLimits":
      ScreenTimeShared.saveLimits(
        args["limits"] as? [[String: Any]] ?? [],
        enabled: args["enabled"] as? Bool ?? false
      )
      restartMonitoring(force: false)
      result(nil)

    case "dayResult":
      guard let id = args["id"] as? String, let day = args["day"] as? String else {
        result(nil)
        return
      }
      result(ScreenTimeShared.dayResult(habitId: id, day: day))

    // Hidden diagnostics panel (tap "Screen time today" 5 times).
    case "diagnostics":
      diagnostics(result: result)

    case "startTestAlert":
      result(startTestAlert())

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Authorization and app selection

  private var selection: FamilyActivitySelection? {
    guard let data = ScreenTimeShared.defaults.data(forKey: selectionKey) else { return nil }
    return try? PropertyListDecoder().decode(FamilyActivitySelection.self, from: data)
  }

  private func isEmpty(_ selection: FamilyActivitySelection) -> Bool {
    selection.applicationTokens.isEmpty
      && selection.categoryTokens.isEmpty
      && selection.webDomainTokens.isEmpty
  }

  /// Permission granted and at least one app or category chosen.
  private var isReady: Bool {
    guard AuthorizationCenter.shared.authorizationStatus == .approved,
      let selection
    else { return false }
    return !isEmpty(selection)
  }

  private func setUp(result: @escaping FlutterResult) {
    Task { @MainActor in
      do {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
      } catch {
        NSLog("[ScreenTime] Authorization failed: \(error)")
        ScreenTimeShared.debug("app: authorization failed: \(error.localizedDescription)")
        result(false)
        return
      }

      ScreenTimeShared.debug("app: authorization approved")
      self.presentPicker { picked in
        ScreenTimeShared.debug(picked == nil ? "app: picker cancelled" : "app: apps chosen")
        if let picked,
          let data = try? PropertyListEncoder().encode(picked)
        {
          ScreenTimeShared.defaults.set(data, forKey: self.selectionKey)
          self.restartMonitoring(force: true)
        }
        result(self.isReady)
      }
    }
  }

  @MainActor
  private func presentPicker(completion: @escaping (FamilyActivitySelection?) -> Void) {
    guard let presenter = Self.topViewController() else {
      completion(nil)
      return
    }

    var host: UIViewController?
    let view = ScreenTimePickerView(selection: selection ?? FamilyActivitySelection()) { picked in
      host?.dismiss(animated: true)
      completion(picked)
    }
    let controller = UIHostingController(rootView: view)
    host = controller
    presenter.present(controller, animated: true)
  }

  private static func topViewController() -> UIViewController? {
    let window = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }

    var top = window?.rootViewController
    while let presented = top?.presentedViewController {
      top = presented
    }
    return top
  }

  // MARK: - Monitoring

  /// One daily activity per limit habit, named after the habit id.
  /// Restarted only when the habits' limits, the chosen apps or the
  /// reminders switch change: restarting resets today's count on iOS
  /// versions before 17.4.
  private func restartMonitoring(force: Bool) {
    let limits = ScreenTimeShared.limits()
    let enabled = ScreenTimeShared.enabled && isReady
    let selectionData = ScreenTimeShared.defaults.data(forKey: selectionKey) ?? Data()

    let key = ([enabled ? "on" : "off", selectionData.base64EncodedString()]
      + limits.map { "\($0.id)=\($0.limitMinutes)" }.sorted())
      .joined(separator: ";")

    if !force && key == ScreenTimeShared.defaults.string(forKey: monitorKey) {
      return
    }

    // Leave the diagnostics test alert running.
    center.stopMonitoring(
      center.activities.filter { $0.rawValue != ScreenTimeShared.testActivity }
    )
    ScreenTimeShared.defaults.set(key, forKey: monitorKey)

    guard enabled, let selection else {
      ScreenTimeShared.debug(
        "app: monitoring stopped (switch \(ScreenTimeShared.enabled ? "on" : "off"), "
          + "ready \(isReady), \(limits.count) limit(s))"
      )
      return
    }

    let schedule = DeviceActivitySchedule(
      intervalStart: DateComponents(hour: 0, minute: 0),
      intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
      repeats: true
    )
    let now = Date()

    // iOS allows a limited number of monitored activities.
    for limit in limits.prefix(20) {
      var events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
        DeviceActivityEvent.Name("limit"): event(selection, minutes: limit.limitMinutes)
      ]
      if limit.limitMinutes >= 30 {
        events[DeviceActivityEvent.Name("warn")] =
          event(selection, minutes: limit.limitMinutes * 4 / 5)
      }

      do {
        try center.startMonitoring(
          DeviceActivityName(limit.id),
          during: schedule,
          events: events
        )
        if limit.isScheduled(on: now) {
          ScreenTimeShared.record("started", habitId: limit.id, day: now)
        }
        ScreenTimeShared.debug(
          "app: monitoring \(limit.title) (\(ScreenTimeShared.format(limit.limitMinutes)))"
        )
      } catch {
        NSLog("[ScreenTime] startMonitoring failed for \(limit.id): \(error)")
        ScreenTimeShared.debug(
          "app: startMonitoring failed for \(limit.title): \(error.localizedDescription)"
        )
      }
    }
  }

  // MARK: - Diagnostics

  /// A separate activity whose only event fires after 1 minute in the
  /// chosen apps (counted from now): checks monitoring, the extension and
  /// notifications end to end.
  private func startTestAlert() -> String {
    guard let selection, isReady else {
      return "Not ready: allow Screen Time and choose apps first."
    }

    let name = DeviceActivityName(ScreenTimeShared.testActivity)
    center.stopMonitoring([name])

    do {
      try center.startMonitoring(
        name,
        during: DeviceActivitySchedule(
          intervalStart: DateComponents(hour: 0, minute: 0),
          intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
          repeats: false
        ),
        events: [
          DeviceActivityEvent.Name("test"): DeviceActivityEvent(
            applications: selection.applicationTokens,
            categories: selection.categoryTokens,
            webDomains: selection.webDomainTokens,
            threshold: DateComponents(minute: 1)
          )
        ]
      )
      ScreenTimeShared.debug("app: test alert started")
      return "Test started: use one of the chosen apps for about 1 minute, "
        + "then a \"StreakFlow test alert\" notification should appear."
    } catch {
      ScreenTimeShared.debug("app: test alert failed: \(error.localizedDescription)")
      return "Test failed to start: \(error.localizedDescription)"
    }
  }

  private func diagnostics(result: @escaping FlutterResult) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      DispatchQueue.main.async {
        let notifications: String
        switch settings.authorizationStatus {
        case .authorized: notifications = "allowed"
        case .denied: notifications = "DENIED"
        case .notDetermined: notifications = "not asked yet"
        case .provisional: notifications = "provisional"
        case .ephemeral: notifications = "ephemeral"
        @unknown default: notifications = "unknown"
        }

        let permission: String
        switch AuthorizationCenter.shared.authorizationStatus {
        case .approved: permission = "approved"
        case .denied: permission = "DENIED"
        case .notDetermined: permission = "not asked yet"
        @unknown default: permission = "unknown"
        }

        let now = Date()
        let selection = self.selection

        result([
          "Device": "iOS \(UIDevice.current.systemVersion)",
          "Screen Time permission": permission,
          "Notifications": notifications
            + (settings.alertSetting == .enabled ? ", banners on" : ", banners OFF"),
          "Habit Reminders switch": ScreenTimeShared.enabled ? "on" : "OFF",
          "App Group": UserDefaults(suiteName: ScreenTimeShared.appGroup) == nil
            ? "MISSING" : "ok",
          "Chosen apps": selection.map {
            "\($0.applicationTokens.count) apps, \($0.categoryTokens.count) categories, "
              + "\($0.webDomainTokens.count) websites"
          } ?? "none",
          "Limits": ScreenTimeShared.limits().map {
            "\($0.title): \(ScreenTimeShared.format($0.limitMinutes)), "
              + "today \($0.isScheduled(on: now) ? "scheduled" : "NOT scheduled")"
          },
          "Monitored by iOS": self.center.activities.map { name in
            ScreenTimeShared.limits().first { $0.id == name.rawValue }?.title ?? name.rawValue
          },
          "Day log": ScreenTimeShared.dayLog(),
          "Recent events": ScreenTimeShared.debugLines(),
        ] as [String: Any])
      }
    }
  }

  private func event(_ selection: FamilyActivitySelection, minutes: Int) -> DeviceActivityEvent {
    let threshold = DateComponents(hour: minutes / 60, minute: minutes % 60)

    // Count usage from midnight even when monitoring starts later.
    if #available(iOS 17.4, *) {
      return DeviceActivityEvent(
        applications: selection.applicationTokens,
        categories: selection.categoryTokens,
        webDomains: selection.webDomainTokens,
        threshold: threshold,
        includesPastActivity: true
      )
    }
    return DeviceActivityEvent(
      applications: selection.applicationTokens,
      categories: selection.categoryTokens,
      webDomains: selection.webDomainTokens,
      threshold: threshold
    )
  }
}

/// Apple's app picker: the apps, categories and websites that count
/// toward the limit. Choosing every category counts all apps.
@available(iOS 16.0, *)
struct ScreenTimePickerView: View {
  @State private var selection: FamilyActivitySelection
  private let onDone: (FamilyActivitySelection?) -> Void

  init(
    selection: FamilyActivitySelection,
    onDone: @escaping (FamilyActivitySelection?) -> Void
  ) {
    _selection = State(initialValue: selection)
    self.onDone = onDone
  }

  var body: some View {
    NavigationView {
      FamilyActivityPicker(selection: $selection)
        .navigationTitle("Apps that count")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { onDone(nil) }
          }
          ToolbarItem(placement: .confirmationAction) {
            Button("Done") { onDone(selection) }
          }
        }
    }
  }
}
