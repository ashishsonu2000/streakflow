import json, datetime as dt, random
random.seed(7)
today = dt.date.today()  # history runs up to yesterday
start = today - dt.timedelta(days=30)
def iso(d, h=0, m=0): return dt.datetime(d.year, d.month, d.day, h, m).isoformat()

# id, title, desc, category, freq, icon, color, target, weeklyDays, misses(days-ago), reminder
H = [
 ("demo-water","Drink water","8 glasses a day","health","daily",0xf05a2,0xFF2196F3,8,[],{26,25,19},(9,0)),
 ("demo-walk","Morning walk","20 minutes outside","fitness","daily",0xe1dc,0xFFFF9800,1,[],set(),(7,0)),
 ("demo-read","Read 20 pages","Any book you enjoy","learning","daily",0xe3dd,0xFF9C27B0,1,[],{22,14,9},(21,30)),
 ("demo-meditate","Meditate","10 minutes of quiet breathing","mindfulness","daily",0xe56f,0xFF009688,1,[],{28,27,17,11,4},None),
 ("demo-workout","Workout","30 minutes of exercise","fitness","weekly",0xe28d,0xFFF44336,1,[1,3,5],{20},(18,0)),
 ("demo-sleep","Sleep by 11 PM","Phone away at 10:30","health","daily",0xe0db,0xFF3F51B5,1,[],{29,23,16,15,8,2},(22,30)),
]
habits, logs = [], []
for hid,title,desc,cat,freq,icon,color,target,wd,miss,rem in H:
    done=[]
    d=start
    while d < today:
        ago=(today-d).days
        sched = (freq=="daily") or (d.isoweekday() in wd)
        if sched and ago not in miss:
            done.append(d)
            logs.append({"id":f"{hid}-{d.isoformat()}","habitId":hid,"date":iso(d),"status":"completed",
                         "completedAt":iso(d,random.randint(7,21),random.randint(0,59)),"durationMinutes":0,"notes":"","xpEarned":5,"mood":None})
        d+=dt.timedelta(days=1)
    # streaks over scheduled days
    sched_days=[start+dt.timedelta(days=i) for i in range(30) if freq=="daily" or (start+dt.timedelta(days=i)).isoweekday() in wd]
    best=cur=0
    for sd in sched_days:
        cur = cur+1 if sd in done else 0
        best=max(best,cur)
    habits.append({"id":hid,"title":title,"description":desc,"category":cat,"frequency":freq,"iconCodePoint":icon,
      "colorValue":color,"targetPerDay":target,"currentStreak":cur,"bestStreak":best,"totalCompleted":len(done),"xp":5*len(done),
      "reminderEnabled":rem is not None,"reminderHour":rem[0] if rem else None,"reminderMinute":rem[1] if rem else None,
      "additionalReminderMinutes":[],"archived":False,"createdAt":iso(start,8),"updatedAt":iso(today-dt.timedelta(days=1),21),
      "lastCompletedDate":iso(done[-1],20) if done else None,"startDate":iso(start),"endDate":None,"weeklyDays":wd,
      "monthlyDay":start.day,"estimatedDurationMinutes":15,"difficulty":"easy","xpReward":5})
    print(f"{title:15} done={len(done):2} cur={cur:2} best={best:2}")
json.dump({"version":"1.0.0","formatVersion":2,"exportedAt":iso(today,8),"habits":habits,"logs":logs},
          open("streakflow_demo_backup.json","w"),indent=1)
print(len(logs),"logs")
