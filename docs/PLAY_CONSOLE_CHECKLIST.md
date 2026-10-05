# Play Console Checklist — StreakFlow

Answers for the Play Console forms, worked out from the code
(build `1.0.0+9`). Play Console → your app → **Policy and programs →
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

## 10. Production access

Personal developer accounts created after November 13, 2023 must run a
**closed test with at least 12 testers, opted in for 14 days in a row**,
before applying for production. Organization accounts are exempt.
Tester invite messages: [TESTER_INVITATION.md](../TESTER_INVITATION.md).

StreakFlow: 12 testers since about 26 Sep 2026 on Closed testing - Alpha,
so the earliest application date is about **10 Oct 2026**. Confirm on the
Play Console dashboard before applying.

### Application answers (draft)

Drafted 5 Oct 2026 from the release history (69 changes in builds 3 to 12
since the testers' first build, build 2). The questions follow Google's
production-access form as remembered; the wording on screen may differ.
**[fill in]** = only the owner knows: replace with real facts before
sending, since Google can compare answers with the testing data.

Before sending:

- [ ] Check Play Console → Android vitals for crashes on the latest build.
- [ ] Replace every **[fill in]** with what testers really did and said.

#### Part 1: The closed test

**How did you recruit testers?**
I invited friends, family and colleagues directly by WhatsApp and email,
using an opt-in link to the closed testing track. **[fill in: any other
channels]** 12 testers opted in and stayed opted in for at least 14 days.

**How easy was it to recruit testers?**
**[fill in: e.g. "Fairly easy: most people I asked joined within a day; a
few needed help with the opt-in link."]**

**Describe the engagement you received from testers.**
Testers created habits, completed them daily, and used the calendar,
statistics, reminders and achievements. I released 10 updates (builds 3 to
12) during the test, and testers updated through Google Play. **[fill in:
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
**[fill in: the honest range, e.g. "0-10,000"]**

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
a device. The last builds have no known crashes or open bugs **[fill in:
confirm against Android vitals]**, and purchase, restore and cancel were
tested end to end with Google Play license testing.

## 11. Each upload

- [ ] Bump `version:` in `pubspec.yaml` (the build number must increase).
- [ ] `flutter build appbundle --release` with `android/key.properties`
      present (signed with the upload key).
- [ ] Smoke-test a release APK of the same code on a device or emulator
      (`flutter build apk --release`, install, launch, onboarding, create and
      complete a habit). Debug runs and CI don't catch release-only crashes.
- [ ] Give every active track (Closed testing - Alpha, Internal testing)
      the new build, or the Advertising ID check can block releases.
- [ ] If the build turns ads on or off, update sections 2 and 4.
