# Production access: rejection and retry plan

Written 12 Oct 2026. The checklist is in
[PLAY_CONSOLE_CHECKLIST.md](PLAY_CONSOLE_CHECKLIST.md) §10, and the tester
messages are in [TESTER_INVITATION.md](../TESTER_INVITATION.md).

## 1. What Google said (12 Oct 2026)

> **More testing required to access Google Play production.**
> We reviewed your application, and determined that your app requires more
> testing before you can access production.
>
> Possible reasons:
> - Testers were not engaged with your app during your closed test
> - You didn't follow testing best practices, which may include gathering
>   and acting on user feedback through updates to your app
>
> Before applying again, test your app using closed testing for an
> additional 14 days with real testers.

**Earliest re-application: 26 Oct 2026** (14 days after the rejection).
Check the Play Console dashboard before applying.

## 2. Likely causes

1. **The tester invite told people not to use the app.** The old message
   said: "No need to actually use it every day — just having it installed
   helps." Google measures real use, so 12 opted-in but inactive testers
   count as "not engaged".
2. **The app had no feedback option.** `feedback_page.dart` was empty and
   `FeedbackEmailService` was never called, yet the draft application answer
   mentioned an in-app "Send feedback" email. Google can compare answers
   with what the app and the testing data show.
3. **Placeholders in the draft answers.** The draft in the checklist still
   had **[fill in]** spots for tester engagement and feedback. If the form
   went out vague or with placeholders, that alone can cause a rejection.

## 3. Plan for the 14 days (12 Oct to 26 Oct 2026)

### Testers use the app (most important)
- Send the follow-up message (§5) to all 12 testers today.
- Ask them to install from the Play testing link, not a sideloaded APK,
  and open the app on most days: add 2–3 habits, tick them off, and look
  at Calendar, Stats and Achievements once.
- Recruit 3–5 more testers as a buffer, using the short or email version
  in TESTER_INVITATION.md.
- Stay on the same track (Closed testing - Alpha). Don't create a new
  track: the opted-in count must not drop below 12.

### Collect feedback Google can see
- Testers write in the **private feedback box for testers on the
  StreakFlow Play Store page**. Google sees this. It doesn't see WhatsApp.
- In-app: Settings → About → **Send feedback**, plus the dashboard
  feedback card (added in build 14, see §4).
- Keep a log of every piece of feedback in §8: the date, the tester
  (initials), what they said, and the build that addressed it.

### Ship updates that respond to feedback
- Upload at least 2 builds during the 14 days (build 14 now, then 15 and
  16). The release notes must name the feedback they fix, e.g. "Changed X
  after testers reported Y."
- Smoke test the release APK on the emulator before every upload.
- Upload every build to **both** Closed testing - Alpha and Internal
  testing.

### Before re-applying
- [ ] At least 12 testers still opted in, and the dashboard shows the
      14 days met
- [ ] Testers opened the app on most days (check Play Console statistics)
- [ ] Real private feedback received through Play
- [ ] At least 2 updates whose release notes respond to feedback
- [ ] Every **[fill in]** in the checklist answers replaced with real
      facts: active tester count, 2–3 real quotes, and the build that fixed
      each one
- [ ] No crashes on the latest build in Android vitals

## 4. Build 14 changes (1.0.0+14)

