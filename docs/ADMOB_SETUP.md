# AdMob Setup — Streak Flow

Developer guide for the Google Mobile Ads integration
(`google_mobile_ads` 9.1.0, Google Mobile Ads SDK + User Messaging Platform).

> **Golden rule:** development and closed testing use **Google test ads**.
> Never tap your own production ads, never ask testers to tap ads, and never
> generate artificial impressions or clicks. AdMob can limit or disable the
> account for invalid traffic.

---

## 0. How it fits together

```
lib/core/entitlements/entitlement_provider.dart   FREE / PREMIUM (no billing yet → FREE)
lib/core/ads/
  ad_config.dart            ADS_ENV + ad unit IDs (single source of truth)
  ad_consent_service.dart   UMP consent (Google's form; no custom dialog)
  ads_controller.dart       consent → canRequestAds → MobileAds.initialize()
  ad_providers.dart         Riverpod providers; activeAdUnitIdsProvider = the gate
  banner_ad_slot.dart       reusable inline adaptive banner
  interstitial_policy.dart  when an interstitial may appear
  interstitial_ad_service.dart
  rewarded_ad_service.dart
  full_screen_ad_gateway.dart / preloaded_ad_slot.dart   SDK adapter, preload/expiry
lib/shell/presentation/widgets/shell_tab_banner_ad.dart  banner that loads only on the visible tab
lib/features/settings/presentation/widgets/ad_privacy_options_tile.dart
lib/features/settings/presentation/pages/ads_test_page.dart  (debug builds only)
```

Current placements:

| Format        | Where                                                             |
|---------------|-------------------------------------------------------------------|
| Banner        | Last item of Dashboard, Calendar, Statistics content (free users) |
| Interstitial  | **Not placed anywhere yet** — service + policy only               |
| Rewarded      | **Not placed anywhere yet** — service only (no reward invented)   |

Ads are never requested during splash or onboarding (initialization starts in
`MainShell`), never block the UI, and every failure (offline, no fill, no
consent, SDK error) simply means "no ad".

---

## 1. Create an AdMob account

1. Go to <https://admob.google.com> and sign in with the Google account that
   should receive payments.
2. Complete the account + payment profile setup.

## 2. Register Streak Flow

1. AdMob → **Apps → Add app** → Android.
2. "Is the app listed on a supported app store?" — while the app is only in
   closed testing, choose **No**. You link the store listing later (step 12).
3. App name: `Streak Flow`.
4. Copy the **App ID** — it looks like `ca-app-pub-1234567890123456~1234567890`
   (note the **`~`**).
5. Repeat for iOS when you start iOS work (separate App ID).

## 3. Create ad units

AdMob → your app → **Ad units → Add ad unit**. Create three:

| Ad unit              | Format        | Dart define                      |
|----------------------|---------------|----------------------------------|
| Streak Flow Banner   | Banner        | `ADMOB_ANDROID_BANNER_ID`        |
| Streak Flow Interstitial | Interstitial | `ADMOB_ANDROID_INTERSTITIAL_ID` |
| Streak Flow Rewarded | Rewarded      | `ADMOB_ANDROID_REWARDED_ID`      |

Each **ad unit ID** looks like `ca-app-pub-1234567890123456/1234567890`
(note the **`/`**). New ad units can take up to an hour before serving.

## 4. Configure the App ID

**App ID (`~`) ≠ ad unit ID (`/`).** Putting an ad unit ID where the App ID is
expected crashes the app at launch.

| Platform | Where the App ID goes | How |
|---|---|---|
| Android | `AndroidManifest.xml` `com.google.android.gms.ads.APPLICATION_ID` | `--dart-define=ADMOB_ANDROID_APP_ID=ca-app-pub-…~…` (injected by `android/app/build.gradle.kts` as `${admobAppId}`) |
| iOS | `Info.plist` `GADApplicationIdentifier` | Edit `ios/Flutter/AdMob.xcconfig` (`ADMOB_IOS_APP_ID`) |

If no App ID is provided, Google's **sample** App ID is used, which only serves
test ads.

## 5–7. Configure Banner / Interstitial / Rewarded IDs

All values are build-time `--dart-define`s. The easiest way is a JSON file:

```bash
cp config/ads/admob.production.example.json config/ads/admob.production.json
# edit the real values in (this file is gitignored)
```

