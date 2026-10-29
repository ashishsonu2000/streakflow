package com.codesapience.streakflow

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import org.json.JSONArray
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.concurrent.TimeUnit

/**
 * "Digital detox" limit alerts: every 15 minutes (WorkManager's
 * minimum), compares today's screen time with each limit habit
 * scheduled today and notifies once at 80% and once at the limit.
 *
 * The limits come from Dart (ScreenTimeSync -> MainActivity
 * "syncLimits") and are kept in [PREFS].
 */
class ScreenTimeWorker(context: Context, params: WorkerParameters) :
    Worker(context, params) {

    override fun doWork(): Result {
        val context = applicationContext
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val limits = JSONArray(prefs.getString(KEY_LIMITS, "[]"))
        if (limits.length() == 0) return Result.success()

        val today = dayKey(Date())
        val startOfDay = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis

        val minutes = ScreenTime.minutesBetween(
            context,
            startOfDay,
            System.currentTimeMillis(),
        ) ?: return Result.success()

        // Alerts already sent, as "<day>|<habit id>|<warn|limit>".
        val sent = prefs.getStringSet(KEY_SENT, emptySet())!!
            .filter { it.startsWith("$today|") }
            .toMutableSet()
        val before = sent.size

        for (i in 0 until limits.length()) {
            val limit = limits.getJSONObject(i)
            val days = limit.getJSONArray("days")
            val scheduledToday = (0 until days.length()).any { days.getString(it) == today }
            if (!scheduledToday) continue

            val id = limit.getString("id")
            val title = limit.getString("title")
            val limitMinutes = limit.getInt("limitMinutes")
            val warnMinutes = limitMinutes * 4 / 5

            if (minutes >= limitMinutes) {
                if (sent.add("$today|$id|limit")) {
                    sent.add("$today|$id|warn")
                    notify(
                        context,
                        id,
                        "$title: limit reached",
                        "You've had ${format(minutes)} of screen time today " +
                            "(limit ${format(limitMinutes)}). " +
                            suggestion(id, today),
                    )
                }
            } else if (minutes >= warnMinutes && limitMinutes >= 30) {
                if (sent.add("$today|$id|warn")) {
                    notify(
                        context,
                        id,
                        "$title: ${format(limitMinutes - minutes)} left",
                        "${format(minutes)} of your ${format(limitMinutes)} " +
                            "screen-time limit used today.",
                    )
                }
            }
        }

        if (sent.size != before) {
            prefs.edit().putStringSet(KEY_SENT, sent).apply()
        }
        return Result.success()
    }

    companion object {
        const val PREFS = "screen_time"
        const val KEY_LIMITS = "limits"
        private const val KEY_SENT = "sent"

        private const val PERIODIC_WORK = "screen_time_check"
        private const val NOW_WORK = "screen_time_check_now"

        private const val CHANNEL_ID = "screen_time_limits"
        private const val CHANNEL_NAME = "Screen-time limits"

        /** Ideas for a screen-free break, one per alert. */
        private val SUGGESTIONS = listOf(
            "Try a 10-minute walk.",
            "Read 5 pages of a book.",
            "Stretch for 5 minutes.",
            "Drink a glass of water and look out the window.",
            "Call or message a friend instead of scrolling.",
            "Take 5 slow, deep breaths.",
            "Tidy up one small corner of your room.",
            "Write down three things you're grateful for.",
        )

        /** Stores [limitsJson] and starts or stops the periodic check. */
        fun sync(context: Context, enabled: Boolean, limitsJson: String) {
            val limits = if (enabled) limitsJson else "[]"
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .edit()
                .putString(KEY_LIMITS, limits)
                .apply()

            val workManager = WorkManager.getInstance(context)

            if (JSONArray(limits).length() == 0) {
                workManager.cancelUniqueWork(PERIODIC_WORK)
                return
            }

            workManager.enqueueUniquePeriodicWork(
                PERIODIC_WORK,
                ExistingPeriodicWorkPolicy.KEEP,
                PeriodicWorkRequestBuilder<ScreenTimeWorker>(15, TimeUnit.MINUTES).build(),
            )
            // A first check right away (e.g. a limit already passed today).
            workManager.enqueueUniqueWork(
                NOW_WORK,
                ExistingWorkPolicy.REPLACE,
                OneTimeWorkRequestBuilder<ScreenTimeWorker>().build(),
            )
        }

        private fun dayKey(date: Date): String =
            SimpleDateFormat("yyyy-MM-dd", Locale.US).format(date)

        private fun format(minutes: Int): String {
            val hours = minutes / 60
            val rest = minutes % 60
            return when {
                hours == 0 -> "${rest}m"
                rest == 0 -> "${hours}h"
                else -> "${hours}h ${rest}m"
            }
        }

        /** Changes daily and differs between habits. */
        private fun suggestion(habitId: String, day: String): String {
            val index = Math.floorMod((habitId + day).hashCode(), SUGGESTIONS.size)
            return SUGGESTIONS[index]
        }

        private fun notify(context: Context, habitId: String, title: String, body: String) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.POST_NOTIFICATIONS,
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                return
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val manager = context.getSystemService(NotificationManager::class.java)
                manager.createNotificationChannel(
                    NotificationChannel(
                        CHANNEL_ID,
                        CHANNEL_NAME,
                        NotificationManager.IMPORTANCE_HIGH,
                    ).apply {
                        description = "Alerts when you reach a Digital detox screen-time limit"
                    },
                )
            }

            val open = PendingIntent.getActivity(
                context,
                0,
                Intent(context, MainActivity::class.java)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP),
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
            )

            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(title)
                .setContentText(body)
                .setStyle(NotificationCompat.BigTextStyle().bigText(body))
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setContentIntent(open)
                .setAutoCancel(true)
                .build()

            // One notification per habit: the limit alert replaces the 80% one.
            NotificationManagerCompat.from(context)
                .notify("screen_time".hashCode() xor habitId.hashCode(), notification)
        }
    }
}
