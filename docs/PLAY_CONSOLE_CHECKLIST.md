# Play Console Checklist — StreakFlow

Answers for the Play Console forms, worked out from the code
(build `1.0.0+9`; re-checked against build `1.0.0+13` on 6 Oct 2026:
permissions, ads off, 582 tests passing). Play Console → your app → **Policy and programs →
App content** holds most of them. Re-check this file whenever ads,
billing, permissions or SDKs change.

Two facts drive most answers:

- **Nothing leaves the device from the app itself.** No account, no
  backend, no analytics or crash SDK. Habits, logs, the profile (name,
  goals) and settings live in local storage; backups and CSV exports
  are files the user chooses to save or share.
- **Ads are a build switch.** Release builds without
  `--dart-define-from-file=config/ads/admob.production.json` have ads
  **off**: the Google Mobile Ads SDK is never initialized, no consent
  form, no ad requests. The SDK and the `AD_ID` permission are still in
  the app. See [ADMOB_SETUP.md](ADMOB_SETUP.md).

---

## 1. Privacy policy

`https://streakflow.codesapience.com/privacy-policy.html`
(same text as Settings → Privacy Policy; last updated October 3, 2026).

## 2. Ads

**Does your app contain ads?**

- Build without production ads config (current default): **No**.
- Build with `admob.production.json`: **Yes**.

Change this answer in the same release that turns ads on.

## 3. Advertising ID

The manifest contains `com.google.android.gms.permission.AD_ID` (added
by the Google Mobile Ads SDK), so Play asks:

