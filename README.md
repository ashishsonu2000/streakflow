# Streak Calculator Flutter

Native Flutter implementation of the original web streak calculator.

## Build

This folder contains the Flutter source. On a machine with Flutter installed:

```powershell
flutter create . --platforms=android,ios --project-name streak_calculator_flutter
flutter pub get
flutter build apk --release
```

The APK will be created under:

```text
build/app/outputs/flutter-apk/app-release.apk
```

For iOS, build on macOS with Xcode and valid Apple signing:

```bash
flutter create . --platforms=ios --project-name streak_calculator_flutter
flutter pub get
flutter build ipa --release
```

The IPA will be created under:

```text
build/ios/ipa/
```