| Change | File |
|---|---|
| Feedback email now has a body template ("What I like" / "What I would change or fix") and the app version + build; returns `false` when no email app opens | `lib/features/settings/domain/services/feedback_service.dart` |
| Show/hide logic for the feedback card: hidden for the first 2 days of use, then shown; closing it or sending feedback hides it for 7 days. Stored in SharedPreferences (`feedback_prompt_first_seen_v1`, `feedback_prompt_last_action_v1`) | `lib/features/settings/presentation/providers/feedback_prompt_provider.dart` |
| Dashboard card "How is Streak Flow working for you? Tell me one thing you would change or fix." with a Send feedback button and an X ("Not now"); `sendFeedback()` helper shows "No email app found. Write to contact@codesapience.com" when there's no email app | `lib/features/settings/presentation/widgets/feedback_prompt_card.dart` |
| Card added at the top of the dashboard | `lib/features/dashboard/widgets/dashboard_body.dart` |
| "Send feedback" tile in Settings → About (between Version and About) | `lib/features/settings/presentation/pages/settings_page.dart` |
| Manifest query for `SENDTO mailto` so the email app opens on Android 11+ | `android/app/src/main/AndroidManifest.xml` |
| Tests for the card timing (days 0–1 hidden, day 2 shown, comes back 7 days after closing, hidden without prefs) | `test/features/settings/feedback_prompt_test.dart` |
| Version 1.0.0+13 → **1.0.0+14** | `pubspec.yaml` |
| Tester messages rewritten: testers must use the app and send feedback | `TESTER_INVITATION.md` |
| Feedback answer corrected to say the in-app feedback arrived in build 14 | `docs/PLAY_CONSOLE_CHECKLIST.md` |

`flutter analyze`: no issues. `flutter test`: all 585 tests pass.

### Builds 15, 16 and 17 (1.0.0+15 to 1.0.0+17, 16–17 Oct 2026)

Builds 14–16 were never uploaded, so build 17 is the next upload and
carries 14–17. These fixes came from our own testing (the user-guide
recording), **not** from tester feedback: §8 is still empty, so the
release notes don't say "testers reported".

| Change | Build |
|---|---|
| Daily target above 1 counts each step (+1 · 3/8); the day completes, with streak and XP, only at the target; Undo steps back one | 15 |
| Status bar icons readable on light screens | 15 |
| Habits tab header scrolls away with the list | 15 |
| Create Habit: closing the icon, colour or time picker no longer reopens the keyboard; onboarding closes the keyboard after the name step | 15 |
| Gradient Create First Habit / Add Habit buttons; the form's save button is a floating "Add Habit" | 15 |
| Floating Add Habit button slides away while scrolling down | 16 |
| Calendar completion % counts only days up to today (was 82 / 168 = 49% mid-month instead of 82 / 92 = 89%) | 17 |

`flutter test`: all 589 tests pass. Release APK smoke-tested on the
emulator (launch, onboarding, +1 steps, complete, undo, daily reset).
Bundle: `StreakCalculator/releases/streakflow-1.0.0+17.aab`, ads off.

Release notes for build 17 (459 of 500 characters; same text in
[marketing/SOCIAL_MEDIA_KIT.md](../marketing/SOCIAL_MEDIA_KIT.md)):

```
<en-US>
What's new:
• Daily targets count every step: tap +1 for each glass of water until 8/8. Undo steps back one at a time
• Add Habit has a new look and moves out of the way while you scroll
• The habit list header scrolls away, so more habits fit on screen
• The calendar's completion % now counts only the days so far
• Readable status bar, and no more surprise keyboard pop-ups
• Send feedback from Settings or the new dashboard card. Tell us what to fix next!
</en-US>
```

## 5. Tester follow-up message (WhatsApp / text)

For build 17. Send once it's live (§7 step 4); same text as TESTER_INVITATION.md.

> Hi! Thank you for testing StreakFlow 🙏 Quick update: Google reviewed the
> test and wants to see testers actually using the app before it can go live,
> so I need your help until 26 October. It takes about a minute a day.
>
> A new version (build 17) is out. Please update StreakFlow in the Play Store
> first. It adds:
> • Daily targets: for a habit like "8 glasses of water", tap +1 each time
> • A "Send feedback" option in Settings, so telling me what to fix takes a
>   few seconds
> • A smoother habit list and several small fixes
>
> Then:
> 1. Open StreakFlow once a day. If it's not installed, open
>    https://play.google.com/apps/testing/com.codesapience.streakflow on your
>    phone and install it from Google Play.
> 2. Add 2–3 real habits (water, walking, reading, anything) and tick them
>    off when you do them. Try one with a daily target, like water 8 times a
>    day.
> 3. Look around once: Calendar, Stats, Achievements, and set a reminder.
> 4. Tell me one thing to improve. Either:
>    - In the Play Store, open StreakFlow, scroll down to the private
>      feedback box for testers and write a line or two, or
>    - In the app, open Settings and tap "Send feedback" in the About section.
>
> Anything counts: something confusing, a bug, a feature you'd want, or
> something you liked. The next updates will be based on what you tell me.
> Thank you!

