# App Store Listing — StreakFlow (iOS)

Text for App Store Connect → the app → version → **App Information** /
version page. Adapted from the Play listing in
[PLAY_CONSOLE_CHECKLIST.md](PLAY_CONSOLE_CHECKLIST.md): no Google Play
mentions (Apple rejects listings that name another platform), plus Apple's
required subscription terms. Background: [IOS_LAUNCH.md](IOS_LAUNCH.md)
section 2.5.

Before submitting, check:

- **Terms of Use (EULA)**: subscription apps must link one. `terms.html` works
  if it covers iOS; otherwise use Apple's standard EULA:
  `https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`.
- **Ads**: the text leaves out ads, like the Play listing. Once iOS ads are on,
  add "Premium removes ads" to the Premium list.
- **Privacy policy**: update `privacy-policy.html` to mention iOS, Apple and
  the App Store.

## App name (max 30)

The app record in App Store Connect is named **StreakFlows** (set when the
app was created; change it in App Information if wanted). The listing
language is **English (U.K.)**.

## Subtitle (max 30)

The name has no "habit" or "tracker", so the subtitle carries them:

```text
Habit Tracker & Streaks
```

## Promotional Text (max 170)

Can be changed anytime without a new review.

```text
Build better habits one day at a time. Smart streaks that respect your schedule, reminders, calendar and stats. Private, offline, no account needed.
```

## Keywords (max 100)

Commas, no spaces after them. "habit" and "tracker" are included because the
name ("StreakFlows") doesn't contain them.

```text
habit,tracker,streak,routine,goals,daily,reminder,productivity,planner,motivation,focus,fitness
```

## URLs and copyright

| Field | Value |
|---|---|
| Support URL | `https://streakflow.codesapience.com/#billing` |
| Marketing URL (optional) | `https://streakflow.codesapience.com` |
| Privacy Policy URL (App Privacy page) | `https://streakflow.codesapience.com/privacy-policy.html` |
| Terms of Use (EULA) | `https://streakflow.codesapience.com/terms.html` |
| Copyright | `2026 CodeSapience` |

- Copyright: year and owner only; App Store Connect adds the ©, so typing it
  shows it twice. The owner should match the seller name on the Apple
  Developer account (or use the legal name, e.g. `2026 Ashish Yadav`).
- The site is the `gh-pages` branch of `ashishsonu2000/streakflow` on GitHub
  Pages with the custom domain `streakflow.codesapience.com` (`CNAME`). The
  github.io address
  `https://ashishsonu2000.github.io/streakflow/privacy-policy.html` 301-redirects
  to the custom domain, so always enter the custom-domain URLs.

## Description (max 4,000)

```text
StreakFlow helps you build better habits, one day at a time.

Track daily or weekly habits with streaks that follow each habit's real schedule. A Mon/Wed/Fri workout is never "broken" on a Tuesday, so your streak shows your true consistency.

WHY STREAKFLOW
• Smart streaks: daily habits or chosen weekdays, and days off never count as missed
• Reminders: a gentle nudge at the time you choose
• Calendar history: see every completed day at a glance
• Statistics: completion rates, current and best streaks, progress over time
• Achievements, XP and levels to keep you motivated
• Quick start: pick your goals (health, fitness, productivity, learning, finance, mindfulness) and get starter habits in seconds
• Archive habits you've paused without losing their history
• Backup and restore your data to a file

PRIVATE BY DESIGN
• No account, no sign-up
• Your habits stay on your device
• Works fully offline

FREE
Everything above, with up to 20 active habits.

STREAKFLOW PREMIUM (optional)
• Unlimited habits
• Productivity score: one weekly score from your completion, consistency and streaks
• Advanced insights: best days, strongest and weakest habits, week-over-week trends
• Weekly and monthly reports you can share
• Premium color themes for light and dark mode
• Advanced achievements for long-term milestones
• CSV export for spreadsheets
• Up to 5 reminder times per habit

SUBSCRIPTION DETAILS
StreakFlow Premium is available as a monthly or yearly auto-renewable subscription. Payment is charged to your Apple Account at confirmation of purchase. The subscription renews automatically unless it is cancelled at least 24 hours before the end of the current period, and your account is charged for renewal within 24 hours before the end of the current period. You can manage or cancel your subscription anytime in Settings → your name → Subscriptions.

Privacy policy: https://streakflow.codesapience.com/privacy-policy.html
Terms of Use: https://streakflow.codesapience.com/terms.html

Small steps. Big change. Start your streak today.
```

## App Review Notes (max 4,000)

App Store Connect → version → **App Review Information** → **Notes**.

Before submitting, check:

- **Menu paths**: Settings → Premium and "Restore purchases" are confirmed in
  the code; developer tools (Ads Test, "Simulate premium") are hidden in
  release builds. Check the **+** button and "Back up or restore" wording
  against the build being submitted.
- **Paywall**: Apple requires price, billing period, auto-renewal terms and
  links to the Terms of Use and Privacy Policy (guideline 3.1.2). Confirm on
  the Premium screen in TestFlight that both links are there.
- **"Does not collect personal data"**: true only while ads are off. The App
  Privacy answers ([APP_PRIVACY.md](APP_PRIVACY.md)) already declare AdMob
  data; to match them exactly, use instead: *"The Google Mobile Ads SDK is
  included but ads are disabled in this version; the App Privacy labels
  already declare its data for a future version with ads."* Once ads are on,
  rewrite the ADS and PRIVACY parts.
- **Subscriptions**: attach both products to the version under **In-App
  Purchases and Subscriptions**; the first subscriptions must be submitted
  together with an app version.

```text
StreakFlow is a habit tracker that works fully offline. No account, sign-in or demo login is needed; all features are available right after the short onboarding (enter an optional name, pick goals, choose starter habits). All habit data is stored only on the device.

HOW TO REVIEW THE MAIN FEATURES
- Habits tab: tap + to create a habit (daily or chosen weekdays, optional daily target such as 8 glasses), then tap a habit to mark it done. Streaks follow each habit's schedule.
- Calendar and statistics: open a habit to see its history, completion rate and current/best streak.
- Reminders: set a reminder time on a habit. Reminders are local notifications scheduled on the device; no push server is used.
- Backup: Settings → Back up or restore exports a backup file through the share sheet and imports one with the Files picker.

IN-APP PURCHASES (StreakFlow Premium)
Premium is an optional auto-renewable subscription in one subscription group with two products:
- streakflow_premium_monthly (1 month)
- streakflow_premium_yearly (1 year)
To test: Settings → Premium → choose Monthly or Yearly → Subscribe, using a Sandbox account. Premium unlocks unlimited habits (free plan: 20 active habits), up to 5 reminder times per habit, advanced insights, weekly/monthly reports, premium themes, advanced achievements and CSV export. "Restore purchases" is on the same Premium screen. The paywall shows the price, billing period, auto-renewal terms and links to the Terms of Use and Privacy Policy.

ADS
This version does not show ads.

PRIVACY
The app does not collect personal data. It does not request App Tracking Transparency because it does not track users.

Privacy Policy: https://streakflow.codesapience.com/privacy-policy.html
Terms of Use: https://streakflow.codesapience.com/terms.html
Contact: contact@codesapience.com
```