```json
{
  "ADS_ENV": "production",
  "ADMOB_ANDROID_APP_ID": "ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY",
  "ADMOB_ANDROID_BANNER_ID": "ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ",
  "ADMOB_ANDROID_INTERSTITIAL_ID": "ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ",
  "ADMOB_ANDROID_REWARDED_ID": "ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ",
  "ADMOB_IOS_BANNER_ID": "",
  "ADMOB_IOS_INTERSTITIAL_ID": "",
  "ADMOB_IOS_REWARDED_ID": ""
}
```

## 8. Test ads

`ADS_ENV` decides everything:

| `ADS_ENV`           | Debug / profile build | Release build |
|---------------------|-----------------------|---------------|
| *(not set)*         | Google **test** ads   | **Ads disabled** |
| `test`              | Google test ads       | Google test ads |
| `production`        | Real ads (validated)  | Real ads (validated) |
| `disabled`          | No ads                | No ads |

```bash
# Local development — test ads automatically
flutter run

# Closed-testing release build WITH test ads
flutter build appbundle --release --dart-define-from-file=config/ads/admob.test.json

# Closed-testing release build WITHOUT ads (today's behaviour, also the default)
flutter build appbundle --release
```

Debug-build helpers (ignored in release builds):

* **Settings → Testing → Ads Test**: status, consent, "Simulate premium",
  load/show interstitial (with or without policy), rewarded with reward
  counter, privacy options form, a banner.
* `--dart-define=DEV_ENTITLEMENT=premium` — start as a premium user.
* `--dart-define=UMP_DEBUG_GEOGRAPHY=eea` and
  `--dart-define=UMP_TEST_DEVICE_ID=<id>` — force the EEA consent flow. The
  hashed device ID is printed in logcat by the UMP SDK on first run.

If you ever need production IDs on a physical test device, register it as a
**test device** in AdMob → Settings → Test devices first.

## 9. Production IDs

```bash
flutter build appbundle --release --dart-define-from-file=config/ads/admob.production.json
```

**Fail-fast validation:**

* **Android Gradle** — with `ADS_ENV=production`, the build **fails** unless
  `ADMOB_ANDROID_APP_ID` is a real `~` App ID and all three Android ad unit IDs
  are real `/` IDs (Google test publisher `3940256099942544` is rejected).
* **Dart** — if production IDs are missing/invalid at runtime (e.g. an iOS
  build), ads are **disabled**; it never falls back to test IDs.
* A release build without `ADS_ENV` has ads disabled, so test IDs can never
  ship by accident.

### CI/CD variables

Nothing in `.gitlab-ci.yml` or GitHub Actions was changed; both keep building
as today (release = ads disabled). To produce an ad-enabled build in GitLab CI,
add these **CI/CD variables** (AdMob IDs are not secret, but mark them
protected so feature branches cannot build production):

| Variable | Example shape |
|---|---|
| `ADS_ENV` | `production` (or `test`) |
| `ADMOB_ANDROID_APP_ID` | `ca-app-pub-…~…` |
| `ADMOB_ANDROID_BANNER_ID` | `ca-app-pub-…/…` |
| `ADMOB_ANDROID_INTERSTITIAL_ID` | `ca-app-pub-…/…` |
| `ADMOB_ANDROID_REWARDED_ID` | `ca-app-pub-…/…` |
| `ADMOB_IOS_BANNER_ID` / `…_INTERSTITIAL_ID` / `…_REWARDED_ID` | iOS only |

and pass them to the build command, e.g.:

```bash
flutter build appbundle --release \
  --dart-define=ADS_ENV=$ADS_ENV \
  --dart-define=ADMOB_ANDROID_APP_ID=$ADMOB_ANDROID_APP_ID \
  --dart-define=ADMOB_ANDROID_BANNER_ID=$ADMOB_ANDROID_BANNER_ID \
  --dart-define=ADMOB_ANDROID_INTERSTITIAL_ID=$ADMOB_ANDROID_INTERSTITIAL_ID \
  --dart-define=ADMOB_ANDROID_REWARDED_ID=$ADMOB_ANDROID_REWARDED_ID
```

## 10. Consent (UMP)

Implemented per <https://developers.google.com/admob/flutter/privacy>:
`requestConsentInfoUpdate` on every launch → `loadAndShowConsentFormIfRequired`
→ `canRequestAds()` gate → `MobileAds.initialize()`. When UMP reports
`PrivacyOptionsRequirementStatus.required`, **Settings → Legal & Privacy → Ad
Privacy Choices** appears and opens Google's privacy options form.

The app shows **no custom consent UI**. For the form to appear at all you must
create the messages in AdMob:

1. AdMob → **Privacy & messaging**.
2. **European regulations (GDPR)** message → create, select Streak Flow,
   add the privacy policy URL, publish.
