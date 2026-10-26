# StreakFlow: Social Media Kit

All launch copy in one place. Keep this file updated when copy, features or links change.

- **Play link:** https://play.google.com/store/apps/details?id=com.codesapience.streakflow
- **Website:** https://streakflow.codesapience.com
- **Creatives:** [meta-ads/](meta-ads/) (images, videos, generator script). Paid-ad copy: [meta-ads/AD_COPY.md](meta-ads/AD_COPY.md)

Last updated: 17 Oct 2026 (build 17)

---

## Before you post: launch-state rule

Until Google approves production, the Play link shows "not found" to the public. Until then:

- Replace "is live" / "Free on Google Play" with **"Launching soon on Google Play 🚀"**
- Use the **website** link instead of the Play link
- Don't run app-install ads

**Status (13 Oct 2026):** Google refused production access on 12 Oct ("more testing required"). Build 13 is live in closed testing; build 17 (which includes 14–16) is the next upload. Re-application on or after 26 Oct. Until approval, use the launch-state wording above and the build 14 and build 17 posts below. Plan: [docs/PRODUCTION_ACCESS_RETRY.md](../docs/PRODUCTION_ACCESS_RETRY.md).

## Claims to keep accurate

- **"Off days don't break your streak"** = days a habit isn't scheduled. A missed *scheduled* day still resets it. Never say "never lose your streak."
- **Free plan = 20 habits.** Update every post and creative if this changes.
- **Public numbers** (from the project docs): 12 closed testers, 12 updates during testing, 589 automated tests. Update or remove if they change.
- Don't use the official Google Play badge unless you follow Google's badge guidelines.
- Ask for **honest** reviews only. Never ask for 5 stars or offer anything in return (Play policy).
- **Feedback in the app:** Settings → **Send feedback** opens an email with a short template. A dashboard card also asks for feedback after 2 days of use. Don't promise a reply time.

---

## Build 14: closed testing, round 2 (until production approval)

Goal: get testers to **use** the app daily and send feedback, then build in public about it. Direct messages to testers (WhatsApp, email) are in [TESTER_INVITATION.md](../TESTER_INVITATION.md); don't duplicate them here.

What's new in build 14 (1.0.0+14), for captions:
- **Send feedback** in Settings: opens your email app with a short template and the app version filled in
- A dashboard card asking "How is Streak Flow working for you?", shown after 2 days of use and again a week after it's closed
- Shows the contact address when no email app is installed

### X / Twitter: build-in-public update
```
Google just said no to my app going live 😅

"More testing required." My testers installed StreakFlow, but most didn't really use it.

So build 14 asks for feedback inside the app: one tap in Settings opens an email with the app version already filled in.

Round 2 of testing starts now. #buildinpublic #indiedev
```
Follow-up reply (same thread):
```
Lesson: "12 testers for 14 days" means 12 people using the app, not 12 installs.

If you're on Android and want to help test a habit tracker for 2 weeks, reply and I'll send the link 🙏
```

### LinkedIn: personal update
```
My first Play Store application was turned down this week, and I think Google was right.

Google requires new developers to run a closed test with at least 12 testers for 14 days. I had the testers. What I didn't have was engagement: most people installed StreakFlow, opened it once, and moved on.

So for the next 14 days I'm changing how I run the test:
• Build 14 adds a "Send feedback" option, so telling me what's wrong takes one tap
• A small card on the dashboard asks testers what to improve after a couple of days of use
• I'm asking testers to use the app for a minute a day and tell me one thing to change, and I'll ship updates based on what they say

If you use Android and would like to help test a simple, private habit tracker for two weeks, comment or message me and I'll send you the link.

#indiedev #android #buildinpublic
```

### WhatsApp Status (with `post-3-progress-1080x1350.png`)
```
Testing my habit app StreakFlow for 2 more weeks 🙏 Android users: reply if you'd like the tester link. One minute a day, and tell me one thing to improve!
```

### Instagram / Facebook Story (with `story-flyer-1080x1920.png`)
Text overlay: `Help test StreakFlow 🙏` · Sticker: question box, "What should a habit app do better?" · Don't add a Play link sticker until production is approved; ask people to DM for the tester link instead.

