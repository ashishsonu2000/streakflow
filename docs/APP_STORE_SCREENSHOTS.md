# App Store Screenshots — StreakFlow (iOS)

For App Store Connect → the app → version → **Previews and Screenshots**.
Background: [IOS_LAUNCH.md](IOS_LAUNCH.md) section 2.5.

## What exists already (none of it is usable for iOS)

| What | Where | Why not |
|---|---|---|
| Website screenshots (habits, calendar, details) | `streakflow-site/assets/screenshot-*.png` (480×1066) | Too small; captured on the Android emulator |
| Social posts / flyers | `marketing/meta-ads/*.png` | Marketing graphics, wrong sizes |
| Reel / short / user-guide videos | `marketing/meta-ads/*.mp4`, `marketing/user-guide-video/` | Android footage, wrong sizes for App Previews |
| Demo data | `marketing/demo/` | **Use this** for the habits shown in screenshots |

Play Store screenshots were uploaded straight to Play Console and aren't in
the repo. Android screenshots can't be reused: Apple rejects screenshots that
show an Android status or navigation bar.

## What App Store Connect needs

- **iPhone 6.9"**: **1320×2868** or **1290×2796**, portrait, 3–10 images.
  App Store Connect may accept 6.5" (1284×2778 or 1242×2688) instead; the
  upload page shows the sizes it wants.
- **iPad 13"** (2064×2752): only if the app supports iPad. IOS_LAUNCH.md
  section 3.6 recommends iPhone-only, which skips this.
- **App Previews** (videos): optional; skip for the first release.

## How to take them (no Mac needed)

1. Install the latest build from **TestFlight** on an iPhone, ideally a Pro
   Max / Plus model so screenshots come out at the 6.9" size directly.
2. Load the demo habits:
   - `python generate_demo_backup.py` in `marketing/demo/` (history must end
     yesterday, so run it on the day).
   - Copy `streakflow_demo_backup.json` to the iPhone (AirDrop, iCloud Drive,
     or email it to yourself → save to Files).
   - StreakFlow → **Settings → Back up or restore → Import Data → Replace &
     Restore**. This replaces all habits, so never use a phone with real
     habits.
3. Complete a few habits so today shows progress.
4. Screenshot with **Side button + Volume Up**. Suggested screens: habits
   list, calendar, habit details/stats, reminders, Premium.
5. AirDrop them to the PC, check the pixel size, and upload.

If the iPhone is a smaller model, the screenshots need padding or resizing to
1320×2868 (without stretching) before upload.
