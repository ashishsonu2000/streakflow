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

## 11. Each upload

- [ ] Bump `version:` in `pubspec.yaml` (the build number must increase).
- [ ] `flutter build appbundle --release` with `android/key.properties`
      present (signed with the upload key).
- [ ] If the build turns ads on or off, update sections 2 and 4.