The versions for new testers (short and email) are in TESTER_INVITATION.md.
Never tell testers that installing alone is enough.

## 6. Release smoke test of build 14 (12 Oct 2026)

Built with `flutter build apk --release` (76.5 MB,
`build/app/outputs/flutter-apk/app-release.apk`), installed on the
Pixel_API_35 emulator. The debug build was uninstalled first because the
signatures differ, which wiped the emulator's debug test data.

| Check | Result |
|---|---|
| Launch (the old R8 crash risk) | ✅ Opens normally |
| Notification permission prompt | ✅ Allowed |
| Onboarding, all 6 steps | ✅ Name, Health goal, starter habit, reminders, finish |
| Dashboard | ✅ Feedback card correctly hidden on day 1 |
| Settings → About → Send feedback | ✅ Tile shows; tapping it opens Gmail's compose screen with the address, subject and body attached |
| Complete a habit | ✅ Morning Walk: 1 day streak, 100% done today |
| Crashes | ✅ No `FATAL EXCEPTION` in logcat for the whole session |

Re-tested on 13 Oct 2026 with the same release APK, after merging into
`feature/premium` (`1ebc136`). Gmail on the emulator was signed in this
time:

| Check | Result |
|---|---|
| Launch, onboarding, dashboard | ✅ Same as 12 Oct; feedback card hidden on day 1 |
| Send feedback: email draft | ✅ To `contact@codesapience.com`, subject "Streak Flow Feedback" (spaces shown correctly, not `+`), body with "What I like:" and "What I would change or fix:", then "App version: 1.0.0 (14)" |
| Crashes | ✅ Nothing in the crash buffer |

The draft was discarded, not sent.

Not checked:
- **Send feedback on a real phone:** the draft is now confirmed on the
  emulator, but not yet on a physical device or with an email app other
  than Gmail.
- **The dashboard card on screen:** it first appears after 2 days of use.
  Covered by the unit tests. To see it, set the device date forward
  2 days.

## 7. Next steps

1. [ ] Check Send feedback on a real phone: the draft should have the
       subject, the body template and the version.
2. [x] `flutter build appbundle` → copied to
       `StreakCalculator/releases/streakflow-1.0.0+14.aab` (12 Oct 2026,
       signed with the same upload key as build 13). Superseded by
       build 17 (`streakflow-1.0.0+17.aab`, 17 Oct 2026, same key).
3. [ ] Upload **build 17** (not 14 or 16) to **both** Closed testing -
       Alpha and Internal testing, with the build 17 release notes in §4.
4. [ ] Once it's live, send the follow-up message (§5) to all testers and
       recruit 3–5 more.
5. [ ] Log feedback in §8 as it arrives.
6. [ ] Builds 15–17 were used for our own fixes (§4), so the
       feedback-driven updates are now build 18 (around 20–22 Oct) and
       build 19 (around 23–25 Oct); their release notes name the
       feedback from §8. Next version code: 18.
7. [ ] Fill in the checklist answers with real facts from §8.
8. [ ] Re-apply for production on or after **26 Oct 2026**.
9. [ ] After production launch: submit the BillDesk KYC form (it waits
       for the launch).

## 8. Feedback log

Build 15 is the build live on Closed testing (confirmed 3 Nov 2026).