3. **US state regulations** message → create and publish (recommended).
4. (iOS later) IDFA explainer message only if you add App Tracking
   Transparency.

Without a published message, UMP reports consent as not required and ads load
normally outside regulated regions.

## 11. app-ads.txt

`app-ads.txt` lets buyers verify that your AdMob account is authorized to sell
Streak Flow inventory.

1. In Play Console → **Store presence → Store settings**, set the developer
   **website** to `https://codesapience.com` (exact domain matters).
2. AdMob → **Apps → View all apps → app-ads.txt** tab → **How to set up
   app-ads.txt** → copy the line Google shows you. It has the form
   `google.com, pub-<YOUR PUBLISHER ID>, DIRECT, <Google's certification ID>`.
   **Copy it exactly from AdMob** — do not type it by hand; this repository
   intentionally contains no publisher ID.
3. Host it as plain text at the domain root:
   **`https://codesapience.com/app-ads.txt`** (not in a subfolder; HTTP 200;
   `text/plain`; no redirects to another domain).
4. Verify: open the URL in a browser; then in AdMob → app-ads.txt tab click
   **Check for updates**. Crawling can take 24 hours or more, and only works
   once the app is linked to its **public** Play listing (step 12).

## 12. Google Play app linking

A closed-test-only app is not publicly listed, so AdMob cannot link it yet.
After Streak Flow is published to production on Google Play:

AdMob → Apps → Streak Flow → **App settings → Add store** → search for
`com.codesapience.streakflow` → link.

## 13. AdMob app readiness

After linking, AdMob reviews the app ("app readiness"). Until approved, ad
serving is limited. Check AdMob → Apps → status. Common blockers: store listing
not linked, policy issues, missing app-ads.txt (warning, not a blocker).

## 14. Troubleshooting

| Symptom | Likely cause |
|---|---|
| App crashes at launch: "Missing application ID" / "invalid application ID" | App ID missing, or an ad unit ID (`/`) was used instead of the App ID (`~`) |
| Gradle: `ADS_ENV=production but AdMob configuration is invalid` | Working as intended — fill in real IDs |
| No banner in a release build | `ADS_ENV` not set (ads disabled by default in release) |
| No banner, logcat `[Ads] … code 3` (no fill) | Normal for new ad units / new apps; wait, or use test ads |
| No ads at all in EEA | Consent not given, or no GDPR message published in AdMob |
| Ad privacy choices tile missing | Not required for this user/region (expected) |
| Premium user still sees ads | Should not happen: check `entitlementProvider` state on the Ads Test page |

All ad logs are prefixed `[Ads]` and printed only in debug builds
(`AppLogger`). No personal data or advertising IDs are logged.

## 15. Common mistakes

* Testing with production ad units (invalid traffic). Use test ads.
* Asking testers or friends to click ads.
* Swapping App ID and ad unit ID.
* Releasing without updating the **Privacy Policy** (the in-app policy and
  `codesapience.com` policy must disclose AdMob / advertising data).
* Forgetting the Play Console **Ads**, **Advertising ID** and **Data safety**
  declarations (the SDK adds the `AD_ID` permission).
* Showing interstitials after habit completion, on navigation, or at launch.
* Granting a rewarded benefit before `onUserEarnedReward`.

## 16. Disable ads temporarily

* Build without `ADS_ENV` (release) or with `--dart-define=ADS_ENV=disabled`.
  The SDK is still linked but never initialized and never requests ads.
* Remote/kill-switch control is not implemented; it would require a remote
  config service.

---

## Adding a placement later

**Interstitial** (only at a natural break, e.g. after closing a review screen):

```dart
final ads = ref.read(interstitialAdServiceProvider);
ads.recordMeaningfulAction();   // e.g. user finished reviewing statistics
unawaited(ads.preload());       // well before the break
// …at the break:
await ads.showIfEligible();     // obeys InterstitialPolicy; never throws
```

Default policy (`InterstitialPolicy`): 3 min launch grace, 5 min cooldown,
6 meaningful actions, max 2 per session, never for premium.

**Rewarded** (user taps an explicit "Watch an ad to …" button):

```dart
final rewarded = ref.read(rewardedAdServiceProvider);
final result = await rewarded.show(onReward: (_) => grantBenefit());
if (result == RewardedAdResult.skippedPremium) grantBenefit(); // premium: no ad
```

**Premium** — when billing is added, only `EntitlementNotifier.build()` (and a
verified purchase listener) changes; ads react automatically.
