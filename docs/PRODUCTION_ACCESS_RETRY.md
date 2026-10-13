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

## 5. Tester follow-up message (WhatsApp / text)

> Hi! Thank you for testing StreakFlow 🙏 Quick update: Google reviewed the
> test and wants to see testers actually using the app before it can go
> live, so I need 14 more days of your help. It takes about a minute a day:
>
> 1. Open StreakFlow once a day. If it's not installed, open
>    https://play.google.com/apps/testing/com.codesapience.streakflow on
>    your phone and install it from Google Play.
> 2. Add 2–3 real habits (water, walking, reading, anything) and tick them
>    off when you do them.
> 3. Look around once: Calendar, Stats, Achievements, and set a reminder.
> 4. Tell me one thing to improve. Either:
>    - In the Play Store, open StreakFlow, scroll down to the private
>      feedback box for testers and write a line or two, or
>    - In the app, open Settings and tap "Send feedback" in the About section.
>
> Anything counts: something confusing, a bug, a feature you'd want, or
> something you liked. I'll release updates based on what you say. Please
> also update the app when the Play Store offers a new version. Thank you!

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
       signed with the same upload key as build 13).
3. [ ] Upload build 14 to **both** Closed testing - Alpha and Internal
       testing. Example release notes: "New: Send feedback in Settings
       and a quick feedback card on the dashboard, so testers can tell us
       what to improve."
4. [ ] Once it's live, send the follow-up message (§5) to all testers and
       recruit 3–5 more.
5. [ ] Log feedback in §8 as it arrives.
6. [ ] Build 15 (around 17–19 Oct) and build 16 (around 22–24 Oct) with
       fixes from the feedback; release notes name the feedback. Next
       version code: 15.
7. [ ] Fill in the checklist answers with real facts from §8.
8. [ ] Re-apply for production on or after **26 Oct 2026**.
9. [ ] After production launch: submit the BillDesk KYC form (it waits
       for the launch).

## 8. Feedback log

| Date | Tester | Channel (Play / email / chat) | Feedback | Action | Build |
|---|---|---|---|---|---|
| | | | | | |