| Date | Tester | Channel (Play / email / chat) | Feedback | Action | Build |
|---|---|---|---|---|---|
| 3 Nov 2026 | Testers Community (paid testing service) | PDF report | No way to rate the app | "Rate StreakFlow" in Settings → About (opens the Play listing); one-time in-app review prompt after a 7-day streak | 25 |
| 3 Nov 2026 | Testers Community | PDF report | No walkthrough for new users | The 6-step onboarding already existed; added 5 first-use tips on the dashboard (Next tip / Got it / close) | 25 |
| 3 Nov 2026 | Testers Community | PDF report | Store description too short, few keywords | Rewrite the Play description with keywords and bullet points | listing |
| 3 Nov 2026 | Testers Community | PDF report | Screenshots don't show features | New captioned screenshots: daily targets, calendar, stats, achievements, reminders | listing |
| 3 Nov 2026 | Testers Community | PDF report | No crashes or bugs found on their devices | — | 15 |

## 9. Build 25 (1.0.0+25, 3 Nov 2026)

Responds to the Testers Community report (§8). Built from `feature/premium`
(= `main` 75a3782 + these changes), ads off. Builds 22–24 belong to
`feature/digital-detox` (iOS only).

| Change | File |
|---|---|
| `RateAppService`: `openStoreListing()` for the Settings button (iOS falls back to the review sheet, no App Store ID yet); `shouldPromptForMilestone` / `promptForMilestone` ask once per install when the streak first goes up to 7+ days (`rate_prompt_milestone_v1`) | `lib/features/settings/domain/services/rate_app_service.dart` |
| "Rate StreakFlow" tile in Settings → About | `lib/features/settings/presentation/pages/settings_page.dart` |
| Review prompt 1.5 s after the streak reaches 7, skipped if a level-up celebration shows at the same moment (then asked on the next streak increase) | `lib/features/dashboard/widgets/dashboard_body.dart` |
| First-use tips (5), progress in `dashboard_tips_index_v1` / `dashboard_tips_done_v1`; the feedback card waits until the tips are done or closed | `lib/features/dashboard/presentation/providers/dashboard_tips_provider.dart`, `.../widgets/tips/dashboard_tips_card.dart` |
| Tests | `test/features/dashboard/dashboard_tips_test.dart` |

`flutter analyze`: no issues. `flutter test`: all 609 pass.
Bundle: `StreakCalculator/releases/streakflow-1.0.0+25.aab`.

Release smoke test (4 Nov 2026, Pixel_API_35, release APK over existing data): launch OK; tips 1–5, "Got it" hides them and they stay hidden after restart, feedback card then shows; Settings → Rate StreakFlow opens the Play Store; complete + undo a habit OK; no FATAL EXCEPTION or ANR. Note: on the dashboard, a habit with a daily target counts one step per tap but the box shows no progress (pre-existing); tip 1/3 text adjusted to match.

Release notes (Play, under 500 characters):

```
<en-US>
What's new, based on tester feedback:
• Rate StreakFlow from Settings. Testers asked for an easy way to leave a rating
• New first-use tips on the home screen show how to tick off habits, use daily targets and find the calendar
• Calendar completion % now counts only the days so far
• Add Habit button moves out of the way while you scroll
Keep the feedback coming: Settings → Send feedback
</en-US>
```

## 10. Re-application answers (draft, 3 Nov 2026)

