# Demo data for screenshots

`streakflow_demo_backup.json` is a StreakFlow backup with 6 habits and 30 days
of history (17 Sep – 16 Oct 2026). It was used for the website screenshots on
17 Oct 2026.

Streaks only look right if the history ends yesterday, so make a fresh file on
the day you take screenshots:

```
python generate_demo_backup.py
```

Then, on the emulator:

1. `adb push streakflow_demo_backup.json /sdcard/Download/`
   (from Git Bash, prefix with `MSYS_NO_PATHCONV=1`)
2. StreakFlow → Settings → Back up or restore → Import Data → pick the file →
   Replace & Restore. This replaces all habits on that device.
3. Complete a few habits and tap +1 on Drink water, so today has activity and
   the app recalculates those streaks itself.

Use a test device or emulator only, never a phone with real habits.
