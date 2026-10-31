import DeviceActivity
import Foundation

/// "Digital detox" limit alerts on iPhone (iOS 16+). The app starts one
/// daily DeviceActivity per limit habit, named after the habit id, with
/// a "warn" event at 80% and a "limit" event at the limit
/// (ScreenTimeBridge.swift). iOS calls this extension when an event's
/// threshold is reached; the app itself never sees usage minutes.
///
/// Every callback is written to the diagnostics log (ScreenTimeShared.debug),
/// including why an alert was skipped.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {

  /// Start of each day's monitoring: the day counts as monitored, so it
  /// can be completed tomorrow if the limit isn't reached.
  override func intervalDidStart(for activity: DeviceActivityName) {
    super.intervalDidStart(for: activity)
    ScreenTimeShared.debug("extension: interval started \(short(activity))")

    let now = Date()
    guard let limit = ScreenTimeShared.limit(for: activity.rawValue),
      limit.isScheduled(on: now)
    else { return }

    ScreenTimeShared.record("started", habitId: limit.id, day: now)
  }

  override func intervalDidEnd(for activity: DeviceActivityName) {
    super.intervalDidEnd(for: activity)
    ScreenTimeShared.debug("extension: interval ended \(short(activity))")
  }

  override func eventDidReachThreshold(
    _ event: DeviceActivityEvent.Name,
    activity: DeviceActivityName
  ) {
    super.eventDidReachThreshold(event, activity: activity)
    ScreenTimeShared.debug("extension: \(event.rawValue) reached \(short(activity))")

    if activity.rawValue == ScreenTimeShared.testActivity {
      ScreenTimeShared.notify(
        habitId: "test",
        title: "StreakFlow test alert",
        body: "Screen-time alerts work: you used the chosen apps for 1 minute."
      )
      ScreenTimeShared.debug("extension: test notification posted")
      return
    }

    let now = Date()
    guard ScreenTimeShared.enabled else {
      ScreenTimeShared.debug("extension: skipped, reminders switched off")
      return
    }
    guard let limit = ScreenTimeShared.limit(for: activity.rawValue) else {
      ScreenTimeShared.debug("extension: skipped, no limit for this habit")
      return
    }
    guard limit.isScheduled(on: now) else {
      ScreenTimeShared.debug("extension: skipped, not scheduled today")
      return
    }

    let limitText = ScreenTimeShared.format(limit.limitMinutes)

    // iOS re-reports reached thresholds whenever monitoring restarts:
    // alert once per day, and never "left" after "limit reached".
    if ScreenTimeShared.hasRecord("reached", habitId: limit.id, day: now)
      || (event.rawValue == "warn"
        && ScreenTimeShared.hasRecord("warned", habitId: limit.id, day: now))
    {
      ScreenTimeShared.debug("extension: skipped, already alerted today")
      return
    }

    if event.rawValue == "limit" {
      ScreenTimeShared.record("reached", habitId: limit.id, day: now)
      ScreenTimeShared.notify(
        habitId: limit.id,
        title: "\(limit.title): limit reached",
        body: "You've reached your \(limitText) screen-time limit for today. "
          + ScreenTimeShared.suggestion(habitId: limit.id, day: now)
      )
    } else if event.rawValue == "warn" {
      ScreenTimeShared.record("warned", habitId: limit.id, day: now)
      let left = ScreenTimeShared.format(limit.limitMinutes - limit.limitMinutes * 4 / 5)
      ScreenTimeShared.notify(
        habitId: limit.id,
        title: "\(limit.title): \(left) left",
        body: "You've used 80% of your \(limitText) screen-time limit today."
      )
    }
    ScreenTimeShared.debug("extension: \(event.rawValue) notification posted")
  }

  private func short(_ activity: DeviceActivityName) -> String {
    String(activity.rawValue.prefix(8))
  }
}
