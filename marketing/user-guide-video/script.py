# Scene list for the StreakFlow user guide video (build 1.0.0+15).
# shot: screenshot name in shots/ (None = branded card), chap: chapter label,
# title/caption: on-screen text, tap: optional (x, y) device px to highlight, say: narration.

SCENES = [
    dict(shot=None, chap="", title="StreakFlow", caption="User Guide",
         say="Welcome to StreakFlow, the simple habit tracker that helps you build better habits, one day at a time. "
             "In this short guide, we'll set up the app, add habits, track them every day, "
             "and tour the dashboard, calendar, statistics, achievements and settings. Let's get started."),

    # ---- Setup
    dict(shot="01", chap="Getting started", title="Welcome", caption="A quick 6-step setup", tap=(540, 2205),
         say="When you open StreakFlow for the first time, a short six-step setup gets you going. Tap Continue to begin."),
    dict(shot="02", chap="Getting started", title="Your name", caption="Used to greet you on the home screen",
         say="First, enter your name. StreakFlow uses it to greet you on the home screen."),
    dict(shot="03", chap="Getting started", title="Pick your goals", caption="Choose one or more areas to improve",
         say="Next, choose the areas you want to improve, such as Fitness and Learning. "
             "You can pick as many as you like, and change them later."),
    dict(shot="04", chap="Getting started", title="Start with a few habits", caption="Suggestions picked for your goals",
         say="Based on your goals, StreakFlow suggests a few habits to start with. "
             "Tap to choose the ones you want. Here, Workout and Read twenty pages are selected. "
             "You can edit them, or add more, at any time."),
    dict(shot="05b", chap="Getting started", title="Daily reminders", caption="A gentle nudge keeps your streak alive", tap=(842, 1552),
         say="Then turn on daily reminders. A gentle nudge at the right time is one of the best ways to keep your streak alive."),
    dict(shot="06", chap="Getting started", title="You're all set", caption="Tap Start My Streak", tap=(540, 2205),
         say="And that's it. Tap Start My Streak to open the app."),
    dict(shot="07", chap="Getting started", title="Ready to go", caption="Your chosen habits are already waiting",
         say="The habits you picked are already waiting on your home screen, ready for today."),

    # ---- Add a habit
    dict(shot="08", chap="Add a habit", title="The Habits tab", caption="Tap Add Habit to create your own", tap=(857, 2032),
         say="Now let's add a habit of our own. Open the Habits tab, and tap Add Habit."),
    dict(shot="09", chap="Add a habit", title="Ideas for you", caption="Tap an idea to fill in the form",
         say="At the top, Ideas for you suggests habits based on your goals. Tap one to fill in the form instantly, "
             "or tap More ideas to see the rest. We'll write our own instead."),
    dict(shot="10", chap="Add a habit", title="Name it", caption="Title plus an optional description",
         say="Give your habit a clear title, like Drink water, and an optional description, such as eight glasses a day."),
    dict(shot="11", chap="Add a habit", title="Choose an icon", caption="Appearance → Icon",
         say="Under Appearance, tap Icon to choose a symbol,"),
    dict(shot="12", chap="Add a habit", title="Choose a colour", caption="Appearance → Color",
         say="and tap Color to pick a colour, so every habit is easy to spot at a glance."),
    dict(shot="14", chap="Add a habit", title="Schedule & daily target", caption="Category, frequency and how many times a day", tap=(912, 1525),
         say="In Schedule, choose a category and a frequency: daily, weekly, monthly, or custom days. "
             "Then set a daily target. We want eight glasses, so the target is eight."),
    dict(shot="15", chap="Add a habit", title="Add a reminder", caption="Pick the time you want to be nudged",
         say="Turn on Reminder, and pick a time. StreakFlow will remind you at that time every day."),
    dict(shot="16", chap="Add a habit", title="Reminder set", caption="Add more reminder times if you need them",
         say="You can add more reminder times if you need them, and set an end date if the habit is only for a while."),
    dict(shot="17", chap="Add a habit", title="Preview & save", caption="Tap the Add Habit button", tap=(857, 2220),
         say="The preview shows exactly how your habit will look. When you're happy, tap the Add Habit button in the corner. "
             "It stays in reach wherever you are in the form."),

    # ---- Track
    dict(shot="18", chap="Track your habits", title="Your new habit", caption="Targets above 1 count step by step", tap=(305, 1757),
         say="Your new habit appears at the top of the Habits tab. Because it has a target of eight, "
             "the button says plus one. Tap it each time you drink a glass."),
    dict(shot="19", chap="Track your habits", title="3 of 8", caption="Progress fills up with every tap",
         say="Each tap adds one step, and the progress bar fills up. Three of eight so far. "
             "The habit counts as done once you reach eight."),
    dict(shot="20", chap="Track your habits", title="More room for habits", caption="The header scrolls away as you scroll",
         say="As you scroll, the summary and filters slide away, so there's more room for your habits."),
    dict(shot="21", chap="Track your habits", title="Complete a habit", caption="Tap Complete, then confirm", tap=(745, 1377),
         say="For a simple habit, like Read twenty pages, tap Complete, and confirm."),
    dict(shot="22", chap="Track your habits", title="Streak +1", caption="Earn XP · tap Undo if you made a mistake",
         say="The card turns green, your streak goes up, and you earn XP. Tapped it by mistake? Just tap Undo."),
    dict(shot="23", chap="Track your habits", title="Manage habits", caption="Edit · Duplicate · Archive · Delete · History",
         say="Tap the three-dot menu on any habit to edit, duplicate, archive or delete it, or to see its history."),
    dict(shot="24", chap="Track your habits", title="Habit details", caption="Status, schedule, target and reminder",
         say="Tap Details to see everything about a habit: today's status, its schedule, target and reminder."),
    dict(shot="26", chap="Track your habits", title="Habit statistics", caption="Streaks, completions, missed days, XP",
         say="Open Habit Statistics for your current and best streak, completions, missed days and total XP, "
             "with week, month and year views."),
    dict(shot="27", chap="Track your habits", title="Performance", caption="Completion rate and this week at a glance",
         say="Scroll down for your completion and success rates, and a day-by-day view of the week."),

    # ---- Dashboard
    dict(shot="28", chap="Home dashboard", title="Your daily dashboard", caption="Day streak, level progress, today's score",
         say="Now the Home tab, your daily dashboard. The big card shows your day streak, your level progress, "
             "and how many of today's habits you've finished."),
    dict(shot="29", chap="Home dashboard", title="Today's habits", caption="Tick off habits right from Home",
         say="Swipe through the analytics cards, and use Today's Habits to tick off habits right from the dashboard."),
    dict(shot="31", chap="Home dashboard", title="Weekly progress", caption="Completions, XP, active days and trend",
         say="Below the mini calendar, Weekly Progress shows your completions, XP, active days, "
             "and your trend compared with last week."),
    dict(shot="32", chap="Home dashboard", title="Activity & insights", caption="What you did, and tips to keep going",
         say="Recent Activity lists what you've completed, and Insights give you short tips based on your progress."),

    # ---- Calendar & stats
    dict(shot="33", chap="Calendar & stats", title="Calendar", caption="Your whole month at a glance",
         say="The Calendar tab shows your whole month. The shading on each day shows how much you completed, "
             "from none to perfect. Tap any day to see what you did."),
    dict(shot="34", chap="Calendar & stats", title="Statistics", caption="Overview · Week · Month · Year",
         say="The Stats tab brings all your habits together: completion rate, XP, active days, "
             "your best day, and the day that needs attention."),
    dict(shot="35", chap="Calendar & stats", title="Trends", caption="Watch your consistency grow",
         say="Charts show how your consistency changes over time."),
    dict(shot="41", chap="Calendar & stats", title="Achievements", caption="Unlock milestones for streaks and XP",
         say="Stay motivated with Achievements. Unlock milestones for streaks and XP, and track your progress towards each one."),

    # ---- Settings
    dict(shot="36", chap="Settings", title="Settings", caption="Premium, archived habits, achievements, profile",
         say="In Settings, you'll find Premium, archived habits, achievements, your profile, and more."),
    dict(shot="39", chap="Settings", title="Appearance", caption="Light · Dark · System",
         say="Under Appearance, choose a light, dark, or system theme."),
    dict(shot="40", chap="Settings", title="Dark mode", caption="Easy on the eyes at night",
         say="Here's StreakFlow in dark mode."),
    dict(shot="43", chap="Settings", title="Backup & restore", caption="Your data stays on your device",
         say="Your data stays on your device, and the app works offline. Use Back up or restore to save your habits to a file, "
             "and import them again when you move to a new phone."),
    dict(shot="42", chap="Premium", title="StreakFlow Premium", caption="Optional upgrade",
         say="Want more? StreakFlow Premium adds unlimited habits, no ads, a productivity score, advanced insights, "
             "weekly and monthly reports, extra colour themes, CSV export, and up to five reminders per habit."),
    dict(shot="38", chap="Feedback", title="Tell us what you think", caption="Settings → Send feedback", tap=(540, 1490),
         say="Have an idea, or spotted a problem? Tap Send feedback in Settings. Every message helps make StreakFlow better."),

    dict(shot=None, chap="", title="Small steps. Big change.", caption="Add your first habit today",
         say="That's everything you need to get started. Remember: small steps, big change. "
             "Add your first habit today, and keep your streak going. Thanks for using StreakFlow!"),
]
