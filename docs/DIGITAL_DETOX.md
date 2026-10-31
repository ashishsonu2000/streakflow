# Digital Detox — screen-time limit habit (plan)

Planned for 1.1, on the branch `feature/digital-detox`. Don't ship it in the
builds under review (iOS 1.0.0+21, Play re-application).

## Phase 1: what's built

- **Habit form → Schedule → "Screen-time limit"** switch, with limits from
  30m to 8h (`HabitScreenTimeTile`). Stored as `screenTimeLimitMinutes` on
  the habit (nullable, so no migration); in backups and the CSV export
  (`screen_time_limit_minutes`). The daily target is hidden (done once a
  day).
- **Android**, after the user turns on **Usage access** (button on the form
  and on the habit page):
  - `ScreenTime.kt` adds up foreground app time from `UsageStatsManager`
    events, following one app at a time and leaving out the launcher.
  - `ScreenTimeWorker.kt` (WorkManager, every 15 min) notifies once at 80%
    ("24m left") and once at the limit, with a rotating break idea, on the
    days the habit is scheduled. Its own channel "Screen-time limits".
    Follows the in-app "Habit Reminders" switch.
  - `ScreenTimeAutoCompleter` completes the last 3 days that stayed under the
    limit, at startup and on resume. Today is never auto-completed; days
    without usage data are skipped.
  - Habit page: "Screen time today" card with a progress bar.
- **iPhone**: see Phase 2. **No usage access** (or iOS 14–15): the habit is checked in by hand.
- Wiring: `screenTimeSyncProvider` (MainShell), channel
  `com.codesapience.streakflow/screen_time` (MainActivity.kt).
- Known limits: an auto-completed day that the user undoes is completed again
  at the next start; limits are re-sent for the next 14 days at every start.
- Before release: update the privacy policy (in-app and both sites): usage
  data is read on the device only. On Play, Usage access isn't a restricted
  permission and nothing leaves the device, so Data safety stays "no data
  collected" for it.

## Phase 2: iPhone (iOS 16+), what's built

Family Controls (Distribution) was approved **team-wide** on 2026-10-29.

- **Setup in the app**: the habit form / habit page button **Choose apps**
  asks for Screen Time permission (`requestAuthorization(for: .individual)`)
  and shows Apple's app picker. Choosing every category counts all apps.
  The choice is stored in the App Group.
- **Monitoring** (`ios/Runner/ScreenTimeBridge.swift`): one daily
  DeviceActivity per limit habit (named after the habit id) with a `warn`
  event at 80% and a `limit` event at the limit. iOS 17.4+ counts usage from
  midnight (`includesPastActivity`); earlier versions count from when
  monitoring started. Restarted only when limits, chosen apps or the
  reminders switch change.
- **Extension** (`ios/DeviceActivityMonitor/`, bundle ID
  `com.codesapience.streakflow.DeviceActivityMonitor`, iOS 16+): notifies at
  80% and at the limit (same wording and break ideas as Android) and logs
  `started` / `reached` per habit and day.
- **Auto-complete**: a past day is completed when it was monitored
  (`started`) and the limit wasn't `reached` (`dayResult`). The app never
  sees minutes, so the habit page shows whether alerts are on instead.
- **Shared state**: App Group `group.com.codesapience.streakflow`
  (`ios/Runner/ScreenTimeShared.swift`, compiled into both targets).
- iOS 14–15: manual check-in. The app weak-links FamilyControls,
  DeviceActivity and ManagedSettings so it still launches there.
- Written without a Mac; compiled and signed for the first time in TestFlight
  build 22 (2026-10-31, see below). The **ios-compile-check** workflow
  checks later native changes without uploading.

### Your setup before the first iOS build

All in <https://developer.apple.com/account> (Account Holder or Admin) →
**Certificates, Identifiers & Profiles**, then Codemagic.

**A. Register the App Group**

1. **Identifiers** (left sidebar) → blue **+** next to "Identifiers".
2. Select **App Groups** → **Continue**.
3. Description `StreakFlow`; Identifier `group.com.codesapience.streakflow`
   (exactly this; the code uses it).
4. **Continue** → **Register**.

**B. Main app ID**

1. **Identifiers** → filter (top right) **App IDs** → open
   `com.codesapience.streakflow`.
2. **Capabilities** tab:
   - tick **App Groups** → **Edit** / **Configure** → tick
     `group.com.codesapience.streakflow` → **Continue** / **Save**;
   - make sure **Family Controls** is ticked (team-wide approval covers
     distribution).