- **Does your app use advertising ID?** **Yes**
- **Purposes:** **Advertising or marketing**, **Analytics**, **Fraud
  prevention, security, and compliance** (the same purposes as "Device
  or other IDs" in Data safety, section 4)

Answering No while the permission is in the manifest triggers a Play
warning. (Only change this if the ads SDK is removed.)

## 4. Data safety

"Collected" means sent off the device. Data processed only on the
device (habits, name, goals) is **not** collected. Purchases go through
Google Play Billing, which Google handles; the app only receives the
purchase status.

The answers below declare what the **ads SDK** collects when ads are
on. Declare them now if ads will be turned on in a later release (Play
accepts declaring an SDK's collection before it is active; it rejects
under-declaring). If you never plan to enable ads, remove the SDK
instead, and answer "No data collected".

**Does your app collect or share any of the required user data types?** Yes

**Is all of the user data collected by your app encrypted in transit?** Yes

**Do you provide a way for users to request that their data is deleted?**
No — the app keeps no user data on a server. (Users can reset or delete
their advertising ID in Android settings, and clear app data on the
device.)

Data types (all: **collected and shared** with Google AdMob,
**not required** — only when ads are shown to free users, processed
ephemerally: No):

| Category | Data type | Purposes |
|---|---|---|
| Location | Approximate location (from IP) | Advertising or marketing; Fraud prevention, security, and compliance |
| App activity | App interactions (ad views and taps) | Advertising or marketing; Analytics |
| App info and performance | Diagnostics | Analytics; Fraud prevention, security, and compliance |
| Device or other IDs | Device or other IDs (advertising ID) | Advertising or marketing; Analytics; Fraud prevention, security, and compliance |

Not collected: personal info (name, email…), financial info, health
and fitness, messages, photos and videos, audio, files and docs,
calendar, contacts, web browsing, search history.

Cross-check against Google's current AdMob disclosure:
<https://developers.google.com/admob/android/privacy/play-data-disclosure>

## 5. Content rating (IARC questionnaire)

- Category: **Utility, Productivity, Communication, or Other**
- Violence, sexuality, language, controlled substances, gambling: **No**
- Users can interact or exchange content with each other: **No**
- Shares the user's location with other users: **No**
- Allows purchases of digital goods: **Yes** (StreakFlow Premium subscription)
- Contains ads: answer as in section 2

Expected result: rated for everyone (e.g. PEGI 3 / ESRB Everyone).

## 6. Target audience and content

- Target age groups: **13–15, 16–17, 18 and over** (the privacy policy
  says the app is not directed at children under 13; selecting an
  under-13 group brings in the Families policy and its ad restrictions).
- Appeals to children: **No**

## 7. App access

**All functionality is available without special access** — there is no
login. Premium features are behind the subscription, which reviewers can
see on the paywall.

## 8. Other declarations

- **News app:** No
- **Health apps / health connect:** No (habit tracking, no health data
  or Health Connect)
- **Government app:** No
- **Financial features:** none
- **Foreground service / exact alarm / photo and video permissions:** not
  needed. The only foreground-service permission comes from WorkManager
  (bundled by the ads SDK) without a service type, and reminders use
  inexact alarms.

## 9. Subscription and license testing

Product and base plan IDs (from `lib/core/entitlements/premium_config.dart`):

| | ID |
|---|---|
| Subscription product | `streakflow_premium` |
| Base plans | `monthly`, `yearly` |

Setup steps and the purchase/restore test list are in
[PREMIUM_SETUP.md](PREMIUM_SETUP.md) (sections 3 and 4). Testing needs a
license-tester Google account on a real device with the Play-installed
build.

Last run 6 Oct 2026 (release build 12, same code as 13): plans load,
purchase, declined card, cancel → Free, reinstall restore and offline all
pass. Still open: pending (slow) card, second-device restore, unarchive at
the habit limit, ads hidden after purchase. Details in PREMIUM_SETUP.md §4.

## 10. Production access

Personal developer accounts created after November 13, 2023 must run a
**closed test with at least 12 testers, opted in for 14 days in a row**,
before applying for production. Organization accounts are exempt.
Tester invite messages: [TESTER_INVITATION.md](../TESTER_INVITATION.md).

StreakFlow: 12 testers since about 26 Sep 2026 on Closed testing - Alpha,
so the earliest application date is about **10 Oct 2026**. Confirm on the
Play Console dashboard before applying.

Latest build on both tracks: **1.0.0+13** (uploaded 6 Oct 2026). This is
the build to promote to production.

### Application answers (draft)

Drafted 5 Oct 2026 from the release history (69 changes in builds 3 to 12
since the testers' first build, build 2). The questions follow Google's
production-access form as remembered; the wording on screen may differ.
**[fill in]** = only the owner knows: replace with real facts before
sending, since Google can compare answers with the testing data.

Before sending:

- [x] Check Play Console → Android vitals for crashes on the latest build (none, 6 Oct).
- [ ] Replace every **[fill in]** with what testers really did and said.

#### Part 1: The closed test

**How did you recruit testers?**
I invited friends, family and colleagues directly by WhatsApp and email,
using an opt-in link to the closed testing track. 12 testers opted in and
stayed opted in for at least 14 days.

**How easy was it to recruit testers?**
Fairly easy. Most people I asked joined within a day; a few needed help
with the opt-in link.

**Describe the engagement you received from testers.**
Testers created habits, completed them daily, and used the calendar,
statistics, reminders and achievements. I released 11 updates (builds 3 to
13) during the test, and testers updated through Google Play. **[fill in:
what Play Console shows, or what testers said they used most]**

**Summarise the feedback and how you collected it.**
Feedback came through direct messages, the in-app "Send feedback" email,
and my own daily testing on a real device. **[fill in: 2-3 real points
testers raised]** One important issue appeared in testing: an update closed
immediately on launch on a real phone. I traced it to code shrinking in the
release build, fixed it in the next build, and now launch every release
build on a device before uploading.

#### Part 2: The app

**Intended audience**
Adults and teenagers (13+) who want to build daily or weekly habits, such
as health, fitness, study, finance or mindfulness routines, and track their
progress without creating an account.

**How does your app provide value?**
StreakFlow tracks habits with streaks that follow each habit's real
schedule, so a Mon/Wed/Fri habit is never "broken" on its off days. It adds
reminders, a calendar history, statistics and achievements, and works fully
offline with data stored on the device. New users get starter habits for
their chosen goals during setup. The free version supports up to 20 habits;
an optional Premium subscription through Google Play adds unlimited habits,
advanced insights, reports, themes and multiple reminders per habit.

**Expected installs in the first year**
0–10,000

#### Part 3: Production readiness

**What did you change based on what you learned in testing?**

- Stability: fixed a release-only crash at launch, and added a release-build
  check before every upload.
- Accuracy: corrected streak and statistics calculations, stopped counting
  days a habit isn't scheduled as missed, showed completion rates correctly,
  and made Undo after deleting a habit restore its history.
- Reminders: the Notifications switch now really turns reminders on and off,
  reminders follow each habit's schedule, and Premium users can set several
  reminder times.
- Onboarding and ease of use: starter habit suggestions for the goals chosen
  during setup, habit ideas when adding a habit, clearer form errors, fixed
  icons and labels.
- Free plan raised from 5 to 20 habits so new users can build a real routine
  before deciding on Premium.
- Works fully offline: fonts are now built into the app.
- Premium: Google Play subscriptions with purchase recovery and restore,
  tested with license testers.
- Privacy: the privacy policy now matches the app exactly (optional name;
  ads only in the free version).

**How did you decide the app is ready for production?**
The closed test ran for more than 14 days with 12 testers. Every release
passes 582 automated tests and a manual launch test of the release build on
a device. Android vitals show no crashes or ANRs on the latest builds, and
purchase, restore and cancel were tested end to end with Google Play
license testing.

## 11. Production release

### Before applying (~10 Oct 2026)

- [ ] Dashboard shows **12 testers opted in for 14 days** (requirement met).
- [x] Android vitals: no crashes or ANRs on build 13 (checked 6 Oct).
- [ ] Every **[fill in]** in section 10 replaced with real facts.
- [ ] Premium tests still open (section 9) done on a real phone, or
      accepted as known gaps.

### Before the first production release

Policy and setup:

- [ ] Policy and programs → App content: every declaration shows complete
      (privacy policy, ads, advertising ID, data safety, content rating,
      target audience, app access, other declarations).
- [ ] Ads answer matches the build: build 13 has ads **off** (built without
      `admob.production.json`), so "Contains ads" = **No**.
- [ ] Monetize → Subscriptions: `streakflow_premium` is **Active**, and both
      base plans `monthly` and `yearly` are **Active**, priced, and
      available in every production country.
- [ ] Payments profile is verified (merchant account can receive payouts).

Store listing:

- [ ] Store listing complete: app name, short and full description, icon,
      feature graphic, phone screenshots.
- [ ] Listing mentions the optional Premium subscription; Play adds
      "Contains in-app purchases" automatically.
- [ ] Short and full description replaced with the text below (Main store
      listing → App details).

App name (max 30): `StreakFlow: Habit Tracker`

Short description (max 80):

```
Habit tracker with smart streaks, reminders and stats. No account needed.
```

Full description (max 4,000):

```
StreakFlow helps you build better habits, one day at a time.

Track daily or weekly habits with streaks that follow each habit's real schedule. A Mon/Wed/Fri workout is never "broken" on a Tuesday, so your streak shows your true consistency.

WHY STREAKFLOW
• Smart streaks: daily habits or chosen weekdays, and days off never count as missed
• Reminders: a gentle nudge at the time you choose
• Calendar history: see every completed day at a glance
• Statistics: completion rates, current and best streaks, progress over time
• Achievements, XP and levels to keep you motivated
• Quick start: pick your goals (health, fitness, productivity, learning, finance, mindfulness) and get starter habits in seconds
• Archive habits you've paused without losing their history
• Backup and restore your data to a file

PRIVATE BY DESIGN
• No account, no sign-up
• Your habits stay on your device
• Works fully offline

FREE
Everything above, with up to 20 active habits.

STREAKFLOW PREMIUM (optional)
• Unlimited habits
• Productivity score: one weekly score from your completion, consistency and streaks
• Advanced insights: best days, strongest and weakest habits, week-over-week trends
• Weekly and monthly reports you can share
• Premium color themes for light and dark mode
• Advanced achievements for long-term milestones
• CSV export for spreadsheets
• Up to 5 reminder times per habit

Premium is a monthly or yearly subscription through Google Play. It renews automatically unless cancelled at least 24 hours before the end of the current period. Manage or cancel it anytime in Google Play → Payments & subscriptions.

Privacy policy: https://streakflow.codesapience.com/privacy-policy.html
Terms: https://streakflow.codesapience.com/terms.html

Small steps. Big change. Start your streak today.
```

The description leaves out ads and "ad-free" on purpose, because build 13
has ads off. If a later build turns ads on, add "Premium removes ads" and
update sections 2 and 4.
- [ ] Contact email and website (`https://streakflow.codesapience.com`) set.

Production track:

- [ ] Production → Countries/regions: choose where to launch.
- [ ] Production → Create new release → **Add from library** → build 13
      (same version code as the testing tracks; don't upload it again).
- [ ] Release name `1.0.0 (13)` and release notes (below).

Release notes, production (max 500 characters per language):

```
<en-US>
Welcome to StreakFlow — build better habits, one day at a time.

• Track daily or weekly habits with streaks that follow each habit's schedule
• Reminders, calendar history, statistics and achievements
• Starter habits for your goals during setup
• Works offline; your data stays on your device, no account needed
• Free: up to 20 habits. Optional Premium: unlimited habits, advanced insights, reports, themes, CSV export and multiple reminders
</en-US>
```

Release notes, testing tracks (build 13 has the same app code as 12):

```
<en-US>
Release candidate for the public launch. No new features since the last update. Thanks for testing StreakFlow!
</en-US>
```
- [ ] Rollout: start with a **staged rollout** (e.g. 20%), then raise to
      100% if vitals stay clean for a few days.
- [ ] Send for review. Publishing overview → turn off managed publishing
      unless you want to choose the go-live moment yourself.

### After going live

- [ ] Install from the public Play listing on a real phone: launch,
      onboarding, create and complete a habit.
- [ ] Premium page shows real prices; with a license-tester account, a test
      purchase still works on the production build.
- [ ] Watch Android vitals and reviews daily for the first week.
- [ ] Keep the closed and internal tracks: future builds go to testing
      first, then promote to production (section 12).
- [ ] Pending: Sync and AI Coach start only after launch (on hold until
      then).

## 12. Each upload

- [ ] Bump `version:` in `pubspec.yaml` (the build number must increase).
- [ ] `flutter build appbundle --release` with `android/key.properties`
      present (signed with the upload key).
- [ ] Smoke-test a release APK of the same code on a device or emulator
      (`flutter build apk --release`, install, launch, onboarding, create and
      complete a habit). Debug runs and CI don't catch release-only crashes.
- [ ] Give every active track (Closed testing - Alpha, Internal testing)
      the new build, or the Advertising ID check can block releases.
- [ ] After launch: once a build is checked on testing, promote it to
      Production with **Add from library** (staged rollout).
- [ ] If the build turns ads on or off, update sections 2 and 4.
