# TestFlight — What to Test

Text for App Store Connect → the app → **TestFlight** → build → **Test
Details** → **What to Test** (limit 4,000 characters). Update it for every
build.

## Build 1.0.0 (18) — first iOS build

Before pasting, check:

- **Premium (item 7)** works only once both subscriptions
  (`streakflow_premium_monthly`, `streakflow_premium_yearly`) exist in App
  Store Connect and the **Paid Apps** agreement is **Active**. If not, replace
  item 7 with: *"Premium – open the Premium screen and check it loads without
  crashing (purchases aren't set up yet)."*
- **Partial progress (item 3)**: delete "and log partial progress" if testers
  can't log partial progress in StreakFlow.

Paste the block below:

```text
Welcome to the first iOS build of StreakFlow! Please use it like a real habit tracker for a few days and tell us what breaks or feels wrong.

PLEASE TEST
1. First launch & onboarding – go through the intro and add a few suggested habits.
2. Habits – create, edit, duplicate, archive/unarchive and delete habits. Try different daily targets (e.g. 1 time vs. 8 glasses).
3. Daily check-ins – mark habits done, undo, and log partial progress. Check that streaks go up correctly and reset after a missed day.
4. Reminders – set a reminder, allow notifications, and confirm it arrives on time (also with the app closed).
5. Calendar & stats – check completion % and streak history. Today and past days should look right; future days should not count.
6. Scrolling & layout – long habit lists, the floating Add Habit button (hides while scrolling down), dark/light mode, different text sizes, iPhone and iPad if you have one.
7. Premium (sandbox) – open Premium, check that Monthly and Yearly plans show with prices, buy one with a Sandbox account, then try "Restore purchases" and "Manage subscription in the App Store". Sandbox purchases are free and renew every few minutes.
8. Send feedback – use the in-app feedback option to report anything.

KNOWN IN THIS BUILD
- Ads are turned off.
- A refunded sandbox subscription stays active until its current period ends.

HOW TO REPORT
Take a screenshot in the app and send it through TestFlight (or shake/screenshot → "Share Beta Feedback"). Please include your iPhone model, iOS version, and the steps that caused the problem.

Thank you for helping make StreakFlow better!
```
