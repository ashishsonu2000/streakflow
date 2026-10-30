import DeviceActivity
import Foundation

/// "Digital detox" limit alerts on iPhone (iOS 16+). The app starts one
/// daily DeviceActivity per limit habit, named after the habit id, with
/// a "warn" event at 80% and a "limit" event at the limit
/// (ScreenTimeBridge.swift). iOS calls this extension when an event's
/// threshold is reached; the app itself never sees usage minutes.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {

  /// Start of each day's monitoring: the day counts as monitored, so it
  /// can be completed tomorrow if the limit isn't reached.
  override func intervalDidStart(for activity: DeviceActivityName) {
    super.intervalDidStart(for: activity)

    let now = Date()
    guard let limit = ScreenTimeShared.limit(for: activity.rawValue),
      limit.isScheduled(on: now)
    else { return }

    ScreenTimeShared.record("started", habitId: limit.id, day: now)
  }

  override func eventDidReachThreshold(
    _ event: DeviceActivityEvent.Name,
    activity: DeviceActivityName
  ) {
    super.eventDidReachThreshold(event, activity: activity)

    let now = Date()
    guard ScreenTimeShared.enabled,
      let limit = ScreenTimeShared.limit(for: activity.rawValue),
      limit.isScheduled(on: now)
    else { return }

    let limitText = ScreenTimeShared.format(limit.limitMinutes)

    if event.rawValue == "limit" {
      ScreenTimeShared.record("reached", habitId: limit.id, day: now)
      ScreenTimeShared.notify(
        habitId: limit.id,
        title: "\(limit.title): limit reached",
        body: "You've reached your \(limitText) screen-time limit for today. "
          + ScreenTimeShared.suggestion(habitId: limit.id, day: now)
      )
    } else if event.rawValue == "warn" {
      let left = ScreenTimeShared.format(limit.limitMinutes - limit.limitMinutes * 4 / 5)
      ScreenTimeShared.notify(
        habitId: limit.id,
        title: "\(limit.title): \(left) left",
        body: "You've used 80% of your \(limitText) screen-time limit today."
      )
    }
  }
}
