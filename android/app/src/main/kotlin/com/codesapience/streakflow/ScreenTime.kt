package com.codesapience.streakflow

import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Process

/**
 * Screen time from UsageStatsManager ("Usage access", granted by the
 * user in system settings). Read on the device only; nothing is sent
 * anywhere.
 */
object ScreenTime {

    fun hasUsageAccess(context: Context): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName,
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName,
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    /**
     * Minutes with an app in the foreground between [start] and [end]
     * (epoch millis; [end] is capped at now), or null when unknown: no
     * usage access, or no usage events at all in the period.
     *
     * Follows the one app in the foreground, so overlapping activity
     * transitions are not counted twice. The home screen (launcher)
     * doesn't count as screen time.
     */
    fun minutesBetween(context: Context, start: Long, end: Long): Int? {
        if (!hasUsageAccess(context)) return null

        val until = minOf(end, System.currentTimeMillis())
        if (until <= start) return 0

        val manager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val events = manager.queryEvents(start, until) ?: return null
        val launchers = launcherPackages(context)

        var total = 0L
        var current: String? = null
        var since = start
        var sawEvents = false
        val event = UsageEvents.Event()

        fun close(at: Long) {
            if (current != null) total += (at - since).coerceAtLeast(0)
            current = null
        }

        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            sawEvents = true

            when (event.eventType) {
                UsageEvents.Event.ACTIVITY_RESUMED -> {
                    close(event.timeStamp)
                    if (event.packageName !in launchers) {
                        current = event.packageName
                        since = event.timeStamp
                    }
                }

                UsageEvents.Event.ACTIVITY_PAUSED,
                UsageEvents.Event.ACTIVITY_STOPPED -> {
                    if (event.packageName == current) close(event.timeStamp)
                }

                UsageEvents.Event.SCREEN_NON_INTERACTIVE,
                UsageEvents.Event.KEYGUARD_SHOWN,
                UsageEvents.Event.DEVICE_SHUTDOWN -> close(event.timeStamp)
            }
        }
        close(until)

        if (!sawEvents) return null
        return (total / 60_000L).toInt()
    }

    private fun launcherPackages(context: Context): Set<String> {
        val home = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
        return context.packageManager
            .queryIntentActivities(home, PackageManager.MATCH_DEFAULT_ONLY)
            .map { it.activityInfo.packageName }
            .toSet()
    }
}