Written from §8, §9 and the build history, not from the Testers Community
template (that template claims a new walkthrough and other changes we
didn't make in that form). **[check]** = confirm in Play Console or fill in
before sending. Send only after build 25 is live and testers have used it
for a few days.

**1. How did you recruit users for your closed test?**
I started with friends, family and colleagues, invited by WhatsApp and
email with the opt-in link to the Closed testing - Alpha track. After the
first application was rejected for low engagement, I rewrote the
invitation to ask testers to use the app daily and send feedback, and
added testers from Testers Community, a paid testing service, so that
testers on different devices would use the app and report problems.
**[check]** testers are opted in today.

**2. How easy was it to recruit testers?**
Neither easy nor difficult. Getting people to opt in was easy; getting
them to open the app regularly took reminders, which is why I added a
paid testing service the second time.

**3. Describe the engagement you received from testers.**
Testers created habits, ticked them off, and used the calendar,
statistics, reminders and achievements. Build 15 added an in-app feedback
card and a Send feedback option, and Testers Community tested the app on
several devices and Android versions and sent a written report.
**[check: active users / sessions from Play Console statistics, and
anything testers said through Play private feedback or the app]**

**4. Provide a summary of the feedback you received and how you collected it.**
Feedback came from the Testers Community report, Google Play private
feedback, the in-app Send feedback email, messages from testers I know,
and my own daily use of the release build. The report found no crashes or
bugs on their devices, and asked for: an easy way to rate the app, more
guidance for new users, a longer store description with clearer feature
lists, and screenshots that show the features. My own testing found that
daily targets (like 8 glasses of water) couldn't be counted step by step,
the calendar's completion rate counted future days, the keyboard reopened
unexpectedly in the habit form, and the status bar was hard to read on
light screens. **[add 1–2 real tester comments if any arrive]**

**5. Who is the intended audience for your app?**
Adults and teenagers (13+) who want to build daily or weekly habits, such
as drinking water, exercise, study, reading, saving or meditation, and
track their progress without creating an account.

**6. Describe how your app provides value to users.**
StreakFlow tracks habits with streaks that follow each habit's real
schedule, so a Mon/Wed/Fri habit is never "broken" on its off days. Daily
targets count each step, reminders arrive at the time the user picks, and
the calendar, statistics and achievements show progress. It works fully
offline, with data stored on the device. The free version supports up to
20 habits; an optional Premium subscription adds unlimited habits,
insights, reports, themes and more reminders per habit.

**7. How many installs do you expect in your first year?**
0–10,000 (same as the first application).

**8. What changes did you make based on what you learned during the closed test?**
- Build 15: daily targets count each step (+1 · 3/8) and the day only
  completes at the target; in-app feedback card and Settings → Send
  feedback; readable status bar; no more keyboard pop-ups in the habit
  form; the habit list header scrolls away.
- Build 25: "Rate StreakFlow" in Settings, plus a one-time Google Play
  review prompt after a 7-day streak (asked for in the tester report);
  first-use tips on the home screen that show how to tick off habits, use
  daily targets and open the calendar, added on top of the existing
  6-step setup after testers asked for more guidance; the calendar's
  completion rate counts only days so far; the Add Habit button moves
  aside while scrolling.
- Store listing: a longer description with feature lists and the words
  people search for (habit tracker, daily routine, water, exercise,
  reminders), and new screenshots with captions for each main feature.

**9. How did you decide that your app is ready for production?**
Testers and the Testers Community report found no crashes, and Android
vitals show no crashes or ANRs on the latest build **[check]**. Every
release passes 609 automated tests and a manual launch test of the
release build on an emulator before upload. Premium purchase, restore and
cancel were tested end to end with Google Play license testing. The
changes testers asked for are in build 25, which testers used for
**[n]** days before this application.

**10. What did you do differently this time?**
The first time, my invitation told testers that installing was enough, so
they didn't use the app, and there was no way to send feedback from the
app. This time I asked testers to use the app every day, added in-app
feedback, brought in a paid testing service for broader device coverage,
logged every piece of feedback, and shipped two updates (builds 15 and 25)
whose release notes name the changes testers asked for.

### Screenshot captions (for the new Play screenshots)

1. Build habits that stick: smart streaks that follow your schedule
2. Daily targets: tap +1 for every glass of water
3. See every day at a glance: calendar with completion rate
4. Track your progress: streaks, stats and weekly trends
5. Earn achievements, XP and levels
6. Never forget: reminders at the time you choose
