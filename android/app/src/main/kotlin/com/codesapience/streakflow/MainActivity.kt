package com.codesapience.streakflow

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
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

                else -> result.notImplemented()
            }
        }
    }
}