### Feedback nudge for testers short on time
The full fill-in-the-blank list is in [TESTER_INVITATION.md](../TESTER_INVITATION.md) ("Ready-made feedback lines"); send that list in direct messages. For posts and Status, use the one-line version below. Always keep the blanks: never post finished feedback for testers to copy.

WhatsApp Status (text status, no image):
```
StreakFlow testers 🙏 No time to write feedback? Just fill this in and send it from the app (Settings → Send feedback):

Used it for ___ days. Good: ___. Change: ___.
```
Instagram / Facebook Story: text overlay `Testers: 10-second feedback 👇` and a question box sticker with the prompt `Used it for ___ days. Good: ___. Change: ___.` Copy useful answers into the feedback log in [docs/PRODUCTION_ACCESS_RETRY.md](../docs/PRODUCTION_ACCESS_RETRY.md) §8.

X / LinkedIn reply under the build-in-public update:
```
Testers: if writing feedback feels like homework, this is enough 🙂

Used it for ___ days. Good: ___. Change: ___.
```

---

## Build 17: closed testing update (17 Oct 2026)

Build 17 (1.0.0+17) is the first upload since build 13, so it also carries everything from builds 14–16 (none of them were uploaded). These fixes came from our own testing, not from tester reports (the feedback log is still empty), so don't write "you asked for" or "testers reported" until real feedback is logged in [docs/PRODUCTION_ACCESS_RETRY.md](../docs/PRODUCTION_ACCESS_RETRY.md) §8.

What's new in build 17, for captions:
- Habits with a daily target count each step: tap **+1** per glass of water until 8/8; Undo steps back one at a time
- New gradient **Add Habit** button that slides out of the way while you scroll the form
- The Habits list header scrolls away, so more habits fit on screen
- Readable status bar on light screens; the keyboard no longer pops up after picking an icon, colour or time
- The calendar's completion % counts only the days so far (it used to include the rest of the month, e.g. 49% instead of 89%)
- **Send feedback** in Settings and a feedback card on the dashboard (from build 14)

### Play Console release notes (459 of 500 characters)
Paste into both Closed testing - Alpha and Internal testing.
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

Message for existing testers: use the build 17 follow-up in [TESTER_INVITATION.md](../TESTER_INVITATION.md). Post the captions below only after build 17 is live in Closed testing.

### X / Twitter: build-in-public update (with a screen recording of +1 taps, or `post-3-progress-1080x1350.png`)
```
Recording a user guide for my habit app, I found a bug in my own app 😅

"Drink 8 glasses of water" was marked done after ONE tap.

Build 17 fixes it: tap +1 per glass, and the streak only counts at 8/8.

Your own app's tutorial is the best bug report. #buildinpublic #indiedev
```
Follow-up reply (same thread):
```
Also in build 17: a gradient Add Habit button that gets out of the way while you scroll, and a habit list that finally fits more than one habit on screen.

Android users: reply if you'd like to help test before launch 🙏
```

### LinkedIn: personal update
```
A small lesson from this week: record a tutorial of your own product.

I made a 5-minute user guide video for StreakFlow, my habit tracker, and spotted four problems along the way:
• A habit with a target of 8 a day counted as done after one tap
• The status bar was unreadable on light screens
• The habit list header took half the screen
• The keyboard kept popping back up after choosing an icon

All four are fixed in build 17, which is now with my closed testers.

If you use Android and want to help test a simple, private habit tracker before launch, comment or message me.

#indiedev #android #buildinpublic
```

### WhatsApp Status (text, or with a screenshot of the +1 · 3/8 card)
```
StreakFlow update is out 💧 Habits like "8 glasses of water" now count every glass: tap +1 each time. Testers: please update from the Play Store and tell me what to fix next (Settings → Send feedback) 🙏
```

### Instagram / Facebook Story (screenshot of the +1 · 3/8 card)
Text overlay: `Now counting every glass 💧 3/8` · Sticker: poll, "How many glasses of water do you drink a day? 4 or less / 5–8 / 8+" · Ask testers to update; no Play link sticker until production is approved.

