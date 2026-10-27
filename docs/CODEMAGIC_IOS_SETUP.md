# Codemagic iOS Setup — StreakFlow

Step-by-step setup for signed iOS builds and TestFlight uploads with
Codemagic (`codemagic.yaml`, workflow **iOS release -> TestFlight**). Bundle
ID: `com.codesapience.streakflow`. Background and the wider launch plan:
[IOS_LAUNCH.md](IOS_LAUNCH.md).

Status as of 2026-10-27: the Codemagic app is connected to
`gitlab.com/codesapience/streak_calculator` and finds `codemagic.yaml`. Build
#1 (tag `ios-v1.0.0-18`) failed at code signing with:

> No matching profiles found for bundle identifier "com.codesapience.streakflow"
> and distribution type "app_store"

because the Developer Portal integration and the signing certificate/profile
are not set up yet (steps 4–8 below).

---

## Part A — Apple (developer.apple.com / App Store Connect)

### 1. Apple Developer Program membership is active

<https://developer.apple.com/account> must show an active membership
(US$99/year). If enrollment is still pending, stop here — nothing below works
until it is approved.

### 2. Register the App ID

developer.apple.com → **Certificates, Identifiers & Profiles** →
**Identifiers** → **+** → **App IDs** → **App** → Continue:

- Description: `StreakFlow`
- Bundle ID: **Explicit** — `com.codesapience.streakflow`
- Capabilities: leave the defaults (In-App Purchase is included; Push
  Notifications is not needed — reminders are local notifications)

→ Continue → **Register**.

### 3. Create the app in App Store Connect

The TestFlight upload needs this app record to exist.

<https://appstoreconnect.apple.com> → **Apps** → **+** → **New App**:

- Platform: iOS
- Name: `StreakFlow` (must be unique on the App Store)
- Primary language: your choice
- Bundle ID: `com.codesapience.streakflow`
- SKU: `streakflow-ios`
- User access: Full access

→ **Create**.

For Premium, also: **Business** (Agreements, Tax, and Banking) → accept the
**Paid Apps** agreement. In-app purchases don't work until it shows
**Active**.

### 4. Create the App Store Connect API key

App Store Connect → **Users and Access** → **Integrations** →
**App Store Connect API** → **Team Keys** (the first time: **Request Access**
and accept) → **+** (Generate API Key):

- Name: `Codemagic`
- Access: **App Manager**

Then note:

- **Issuer ID** (shown above the key list)
- **Key ID**
- **Download** the `.p8` file — **Apple lets you download it only once.**
  Keep it safe and never commit it to the repo.

---

## Part B — Codemagic

All team settings are under the left sidebar → **Settings**.

### 5. Connect the Developer Portal

**Settings** → **Team integrations** → **Developer Portal** → **Connect**:

- **App Store Connect API key name:** `streakflow_asc` — exactly this;
  `codemagic.yaml` refers to it (`integrations: app_store_connect`)
- **Issuer ID** and **Key ID** from step 4
- **API key:** upload the `.p8` file

→ **Save**.

### 6. Generate the distribution certificate

**Settings** → **Code signing identities** → **iOS certificates** →
**Generate certificate**:

- Type: **Apple Distribution**
- Reference name: `streakflow_distribution`
- App Store Connect API key: `streakflow_asc`

→ **Generate**. Codemagic offers the `.p12` file and its password **once** —
download both and store them safely (needed to sign anywhere other than
Codemagic).

If Apple reports a certificate limit, revoke an unused distribution
certificate at developer.apple.com → Certificates, then retry.

### 7. Create the App Store provisioning profile

developer.apple.com → **Profiles** → **+**:

1. Distribution: **App Store Connect** → Continue
2. App ID: `com.codesapience.streakflow` → Continue
3. Certificate: the Apple Distribution certificate from step 6 (today's
   date) → Continue
4. Profile name: `StreakFlow App Store` → **Generate** (no need to download)

### 8. Fetch the profile into Codemagic

Codemagic → **Code signing identities** → **iOS provisioning profiles** →
**Fetch profiles** → select **StreakFlow App Store** → reference name
`streakflow_app_store` → **Download selected**.

