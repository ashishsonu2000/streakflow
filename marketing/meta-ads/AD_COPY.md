# StreakFlow: Meta / Instagram ad copy

Play link: https://play.google.com/store/apps/details?id=com.codesapience.streakflow
Only run app-install ads once the app is live in Production.

## Primary text (pick 1, A/B test 2–3)

1. Took a rest day and lost your streak? StreakFlow follows your real schedule. Set a habit for Mon, Wed, Fri and off days never count against you. Free, no account needed.
2. Build habits that stick. Reminders, a calendar view, stats and streaks. Works offline, no sign-up, free for up to 20 habits.
3. Drink water. Read 20 pages. Work out 3x a week. Track them all in one simple app and watch your streaks grow. 🔥

## Headlines (max ~40 chars)

- Off days don't break your streak
- Build habits that stick
- Free habit tracker, no account
- Track streaks that fit your week

## Description

Free on Google Play. No account, works offline.

## CTA button

Install Now (app-install campaign) or Learn More (traffic to streakflow.codesapience.com)

## Files

| File | Placement |
|---|---|
| post-1-offdays-1080x1080.png | Feed (FB/IG), carousel card 1 |
| post-2-free-1080x1080.png | Feed, carousel card 2 |
| post-3-progress-1080x1350.png | IG feed 4:5 (most screen space in feed) |
| story-flyer-1080x1920.png | Stories / Reels static (safe zones kept clear) |
| reel-15s-1080x1920.mp4 | Reels + Stories video. No audio: add trending music in Instagram, or let Meta add music |
| feed-video-15s-1080x1080.mp4 | Feed video |
| print-flyer-A5-300dpi.png | Print (A5, 300 dpi) |
| youtube-short-20s-1080x1920.mp4 | YouTube Shorts (with audio; Shorts-safe layout). Captions in ../SOCIAL_MEDIA_KIT.md |

Regenerate: `python make_creatives.py static video short` (needs Pillow + imageio-ffmpeg).

## Claims to keep accurate

- "Off days don't break your streak" = days a habit isn't scheduled. A missed *scheduled* day still resets it. Don't say "never lose your streak."
- Free plan = 20 habits. Update the creatives if that changes.
- Don't use the official Google Play badge without following Google's badge guidelines; the creatives use a plain text button instead.
