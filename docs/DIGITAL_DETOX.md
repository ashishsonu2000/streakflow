# Digital Detox — screen-time limit habit (plan)

Planned for 1.1, on a new branch `feature/digital-detox`. Not started; don't
ship it in the builds under review (iOS 1.0.0+21, Play re-application).

## Idea

- New habit type **"Screen-time limit"**, e.g. *Digital detox: under 2h
  screen time a day*.
- **Limit reached** → local notification with a rotating suggestion:
  *"You've reached 2h of screen time today. Try a 10-minute walk 🚶"* (walk,
  read 5 pages, stretch, drink water, call a friend, 5-minute breathing).
- Optional **early warning** at 80%: *"24 minutes left of your 2h limit."*
- **Streak**: the day is done automatically if the user stays under the limit
  by midnight.
- Usage data stays on the device ("private, offline").

## Platforms

| | Android | iPhone |
|---|---|---|
| API | `UsageStatsManager` | Screen Time API (FamilyControls + DeviceActivity) |
| User permission | "Usage access" (system settings; open them from the app with an explanation) | Screen Time authorization, **iOS 16+** (app supports iOS 14) |
| Reads usage minutes? | Yes, total and per app | **No.** Only a callback when a threshold is reached |
| Limit alert | WorkManager check every 15 min (up to ~15 min late) | Exact: DeviceActivityMonitor extension posts the notification |
| Approval | None. Avoid `QUERY_ALL_PACKAGES` (restricted by Play) | **Family Controls (Distribution) entitlement** from Apple, days to weeks, not guaranteed |
| Effort | ~2–3 days (Kotlin bridge, worker, Flutter UI) | ~1–2 weeks (Swift extension, extra signing target/profile in Codemagic, SwiftUI report view) |

## Phases

1. **Phase 1 — Android**: screen-time habit counting total daily screen time;
   notification at the limit (optional 80% warning); auto-complete when under
   the limit.
2. **Phase 1 — iPhone**: same habit as a manual check-in ("Did you stay under
   2h today?") until Phase 2.
3. **Phase 2 — iPhone**: after the entitlement is approved, DeviceActivity
   extension for real limit alerts (iOS 16+).
4. **Phase 3**: per-app limits (e.g. only Instagram, YouTube), possibly
   Premium.

To keep in mind:

- Habits need a new **type** field: Isar schema change and migration; backup
  codec and CSV export too.
- Update the privacy policy (in-app and both sites) and Play **Data safety**:
  usage data is read on the device and never leaves it.

## Family Controls entitlement request (iOS)

Request it early: it takes the longest. Submit once **per bundle ID**: the
main app and each extension that uses Family Controls.

### 1. Register the extension bundle ID

1. <https://developer.apple.com/account> (Account Holder or Admin) →
   **Certificates, Identifiers & Profiles** → **Identifiers** → **+**.
2. **App IDs** → **Continue** → **App** → **Continue**.
3. Description `StreakFlow Device Activity Monitor`; Bundle ID (Explicit)
   `com.codesapience.streakflow.DeviceActivityMonitor`.
4. Capabilities: **App Groups** and **Family Controls** → **Continue** →
   **Register**.
5. Open the existing `com.codesapience.streakflow` App ID → tick **Family
   Controls** and **App Groups** → **Save**.

Ticking Family Controls here covers development builds only; App Store and
TestFlight need the approval below.

### 2. Open the form

It isn't linked from the site menus. Signed in, open
<https://developer.apple.com/contact/request/family-controls-distribution>.
If it shows a login or "not available" page, sign in again as the Account
Holder and reopen the link.

### 3. Fill it in

Field names may differ. Typical answers:

| Field | Answer |
|---|---|
| Team / account | CodeSapience |
| App name | StreakFlows |
| Bundle ID | `com.codesapience.streakflow`, then a second request for `com.codesapience.streakflow.DeviceActivityMonitor` |
| App Store ID / link | 6827421629 |
| Who is it for? | **Individuals** managing their own screen time, not parental control |
| How will you use it? | Text below |

```text
StreakFlow is a habit tracker. We are adding a "Digital detox" habit where a user sets their own daily screen-time limit (e.g. 2 hours). We use FamilyControls with individual authorization (AuthorizationCenter.requestAuthorization(for: .individual)) so the user can choose which apps or categories count, and DeviceActivity (DeviceActivityMonitor extension with a threshold event) to send a local notification when the user reaches their own limit, with a healthy suggestion (walk, read, stretch). The day counts toward the habit's streak if the user stays under the limit. We do not block apps for others, do not use it for parental control, and no usage data leaves the device: the app never sees app names or usage totals, only the threshold event.
```

### 4. After submitting

- No confirmation or status page; request IDs may come by email. Forum
  reports range from a few days to several weeks.
- Approval may be per bundle ID or team-wide.
- Once approved, regenerate the distribution profiles in Codemagic so they
  include the entitlement (Phase 2).
- Phase 1 doesn't depend on it.

Sources:
[Apple Forums: Family Controls Request Form](https://developer.apple.com/forums/thread/735888),
[FamilyControls Distribution entitlement](https://developer.apple.com/forums/thread/828085),
[No response for 2 weeks](https://developer.apple.com/forums/thread/824665),
[Apple: Configuring Family Controls](https://developer.apple.com/documentation/xcode/configuring-family-controls.md).
