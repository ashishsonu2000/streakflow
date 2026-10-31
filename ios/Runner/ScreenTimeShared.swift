import Foundation
import UserNotifications

/// "Digital detox" state shared by the app (ScreenTimeBridge) and the
/// DeviceActivityMonitor extension through the App Group. Compiled into
/// both targets, so it uses Foundation and UserNotifications only.
enum ScreenTimeShared {
  static let appGroup = "group.com.codesapience.streakflow"

  static var defaults: UserDefaults {
    UserDefaults(suiteName: appGroup) ?? .standard
  }

  private static let limitsKey = "screen_time.limits"
  private static let enabledKey = "screen_time.enabled"
  private static let logKey = "screen_time.log"
  private static let debugKey = "screen_time.debug"

  /// The 1-minute test alert's activity (diagnostics panel).
  static let testActivity = "streakflow.test"

  // MARK: - Limits (from Dart: ScreenTimeSync -> "syncLimits")

  struct Limit: Codable {
    let id: String
    let title: String
    let limitMinutes: Int
    /// Scheduled days, yyyy-MM-dd.
    let days: [String]

    func isScheduled(on date: Date) -> Bool {
      days.contains(ScreenTimeShared.dayKey(date))
    }
  }

  static func saveLimits(_ raw: [[String: Any]], enabled: Bool) {
    let limits = raw.compactMap { item -> Limit? in
      guard let id = item["id"] as? String,
        let title = item["title"] as? String,
        let minutes = (item["limitMinutes"] as? NSNumber)?.intValue
      else { return nil }
      return Limit(
        id: id,
        title: title,
        limitMinutes: minutes,
        days: item["days"] as? [String] ?? []
      )
    }
    defaults.set(try? JSONEncoder().encode(limits), forKey: limitsKey)
    defaults.set(enabled, forKey: enabledKey)
  }

  static func limits() -> [Limit] {
    guard let data = defaults.data(forKey: limitsKey),
      let limits = try? JSONDecoder().decode([Limit].self, from: data)
    else { return [] }
    return limits
  }

  static func limit(for habitId: String) -> Limit? {
    limits().first { $0.id == habitId }
  }

  static var enabled: Bool { defaults.bool(forKey: enabledKey) }

  // MARK: - Day log

  /// Records "started" (monitoring ran that day) or "reached" (the
  /// limit was reached) for a habit and day. Kept for 14 days.
  static func record(_ kind: String, habitId: String, day: Date) {
    let entry = "\(kind)|\(habitId)|\(dayKey(day))"
    var log = defaults.stringArray(forKey: logKey) ?? []
    guard !log.contains(entry) else { return }

    let cutoff = dayKey(Calendar.current.date(byAdding: .day, value: -14, to: day) ?? day)
    log = log.filter { ($0.split(separator: "|").last.map(String.init) ?? "") >= cutoff }
    log.append(entry)
    defaults.set(log, forKey: logKey)
  }

  /// true = monitored and stayed under the limit, false = limit
  /// reached, nil = not monitored that day (unknown).
  static func dayResult(habitId: String, day: String) -> Bool? {
    let log = defaults.stringArray(forKey: logKey) ?? []
    if log.contains("reached|\(habitId)|\(day)") { return false }
    if log.contains("started|\(habitId)|\(day)") { return true }
    return nil
  }

  static func hasRecord(_ kind: String, habitId: String, day: Date) -> Bool {
    (defaults.stringArray(forKey: logKey) ?? []).contains("\(kind)|\(habitId)|\(dayKey(day))")
  }

  static func dayLog() -> [String] {
    defaults.stringArray(forKey: logKey) ?? []
  }

  // MARK: - Diagnostics

  /// Appends a timestamped line (last 40 kept) for the diagnostics panel,
  /// from the app and from the extension.
  static func debug(_ message: String) {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "MM-dd HH:mm:ss"

    var lines = defaults.stringArray(forKey: debugKey) ?? []
    lines.append("\(formatter.string(from: Date())) \(message)")
    if lines.count > 40 { lines.removeFirst(lines.count - 40) }
    defaults.set(lines, forKey: debugKey)
  }

  static func debugLines() -> [String] {
    defaults.stringArray(forKey: debugKey) ?? []
  }

  static func dayKey(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = .current
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }

  // MARK: - Notifications

  /// Ideas for a screen-free break, one per alert (same as Android).
  private static let suggestions = [
    "Try a 10-minute walk.",
    "Read 5 pages of a book.",
    "Stretch for 5 minutes.",
    "Drink a glass of water and look out the window.",
    "Call or message a friend instead of scrolling.",
    "Take 5 slow, deep breaths.",
    "Tidy up one small corner of your room.",
    "Write down three things you're grateful for.",
  ]

  /// Changes daily and differs between habits. (String.hashValue is
  /// randomized per launch, so a stable sum is used.)
  static func suggestion(habitId: String, day: Date) -> String {
    let seed = (habitId + dayKey(day)).unicodeScalars.reduce(0) { $0 &+ Int($1.value) }
    return suggestions[seed % suggestions.count]
  }

  static func format(_ minutes: Int) -> String {
    let hours = minutes / 60
    let rest = minutes % 60
    if hours == 0 { return "\(rest)m" }
    if rest == 0 { return "\(hours)h" }
    return "\(hours)h \(rest)m"
  }

  /// One notification per habit: the limit alert replaces the 80% one.
  static func notify(habitId: String, title: String, body: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default

    let request = UNNotificationRequest(
      identifier: "screen_time.\(habitId)",
      content: content,
      trigger: nil
    )
    UNUserNotificationCenter.current().add(request)
  }
}