3. **Save** (top right) → **Confirm** the warning that profiles will be
   invalidated (step D replaces them).

**C. Extension app ID** (`com.codesapience.streakflow.DeviceActivityMonitor`)

1. **Identifiers** → filter **App IDs** → look for
   `com.codesapience.streakflow.DeviceActivityMonitor`. If it's there, open it
   and go to step 6.
2. Otherwise: blue **+** next to "Identifiers" → **App IDs** → **Continue**.
3. Type **App** (not App Clip) → **Continue**.
4. Description `StreakFlow Device Activity Monitor` (letters, numbers and
   spaces only); Bundle ID **Explicit**:
   `com.codesapience.streakflow.DeviceActivityMonitor` (exactly this; it must
   start with the app's bundle ID followed by a dot).
5. Leave App ID Prefix as your Team ID.
6. **Capabilities**:
   - tick **App Groups** (and, once registered, **Edit** / **Configure** →
     tick `group.com.codesapience.streakflow` → **Continue** / **Save**);
   - tick **Family Controls**.
   No other capabilities are needed (no Push Notifications: the alerts are
   local notifications).
7. New ID: **Continue** → check the summary → **Register**. Then open it from
   the list and do step 6 again if App Groups showed no group to pick while
   creating it. Existing ID: **Save** → **Confirm**.
8. Check: the list shows `com.codesapience.streakflow.DeviceActivityMonitor`
   with Platform iOS; opening it shows **App Groups** (1 group) and **Family
   Controls** ticked.

**Notes on B/C (2026-10-30)**

- **No Configure button next to App Groups** while creating an App ID is
  normal: Apple shows **Configure** / **Edit** only on an existing ID. Create
  it with the box ticked, then open it again and configure the group. Still
  no button after saving = the App Group isn't registered (A).
- **Don't delete identifiers.** `com.codesapience.streakflow` can't be deleted
  (the App Store Connect app uses it); deleting the App Group or the extension
  ID means doing A and C again, and also re-checking B (the group may be gone
  from the main ID too). If Apple then says an identifier "is not available",
  don't pick another name in the portal alone: the code and entitlements use
  these exact names and must be changed with it.

**D. Profiles**

Create the profiles in the developer portal, then fetch them in Codemagic.

1. **Old profiles**: **Profiles** → any App Store profile for these bundle IDs
   showing **Invalid** → **Remove** / **Delete**. A profile in use (e.g. the
   main app's) can stay: refresh it in step 3 instead.
2. **Extension profile**:
   1. **Profiles** → blue **+** next to "Profiles".
   2. **Distribution** → **App Store Connect** → **Continue** (not Ad Hoc or
      Development).
   3. **Select an App ID**: `com.codesapience.streakflow.DeviceActivityMonitor`
      (check the full name: not the main app, not a wildcard) → **Continue**.
   4. If shown: **Offline support** → default (No); **Additional
      entitlements** → **Family Controls (Distribution)** → **Continue**. Not
      shown is fine (team-wide approval adds it).
   5. **Select a certificate**: the **Apple Distribution** certificate Codemagic
      uses (latest expiry if several) → **Continue**.
   6. Name `StreakFlow DeviceActivityMonitor App Store` → **Generate**.
   7. Check: Type **App Store**, the extension App ID, Status **Active**,
      Enabled Capabilities include **App Groups** and **Family Controls**. No
      need to download it.
3. **Main app profile**: **Profiles** → the App Store profile for
   `com.codesapience.streakflow` → if **Invalid**, or **Active** without App
   Groups / Family Controls in its capabilities: **Edit** → certificate ticked
   → **Save** (regenerated under the same name). If there is none, create one
   as in step 2 with App ID `com.codesapience.streakflow`, name
   `StreakFlow App Store`.
4. **Codemagic**:
   1. <https://codemagic.io> → **Teams** → your team → **Team settings** →
      **codemagic.yaml settings** → **Code signing identities**.
   2. **iOS certificates** tab: the Apple Distribution certificate from 2.5 is
      listed (if not, stop: signing needs it with its private key).
   3. **iOS provisioning profiles** tab: delete old StreakFlow entries
      (**⋮** → **Delete**) → **Fetch profiles** → integration
      **`streakflow_asc`** → tick both profiles → reference names, e.g.
      `streakflow_appstore` and `streakflow_monitor_appstore` → **Download
      selected**.
   4. Check: both **App Store**, the right bundle IDs, future expiry, matched
      certificate.

**E. Compile check**

1. Codemagic → the StreakFlow app → **Start new build**.
2. Branch `feature/digital-detox`, workflow **iOS compile check (no
   signing)** → **Start new build** (~10–15 min). It doesn't need the
   profiles from D (TestFlight builds do).
3. If it fails, send the error from the "Build iOS (no codesign)" step.

**F. TestFlight builds** from this branch: bump the version and tag the
branch commit (`ios-vX.Y.Z-NN`, never `+`). Never attach a build from this
branch to an App Store version under review.

### Build 22 (TestFlight test build, 2026-10-31)

- `feature/digital-detox` at **1.0.0+22**, tag `ios-v1.0.0-22` (`6c88c51`).
  `main` stays at 1.0.0+21 (the 1.0 submission); the next build from `main`
  must be **25 or higher** (builds 22–24 came from this branch).
- First run: the IPA built, but signing failed:
  - `Provisioning profile "StreakFlow App Store" doesn't include the App
    Groups capability` (and Family Controls, the App Group, the
    entitlements): the main profile predated the new capabilities. Fix: D.3
    (**Edit** → **Save**) and fetch it again in Codemagic.
  - `Signing for "DeviceActivityMonitor" requires a development team`: no
    profile for the extension in Codemagic. Fix: D.2 and D.4.
- An earlier manual run of the release workflow at 1.0.0+21 built and signed,
  then failed to upload with `The provided entity includes an attribute with a
  value that has already been used`: build number 21 was already uploaded.
  Bump the build number before every upload.
- After the fixes, **Rebuild** (same tag) succeeded: the Swift code compiles
  and both targets sign.
- Codemagic profile reference names: `streakflow_appstore` (main app) and
  `streakflow_monitor_appstore` (extension). If Codemagic says a reference
  name is taken, delete the old entry first. If the extension ever loses its
  profile again, `codemagic.yaml` can list both by these names under
  `ios_signing.provisioning_profiles`.

### Builds 23 and 24 (diagnostics, 2026-10-31)

- Build 22 on the iPhone (iOS 27.0.1): no limit alert. **Build 23** added a
  hidden diagnostics panel: on a screen-time habit's page, tap **Screen time
  today** 5 times. It shows permissions, limits, what iOS monitors, the day
  log and the app's and extension's recent events, with a 1-minute test alert
  and Copy.
- What build 23 showed: permission approved, App Group ok, the extension runs
  and posts both alerts. But:
  1. The alerts were posted **while StreakFlow was open**, and never shown.
     flutter_local_notifications presents only notifications it created, and
     it drops the extension's. Fix: `AppDelegate` presents `screen_time.*`
     notifications itself.
  2. At every launch the Screen Time permission reads "not determined" for a
     moment. The app stopped monitoring, then restarted it, and iOS
     re-reported today's reached thresholds (at once, while the app was
     open). Fix: wait while the status is not determined, and re-check
     when it loads (`$authorizationStatus`).
  3. Each restart re-sent both alerts, and "6m left" could arrive after
     "limit reached". Fix: the extension alerts once per habit per day
     (`warned` / `reached` in the day log).
- **Build 24** (tag `ios-v1.0.0-24`) has these fixes.

### Device test checklist

**iPhone (TestFlight build 22, iOS 16+)**

1. Install **1.0.0 (22)** from TestFlight.
2. New habit → Schedule → **Screen-time limit** → **30m** → save.
3. **Choose apps** → allow Screen Time → pick a few apps (or all categories)
   → **Done**. The text says alerts are on and shows **Change apps**.
4. Use those apps ~24 minutes: **"6m left"** notification.
5. At 30 minutes: **"limit reached… Try …"** notification with a break idea.
6. A second habit with a high limit (e.g. **8h**): next day, open the app;
   yesterday is completed for it, not for the 30m one.

If something fails, note the step, the iOS version (Settings → General →
About), whether notifications are allowed for StreakFlows, and (step 6)
whether the habits were created before or after choosing the apps.

**Android (release APK on the emulator, Pixel_API_35)**

1. New habit → **Screen-time limit** → **30m** → **Allow usage access** →
   turn on StreakFlow → back to the app: the text says alerts are on.
2. Habit page: **Screen time today** shows minutes and a bar.
3. Use apps until 80% / the limit (the check runs every 15 minutes): the
   heads-up and the limit notification arrive.
4. Next day: yesterday is completed for a habit whose limit wasn't reached.

Status: iPhone and Android device tests pending.

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
