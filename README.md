# StreakFlow

A habit tracker for Android and iOS, built with Flutter. Create habits,
complete them daily, and follow your streaks, goals, calendar, statistics
and achievements. Everything is stored on the device and works offline.

- **Package ID:** `com.codesapience.streakflow`
- **Status:** Google Play closed testing
- **Model:** Free, plus StreakFlow Premium as a Google Play subscription

## Features

| | Free | Premium |
|---|---|---|
| Habits, streaks, calendar, dashboard, reminders | ✅ | ✅ |
| Statistics, basic insights, achievements | ✅ | ✅ |
| Active habits | 5 | Unlimited |
| Reminders per habit | 1 | Up to 5 |
| Productivity score, advanced insights, weekly / monthly reports | — | ✅ |
| Color themes, advanced achievements, CSV export | — | ✅ |
| Ads | Banners (when ads are enabled) | None |

Backup export and restore are available to everyone. The full matrix
and the rules behind it are in [docs/PREMIUM_SETUP.md](docs/PREMIUM_SETUP.md).

## Tech stack

Flutter 3.44 (Dart ≥ 3.4) · Material 3 · Riverpod · Isar (community) ·
GoRouter · fl_chart · `in_app_purchase` (Google Play Billing) ·
`google_mobile_ads` (AdMob + UMP consent) · `flutter_local_notifications`

## Project structure

```
lib/
  app/        app widget, router, theme, constants
  core/       shared services: database, billing, entitlements, ads,
              notifications, UI components, utilities
  features/   one folder per feature, each split into
              data/ · domain/ · presentation/
              achievements, backup, calendar, dashboard, gamification,
              habits, notifications, onboarding, premium, profile,
              reminders, settings, statistics
  shell/      bottom-navigation shell
test/         mirrors lib/; data-layer tests run against a real Isar database
docs/         setup guides (see below)
config/ads/   AdMob build configs (the production file is gitignored)
```

## Getting started

Requirements: Flutter 3.44 stable, JDK 17 for Android builds, and Xcode 16+
on macOS for iOS builds.

```bash
flutter pub get
flutter run
```

Debug builds use Google's test ads automatically. To start as a Premium
user while developing, run
`flutter run --dart-define=DEV_ENTITLEMENT=premium` (ignored in release
builds).

### Code generation

The Isar schemas (`*.g.dart`) are committed. After changing an Isar
entity, regenerate them:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Checks

These are the same checks CI runs:

```bash
flutter analyze
flutter test
```

## Release builds

### Android

Play uploads must be signed with the upload key. Create
`android/key.properties` (gitignored, never commit it) with `storePassword`,
`keyPassword`, `keyAlias` and `storeFile`. Without it, release builds fall
back to the debug key. That is fine for checking the build compiles, but
the result can't be uploaded to Play.

```bash
# Closed testing, without ads (the default)
flutter build appbundle --release

# Closed testing, with Google test ads
flutter build appbundle --release --dart-define-from-file=config/ads/admob.test.json

# Production ads (copy admob.production.example.json to admob.production.json first)
flutter build appbundle --release --dart-define-from-file=config/ads/admob.production.json
```

The bundle is written to `build/app/outputs/bundle/release/app-release.aab`.
Bump `version:` in `pubspec.yaml` before each Play upload.

### iOS

```bash
flutter build ipa --release
```

This needs an Apple Developer certificate and provisioning profile.
Premium purchases are Android-only for now; on iOS the app runs in Free
mode.

## CI

- **GitHub Actions** (`.github/workflows/ci.yml`): analyze, test, an Android
  release build and an unsigned iOS build. Runs on pushes to `main`,
  `feature/**`, `fix/**`, `chore/**`, `ci/**` and `refactor/**`, and on
  pull requests.
- **GitLab CI** (`.gitlab-ci.yml`): analyze, test and an Android build on
  merge requests and the default branch, plus an optional manual upload to
  Play Internal testing.

## Documentation

- [docs/PREMIUM_SETUP.md](docs/PREMIUM_SETUP.md): the Premium entitlement
  architecture, the feature matrix and Play Console subscription setup.
- [docs/ADMOB_SETUP.md](docs/ADMOB_SETUP.md): the AdMob integration,
  consent, build environments and production ad IDs.
- [docs/PLAY_CONSOLE_CHECKLIST.md](docs/PLAY_CONSOLE_CHECKLIST.md): answers
  for the Play Console forms (Data safety, ads, content rating, target
  audience) and the per-upload checklist.
- [TESTER_INVITATION.md](TESTER_INVITATION.md): messages for inviting
  closed testers.