This is the profile the `ios_signing` block in `codemagic.yaml`
(`distribution_type: app_store`, `bundle_identifier:
com.codesapience.streakflow`) looks for. Once it is listed, the
"No matching profiles found" error is gone.

### 9. Create the `ios_secrets` environment variable group

`codemagic.yaml` references the group `ios_secrets`, so create it even before
the ad IDs exist.

**Applications** → **streak_calculator** → **Environment variables** → add:

| Name | Value | Group | Secure |
|---|---|---|---|
| `ADMOB_IOS_APP_ID` | iOS AdMob **app** ID (`ca-app-pub-…~…`). Until it exists, Google's sample ID `ca-app-pub-3940256099942544~1458002511` | `ios_secrets` (create it) | ✓ |
| `ADMOB_PRODUCTION_JSON_BASE64` *(optional)* | Output of `base64 -w0 config/ads/admob.production.json` (Git Bash) | `ios_secrets` | ✓ |

Without `ADMOB_PRODUCTION_JSON_BASE64` the release build has **ads disabled**
(`AdConfig`), never test ads. If the production JSON contains iOS ad unit IDs
but `ADMOB_IOS_APP_ID` is missing, the build fails on purpose.

### 10. Start the build

**streak_calculator** → **Start new build** → **Build tag** →
`ios-v1.0.0-18` → workflow **iOS release -> TestFlight** →
**Start new build**.

The free `mac_mini_m2` takes roughly 15–25 minutes. On success Codemagic
uploads build `1.0.0 (18)` to App Store Connect.

---

## Part C — After the upload

### 11. TestFlight

1. Apple processes the build (~10–30 min) and sends an email.
2. App Store Connect → the app → **TestFlight** → **Internal Testing** →
   create a group and add yourself.
3. Install the **TestFlight** app on the iPhone and accept the invite.

The export-compliance question is pre-answered by
`ITSAppUsesNonExemptEncryption = false` in `ios/Runner/Info.plist`.

### 12. Premium in TestFlight

App Store Connect → **Monetization** → **Subscriptions** → create **one**
subscription group with two auto-renewable products:

- `streakflow_premium_monthly` — 1 month
- `streakflow_premium_yearly` — 1 year

(These match `PremiumConfig.appStoreMonthlyProductId` /
`appStoreYearlyProductId`.) Then **Users and Access** → **Sandbox** → create
a sandbox tester (a fresh email, not your Apple Account) to buy with. Sandbox
subscriptions renew every few minutes, so renewal and expiry can be tested
quickly.

---

## Every release

1. Bump `version:` in `pubspec.yaml` (the iOS build number must increase on
   every upload), merge to `main`.
2. Tag with a dash and push to both remotes:

   ```bash
   git tag -a ios-v1.0.0-19 -m "iOS 1.0.0 (19)" main
   git push origin ios-v1.0.0-19
   git push github ios-v1.0.0-19
   ```

3. **Never put `+` in the tag name.** Codemagic doesn't URL-encode it when
   reading `codemagic.yaml` from GitLab, so GitLab sees `ios-v1.0.0 19` and
   the build fails with "codemagic.yaml not found" (that's why
   `ios-v1.0.0+17` / `ios-v1.0.0+18` can't be built).
4. Builds start automatically on tag push only if the GitLab webhook exists:
   the app's **Webhooks** tab — add it if it's missing. Otherwise start the
   build by hand as in step 10.

## Troubleshooting

| Error | Cause / fix |
|---|---|
| `codemagic.yaml not found` | Tag name contains `+` (use `-`), or the tag/branch list is cached — reload the page and pick the ref again. |
| `No matching profiles found for bundle identifier … "app_store"` | Steps 5–8 not done: no Developer Portal integration, certificate, or App Store profile in Codemagic. |
| Integration `streakflow_asc` not found | The Developer Portal key name in step 5 doesn't match exactly. |
| Upload rejected: build number already used | Bump `version:` in `pubspec.yaml` and tag again. |
| No plans on the paywall in TestFlight | Products from step 12 missing, not in one group, or Paid Apps agreement not Active. |