### User guide video (YouTube, long-form)
**File:** [user-guide-video/StreakFlow_User_Guide.mp4](user-guide-video/StreakFlow_User_Guide.mp4) (5:33, 1080p, recorded on build 15; build 17 adds the Add Habit button hiding while you scroll and the calendar fix, so the video's calendar still shows the old 5% figure) with subtitles [StreakFlow_User_Guide.srt](user-guide-video/StreakFlow_User_Guide.srt). Upload as a normal (not Short) video and add the .srt as English subtitles.

Title:
```
How to use StreakFlow: habit tracker guide (5 min)
```
Description:
```
A quick tour of StreakFlow, the simple habit tracker that works offline with no account.

0:00 Welcome
0:18 Setup (6 steps)
1:12 Add a habit
2:21 Daily targets (+1 per step)
2:46 Complete and manage habits
3:29 Home dashboard
4:00 Calendar, stats and achievements
4:31 Settings, dark mode and backup
4:56 Premium and Send feedback

StreakFlow is in closed testing on Google Play. Website: https://streakflow.codesapience.com
```
Chapter times are taken from the subtitle file. After launch, swap the closed-testing line for the Play link. Use this video as the "Related video" on the Shorts so viewers have a clickable path to a longer guide. The Premium scene shows Indian prices (₹100/month, ₹600/year); trim it if posting for other countries.

---

## Account setup

- **Meta Business portfolio:** named **Codesapience** (owns the ad account, billing and assets).
- **Facebook Page + Instagram account:** named **StreakFlow**. Profile picture = StreakFlow icon. Category: App Page.
- **Meta Events Manager:** add the app before running install ads.
- **Facebook Page button:** "Download app" / "Use app" → Play link (once live).

### Instagram bio (150-character limit)

**Recommended:**
```
Build habits that stick 🔥
Streaks that follow your real schedule
Free · No account · Works offline
by @codesapience 👇
```
(Use "by Codesapience" if there's no @codesapience Instagram account.)

**Alternative, short:**
```
Off days don't break your streak ✅
Simple, private habit tracker
Free on Google Play 👇
```

**Alternative, benefit-led:**
```
Track habits, build streaks, see your progress 📈
Reminders · Calendar · Stats
Free, no sign-up needed 👇
```

- **Name field:** `StreakFlow | Habit Tracker`
- **Username:** `@streakflow`, or `@streakflow.app` / `@streakflowapp`
- **Link:** Play link once live, website until then

---

## Instagram

Captions can't contain clickable links, so point to "link in bio". Post a day or two apart, in this order.

### Post 1: `post-1-offdays-1080x1080.png`
```
Rest days are part of the plan, not a failure. 🙌

Most habit trackers reset your streak the moment you skip a day, even when that day was never meant to be a workout day.

StreakFlow follows your real schedule. Set a habit for Mon, Wed and Fri, and your streak only counts those days. Off days never count against you.

Build the routine that fits your week. 🔥

📲 Free on Google Play: link in bio

#habittracker #habits #streak #productivity #selfimprovement #consistency #dailyhabits #androidapp
```

### Post 2: `post-2-free-1080x1080.png`
```
Your habits, your phone, your data. 🔒

✅ Free for up to 20 habits
✅ No account or sign-up needed
✅ Works fully offline
✅ Reminders, calendar and stats built in

Open the app and start your first streak in under a minute.

What's the first habit you'd track? Tell us below 👇

📲 Link in bio

#habittracker #productivityapp #freeapp #privacy #goals #routine #healthyhabits #androidapp
```

### Post 3: `post-3-progress-1080x1350.png`
```
Small wins, every day. 📈

💧 Drink water
📖 Read 20 pages
🏃 Move your body

StreakFlow shows how each habit is going: current streak, completion rate, calendar history and achievements you unlock along the way.

Watching the numbers grow is the best motivation to keep going. 🔥

📲 Get StreakFlow free on Google Play: link in bio

#habittracker #progress #motivation #selfgrowth #studyhabits #fitnessgoals #consistencyiskey #androidapp
```

### Reel: `reel-15s-1080x1920.mp4`
```
Took a rest day and your streak reset? 😩

StreakFlow follows your real schedule. Set a habit for the days you actually do it, and off days never break your streak. 🔥

✅ Free for up to 20 habits
✅ No account needed
✅ Works offline

📲 Free on Google Play: link in bio

#habittracker #habits #streak #productivity #selfimprovement #consistency #reels #androidapp
```
- The video is silent: add a trending sound at low volume.
- Cover: the "Not with StreakFlow." frame (~5 s), or upload `post-1-offdays-1080x1080.png` so the grid matches.
- Turn on "Also share to feed".

### Story: `story-flyer-1080x1920.png`
Stories use stickers, not captions.
1. **Link sticker** below the orange button (~75–80% down): text **"Get StreakFlow free"** → Play link (website before launch).
2. **Optional second frame:** plain brand-colour background, text **"What habit are you building right now?"** + Poll (💪 Fitness / 📚 Study) or Quiz (Fitness · Study · Health · Mindfulness).
3. Save both to a Highlight named **"Start here"**.

---

## Facebook Page

Links are clickable here. Use 2–3 hashtags at most, and delete the automatic link preview card so the image stays the main visual.

### Post 0: Page intro (pin it), `story-flyer-1080x1920.png` or `post-3-progress-1080x1350.png`
```
👋 Meet StreakFlow, a simple habit tracker built by Codesapience.

We built it because most habit apps punish you for rest days. StreakFlow's streaks follow your real schedule, so if you work out Mon, Wed and Fri, your streak only counts those days.

✅ Free for up to 20 habits
✅ No account or sign-up
✅ Works fully offline: your data stays on your phone
✅ Reminders, calendar history, stats and achievements

Follow this Page for tips on building habits that actually stick.

📲 Get it free on Google Play: https://play.google.com/store/apps/details?id=com.codesapience.streakflow
```

### Post 1: `post-1-offdays-1080x1080.png`
```
Rest days are part of the plan, not a failure. 🙌

Most habit trackers reset your streak the moment you skip a day, even if that day was never meant to be a workout day.

StreakFlow follows your real schedule. Set a habit for the days you actually plan to do it, and off days never count against you.

Try it free 👉 https://play.google.com/store/apps/details?id=com.codesapience.streakflow

#HabitTracker #Productivity
```

### Post 2: `post-2-free-1080x1080.png`
```
No sign-up. No internet needed. No cost. 🔒

StreakFlow is free for up to 20 habits and keeps everything on your phone. Open the app and start your first streak in under a minute.

💬 What's the first habit you'd track? Tell us in the comments.

📲 https://play.google.com/store/apps/details?id=com.codesapience.streakflow
```

### Post 3: `post-3-progress-1080x1350.png`
```
Small wins add up. 📈

💧 Drink water
📖 Read 20 pages
🏃 Move your body

StreakFlow shows how every habit is going: your streak, completion rate, a calendar of your history, and achievements you unlock along the way. Watching the numbers grow is the best reason to keep going.

Start today, free on Google Play 👉 https://play.google.com/store/apps/details?id=com.codesapience.streakflow
```

### Video: `feed-video-15s-1080x1080.mp4` (also share the Reel as a Facebook Reel with the Instagram caption)
```
Took a rest day and your streak reset? 😩 Not with StreakFlow.

Streaks that follow your real schedule, plus reminders, calendar and stats. Free, no account, works offline.

📲 https://play.google.com/store/apps/details?id=com.codesapience.streakflow
```

---

## LinkedIn

Post from your personal profile. Put the link in the **first comment** (LinkedIn shows posts with outside links to fewer people). Reply to every comment in the first hour.

### Post 1: Launch announcement (personal), `story-flyer-1080x1920.png` or `post-3-progress-1080x1350.png`
```
After months of building, StreakFlow is live on Google Play. 🚀

It's a habit tracker, and I know there are hundreds of those. I built it because of one small frustration: most of them break your streak on rest days.

If you train Mon, Wed and Fri, a missed Tuesday isn't a failure. It's the plan. So in StreakFlow, streaks follow each habit's real schedule.

A few other choices I made deliberately:
🔒 No account, and everything stays on your phone
📴 Works fully offline
🆓 Free for up to 20 habits, with an optional Premium plan

Before launch it went through a closed test with 12 testers and 12 updates based on what we learned. Every release now passes 585 automated tests plus a manual check on a real device.

Built under Codesapience, my independent app studio.

If you try it, I'd genuinely value your feedback, especially the critical kind. 🙏

🔗 Link in the first comment

#IndieDev #Flutter #AndroidDev #Productivity #BuildInPublic
```
**First comment:** `Get StreakFlow free on Google Play: https://play.google.com/store/apps/details?id=com.codesapience.streakflow`

### Post 2: Codesapience company page
```
Introducing StreakFlow, now on Google Play. ✅

A simple, private habit tracker whose streaks follow your real schedule, so rest days never count against you.

• Free for up to 20 habits
• No account needed, works offline
• Reminders, calendar history, stats and achievements

Get it here: https://play.google.com/store/apps/details?id=com.codesapience.streakflow

#StreakFlow #HabitTracker #Productivity #AndroidApp
```

### Post 3: Lessons follow-up (personal, ~1 week after launch)
```
3 things I learned shipping my first app through Google Play's closed testing:

1️⃣ Your release build is a different app. My debug builds were perfect. Then one update closed right after launch on a real phone. The cause was code shrinking, which only runs in the release build. Now every release build gets launched on a real device before upload. No exceptions.

2️⃣ Testers are doing you a favour, so make it easy. A two-line WhatsApp message with the opt-in link worked better than any formal invite.

3️⃣ "Free" needs to be genuinely useful. I raised the free plan from 5 to 20 habits during testing. A paywall that hits before someone has built a real routine isn't a business model. It's an exit door.

12 updates later, StreakFlow is live. What's the most surprising thing you learned shipping a product?

#IndieDev #MobileDev #Flutter #LessonsLearned #BuildInPublic
```

---

## X / Twitter

280-character limit. Put links in a reply, except in the last post of a thread. Use 1–2 hashtags at most.

### Launch post (pin it), `reel-15s-1080x1920.mp4` or `story-flyer-1080x1920.png`
```
StreakFlow is live on Google Play 🚀

A habit tracker whose streaks follow your real schedule, so rest days never break them.

✅ Free for 20 habits
✅ No account
✅ Works offline

Link below 👇
```
**Reply:** `Get it free: https://play.google.com/store/apps/details?id=com.codesapience.streakflow`

### Build-in-public thread (personal account)
```
1/ I just shipped my first Android app, a habit tracker called StreakFlow.

Here's what a closed test, 12 updates and 1 scary crash taught me 🧵
```
```
2/ The idea: most habit apps reset your streak on rest days. If you train Mon/Wed/Fri, Tuesday isn't a failure. So StreakFlow's streaks follow each habit's actual schedule.
```
```
3/ Google requires new developers to run a closed test with 12 testers for 14 days. A two-line WhatsApp message with the opt-in link worked better than a polished email.
```
```
4/ The scary part: one update closed right after launch on a real phone. Debug builds were fine. The culprit was code shrinking, which only runs in release builds.

Lesson: launch every release build on a real device before uploading.
```
```
5/ I raised the free plan from 5 to 20 habits during testing. People need to build a real routine before Premium means anything.
```
```
6/ No account. Works offline. Data stays on your phone. 585 automated tests.

It's live now. Feedback very welcome 🙏

https://play.google.com/store/apps/details?id=com.codesapience.streakflow

#buildinpublic #indiedev
```

### Feature posts (spread over the following week)
With `post-1-offdays-1080x1080.png`:
```
Rest days are part of the plan, not a failure.

StreakFlow only counts the days you scheduled. Mon/Wed/Fri habit? Tuesday doesn't break anything. 🔥
```
With `post-2-free-1080x1080.png`:
```
A habit tracker that doesn't want your email.

No sign-up. Works offline. Free for up to 20 habits. 🔒
```
With `post-3-progress-1080x1350.png`:
```
💧 Drink water
📖 Read 20 pages
🏃 Move

Small wins add up, and StreakFlow shows you exactly how much. 📈
```
With a screenshot of the +1 · 3/8 card (build 17):
```
Some habits aren't once a day.

8 glasses of water? Tap +1 each time. StreakFlow only counts the day when you hit 8/8. 💧
```
Engagement post (no image; fill in [your habit] or delete that line):
```
What's one habit you've kept for more than 30 days in a row?

Mine's [your habit]. Building an app about streaks made me take my own more seriously 😅
```
Best times: weekday mornings US time for the indie-dev audience; 9–11am IST for India.

---

## YouTube Shorts

**Video:** `meta-ads/youtube-short-20s-1080x1920.mp4` (20 s, with audio: soft background pad plus the app's notification chime). Text stays clear of YouTube's right-hand buttons and bottom title area. Scenes: hook → "Not with StreakFlow." → habits, calendar and details screens → closing screen ("Search StreakFlow on Google Play").

Links in a Short's description **aren't clickable** in the Shorts feed, so the video tells viewers to *search*. Clickable options: a pinned comment (clickable on the watch page), the channel bio links, and YouTube's "Related video" field linking to a longer video.

To swap the music: use the YouTube Shorts editor on your phone (Add sound) or a track from the YouTube Audio Library, at low volume.

### Short 1: launch Short
**Title (≤100 characters; YouTube shows the first ~40 in the feed):**
```
Rest days shouldn't break your streak 🔥 #Shorts
```
Alternatives:
```
The habit tracker that understands rest days #Shorts
```
```
Took a rest day and lost your streak? 😩 #Shorts
```

**Description:**
```
Took a rest day and your streak reset? StreakFlow follows your real schedule. Set a habit for Mon, Wed and Fri, and off days never count against you. 🔥

✅ Free for up to 20 habits
✅ No account or sign-up
✅ Works fully offline
✅ Reminders, calendar history, stats and achievements

📲 Search "StreakFlow" on Google Play, or:
https://play.google.com/store/apps/details?id=com.codesapience.streakflow

🌐 https://streakflow.codesapience.com
Made by Codesapience.

#Shorts #HabitTracker #Productivity #Habits #SelfImprovement
```
(YouTube shows the first 3 hashtags above the title; put the most important ones first.)

**Tags** (Studio → Show more → Tags):
```
habit tracker, streak app, habit tracker app, build habits, daily habits, productivity app, streakflow, free habit tracker, android habit tracker, offline habit tracker
```

**Pinned comment:**
```
📲 Get StreakFlow free on Google Play: https://play.google.com/store/apps/details?id=com.codesapience.streakflow
What habit are you building right now? 👇
```

**Upload settings:** Audience = "No, it's not made for kids" (the app is 13+). Category = Science & Technology or Howto & Style. Thumbnail: Shorts thumbnails are only selectable on the phone app; pick the "Not with StreakFlow." frame (~5 s).

### Channel setup
- **Channel name:** `StreakFlow`, handle `@streakflow` (or `@streakflowapp`)
- **Channel description:**
```
StreakFlow is a simple, private habit tracker whose streaks follow your real schedule, so rest days never break them. Free for up to 20 habits, no account needed, works offline. Tips on building habits that stick, plus app updates. Made by Codesapience.
```
- **Channel links:** Google Play link + website (these are clickable on the channel page).

### Follow-up Short ideas (record your phone screen, 15–30 s)
1. "Set up a Mon/Wed/Fri habit in 10 seconds": the add-habit flow.
2. "My 30-day streak": real use, ending on the calendar view.
3. "3 habits for students": add Study / Read / Sleep, show completing one.
4. "8 glasses, one tap at a time": a Drink water habit with a target of 8, tapping +1 until 8/8 and the streak ticks up.

---

## WhatsApp

**Broadcast lists only reach people who have saved your number.** Contacts who haven't won't get the message. For everyone else, post to Status or share directly.

### Status (one image or video per status; captions are short and links are clickable)

**Status 1:** `reel-15s-1080x1920.mp4` (WhatsApp Status allows videos up to 60 s)
```
My app StreakFlow is live on Google Play! 🚀 Free habit tracker, no sign-up 👉 https://play.google.com/store/apps/details?id=com.codesapience.streakflow
```

**Status 2:** `story-flyer-1080x1920.png`
```
Rest days don't break your streak 🔥 Try it free: https://play.google.com/store/apps/details?id=com.codesapience.streakflow
```

**Status 3:** `post-2-free-1080x1080.png`
```
No account. Works offline. Free for 20 habits. Would love your feedback 🙏
```

Post them a few hours apart, or over 2–3 days, so they don't all disappear at the same time.

### Broadcast 1: Launch announcement (friends, family, colleagues)
```
Hi! 👋

Some exciting news: my app *StreakFlow* is now live on the Google Play Store! 🚀

It's a simple habit tracker. You can track things like drinking water, exercise, reading or study, and build streaks. Streaks follow your own schedule, so rest days never break them.

✅ Free (up to 20 habits)
✅ No sign-up needed
✅ Works offline

📲 Download: https://play.google.com/store/apps/details?id=com.codesapience.streakflow

If you try it, I'd really appreciate your honest feedback, just reply here. And if you know someone who's trying to build a habit, please share it with them 🙏

Thank you!
```

### Broadcast 2: Thank-you to closed testers + review request
```
Hi! 🙏

Thank you so much for testing *StreakFlow* over the last few weeks. Because of you, it's now live on the Google Play Store! 🎉

You can keep using the same app; updates will keep coming through Play Store as usual.

One small favour: if you've found it useful, could you leave an honest rating and a short review on the Play Store? It really helps a new app get discovered.

⭐ https://play.google.com/store/apps/details?id=com.codesapience.streakflow

Thanks again for your help, it means a lot!
```
(Ask only for an honest review. Don't ask for 5 stars or offer anything in return, which is against Play policy.)

### Broadcast 3: Short reminder (~1 week later, optional)
```
Quick one 😊 Have you tried StreakFlow yet? If you're building a new habit this month, it's free and takes a minute to set up:
https://play.google.com/store/apps/details?id=com.codesapience.streakflow

Any feedback, just reply here!
```

Formatting: `*text*` = **bold** on WhatsApp. Send broadcasts in small batches (lists of up to 256 contacts each), and don't send more than one a week.

---

## Paid ads (Meta)

Full copy and file-to-placement table: [meta-ads/AD_COPY.md](meta-ads/AD_COPY.md).

Suggested first campaign once live: an app-install campaign with Advantage+ placements, about ₹300–500/day for 7 days, using all 3 posts plus the Reel. Then keep the creative with the lowest cost per install.

---

## Appendix: Play Console production-access answers (short versions)

Full drafts: [docs/PLAY_CONSOLE_CHECKLIST.md](../docs/PLAY_CONSOLE_CHECKLIST.md) §10.

- **Recruiting:** Invited friends, family and colleagues directly via WhatsApp and email with the opt-in link. No paid service.
- **How easy:** Easy
- **Feedback (≤300 characters):** Feedback came via WhatsApp, email and the in-app feedback option. Testers said [real point]. One update crashed on launch due to release-build code shrinking; I fixed it and now test every release build on a device. I shipped 12 updates during the test.
- **Intended audience:** StreakFlow is for teens (13+) and adults who want to build daily or weekly habits, like fitness, study, health, finance or mindfulness. They can track streaks and progress offline without creating an account. It isn't designed for children under 13.
- **Value:** StreakFlow tracks habits with streaks that follow each habit's schedule, so off days never break a streak. It offers reminders, calendar history, stats and achievements, works offline with no account, and is free for up to 20 habits. Optional Premium adds unlimited habits and insights.
- **Expected installs (first year):** 0–10K
- **Changes from testing:** Fixed a release-only launch crash and now test every release build on a device. Corrected streak and stats calculations, made reminders follow each habit's schedule, added starter habits during onboarding, raised the free limit from 5 to 20 habits, added Premium restore, added an in-app Send feedback option and dashboard feedback prompt, made habits with a daily target count each step, and fixed the calendar's completion rate (build 17).
- **Ready for production:** The closed test ran 14+ days with 12 testers. Every release passes 585 automated tests and a manual launch test on a device. Android vitals show no crashes or ANRs, and Premium purchase, restore and cancel were tested end to end with license testers.
