# App Privacy — StreakFlow (iOS)

Answers for App Store Connect → the app → **App Privacy** ("nutrition
labels"). Background: [IOS_LAUNCH.md](IOS_LAUNCH.md) sections 3.3 (ATT) and
3.5 (privacy manifest).

What the app does with data today:

- Habits, check-ins, streaks and settings stay on the device (Isar +
  shared_preferences). No account, no analytics SDK, no server.
- Premium is an Apple subscription (StoreKit), verified on the device.
- Feedback is sent through the user's own Mail app.
- The only data collection is the **Google Mobile Ads SDK (AdMob)**.

AdMob is declared even while release builds have ads off: the SDK is in the
binary, ads are turned on before launch, and the label covers the app, not one
build. Declaring a little early is safe; under-declaring risks rejection.

## Data collection

**Do you or your third-party partners collect data from this app?** →
**Yes, we collect data from this app**

Tick only these data types:

| Category | Data type |
|---|---|
| Location | **Coarse Location** (AdMob infers it from the IP address) |
| Identifiers | **Device ID** |
| Usage Data | **Product Interaction**, **Advertising Data** |
| Diagnostics | **Crash Data**, **Performance Data**, **Other Diagnostic Data** |

For each ticked data type:

| Question | Answer |
|---|---|
| Purposes | **Third-Party Advertising**, **Analytics** (Diagnostics: **Analytics** only) |
| Linked to the user's identity? | **No** (no account, nothing ties the data to a person) |
| Used for tracking? | **No** (see below) |

## Leave unticked

- **Contact Info, User Content, Health & Fitness** — habits and check-ins
  never leave the device; feedback goes through the user's Mail app, not the
  app.
- **Purchases** — Apple handles the subscription; StreakFlow only checks it on
  the device.
- **Financial Info, Contacts, Browsing/Search History, Sensitive Info, Precise
  Location, User ID, Photos, Audio, Body** — not used.

## Privacy Policy URL

streakflow-site `privacy-policy.html`. Update it first so it mentions iOS,
Apple and the App Store (IOS_LAUNCH.md section 2.5).

## "Used for tracking"

`ios/Runner/Info.plist` has no `NSUserTrackingUsageDescription`, so the app
never shows Apple's tracking prompt (ATT). Without it AdMob can't read the
advertising ID (IDFA) and serves non-personalized ads, so **No** is correct.

When the ATT prompt is added for personalized ads (IOS_LAUNCH.md section 3.3):

1. Change **Device ID**, **Advertising Data** and **Product Interaction** to
   **Used for tracking: Yes**.
2. Update `ios/Runner/PrivacyInfo.xcprivacy` to match (section 3.5).

Review these answers whenever an SDK that collects data is added (analytics,
crash reporting, sync).
