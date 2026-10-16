# StreakFlow – Tester Feedback Ideas & Release Plan

These ideas come from a review of the StreakFlow codebase. Each one is something
the app doesn't do yet, or does in a way a tester would likely notice.

## Before sharing with testers

- Ask each tester to **open the app, try the screen the comment is about, and
  rewrite it in their own words** before submitting it through Play Store feedback.
- **Give each tester 2–3 different items**, not the whole list.
- Google's review of testing feedback looks at engagement. If many testers paste
  the same text, it reads as fake engagement and can hurt the production
  re-application (planned for on or after 26 Oct 2026).

---

## Feedback comments testers can adapt

### Streaks & habits

1. "Missing one day because I was sick reset my whole streak. A 'streak freeze' or
   rest-day option would stop me feeling like quitting after one miss."
2. "Please add a vacation or pause mode for travel, so habits aren't counted as
   missed while I'm away."
3. "I'd like to drag and drop habits to reorder them. My morning habits should be
   at the top."
4. "When I tick the wrong habit, it would be nice to undo it right from the
   snackbar, without opening the habit."
5. "Could I add a short note when I complete a habit, like 'ran 5 km' or 'read
   chapter 3', and see those notes in the calendar later?"
6. "For count-based habits (like 8 glasses of water), a quick +1 button on the
   dashboard card would be faster."

### Home screen & reminders

7. "A home screen widget for checking off today's habits without opening the app
   would be the most useful addition."
8. "Reminders should have a 'Done' action right in the notification."
9. "A smart reminder would help: 'You haven't done X today' in the evening, only if
   it's still pending."
10. "Allow snoozing a reminder for 30 minutes or 1 hour."

### Insights & motivation

11. "The stats are nice, but I'd like to see which weekday I miss most often. That
    would be a really useful insight."
12. "A weekly summary notification every Sunday, like 'You completed 82% this
    week', would keep me motivated."
13. "Please let me share a streak milestone as an image card (e.g. 30 days) to
    Instagram or WhatsApp."
14. "Achievements are fun. Showing the next achievement and how close I am on the
    dashboard would push me further."

### Personalisation, privacy & polish

15. "Please add an app lock with fingerprint or PIN. Some of my habits are
    personal."
16. "Hindi (and other Indian languages) support would help my family use the app."
17. "On the first launch, the onboarding could explain how streaks are counted for
    habits that aren't daily (e.g. 3x a week)."
18. "Backup works, but an automatic weekly backup reminder would stop me losing data
    if I change phones." (This also prepares users for sync later.)

---

## Suggested release plan

| Release | Items | Why |
|---|---|---|
| **Next release (build 15)** | 3 (reorder), 4 (undo snackbar), 8 (Done in notification), 10 (snooze), 17 (onboarding text) | Small, quick to build, easy to notice |
| **Release after that** | 1 (streak freeze), 2 (vacation mode), 5 (completion notes), 6 (+1 button), 11 (weekday insight), 12 (weekly summary) | Core retention features; streak freeze and weekly summary could be Premium hooks |
| **Third release** | 7 (home screen widget), 13 (share card), 15 (app lock), 16 (Hindi), 9, 14, 18 | Bigger work: needs the `home_widget` and `local_auth` packages and localization setup |

**Note:** localization (`l10n`) isn't set up yet. If more languages are planned, set up
string extraction early so later features don't add more hard-coded text.

---

## Release notes style

Credit the testers, so Google can see you act on tester feedback:

> You asked, we built it: drag to reorder habits, mark habits done straight from
> the notification, and snooze reminders.
