package com.codesapience.streakflow

import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.app.NotificationManagerCompat
import java.util.Calendar
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : FlutterActivity() {

    /** Screen time for "Digital detox" habits; see screen_time_service.dart. */
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.codesapience.streakflow/screen_time",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasUsageAccess" -> result.success(ScreenTime.hasUsageAccess(this))

                "openUsageAccessSettings" -> {
                    startActivity(
                        Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
                    )
                    result.success(null)
                }

                "screenTimeMinutes" -> {
                    val start = call.argument<Number>("start")?.toLong()
                    val end = call.argument<Number>("end")?.toLong()
                    if (start == null || end == null) {
                        result.error("bad_args", "start and end are required", null)
                    } else {
                        result.success(ScreenTime.minutesBetween(this, start, end))
                    }
                }

                "syncLimits" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    val limits = call.argument<List<Map<String, Any?>>>("limits").orEmpty()
                    val json = JSONArray(limits.map { JSONObject(it) })
                    ScreenTimeWorker.sync(applicationContext, enabled, json.toString())
                    result.success(null)
                }

                // Hidden diagnostics panel (tap "Screen time today" 5 times).
                "diagnostics" -> result.success(diagnostics())

                else -> result.notImplemented()
            }
        }
    }

    private fun diagnostics(): Map<String, Any?> {
        val prefs = getSharedPreferences(ScreenTimeWorker.PREFS, Context.MODE_PRIVATE)
        val limits = JSONArray(prefs.getString(ScreenTimeWorker.KEY_LIMITS, "[]"))
        val startOfDay = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
        val minutes = ScreenTime.minutesBetween(this, startOfDay, System.currentTimeMillis())

        return mapOf(
            "Device" to "Android ${Build.VERSION.RELEASE} (API ${Build.VERSION.SDK_INT})",
            "Usage access" to if (ScreenTime.hasUsageAccess(this)) "on" else "OFF",
            "Notifications" to
                if (NotificationManagerCompat.from(this).areNotificationsEnabled()) "allowed" else "DENIED",
            "Screen time today" to (minutes?.let { "${it}m" } ?: "unknown"),
            "Limits (background check)" to (0 until limits.length()).map {
                val limit = limits.getJSONObject(it)
                "${limit.getString("title")}: ${limit.getInt("limitMinutes")}m"
            },
            "Alerts sent" to prefs.getStringSet("sent", emptySet())!!.sorted(),
        )
    }
}
