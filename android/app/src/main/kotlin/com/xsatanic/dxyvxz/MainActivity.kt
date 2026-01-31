package com.xsatanic.dxyvxz

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "xsatanic/service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startService" -> {
                        startForegroundService(
                            Intent(this, HeartbeatService::class.java)
                        )
                        result.success(true)
                    }
                    "stopService" -> {
                        stopService(
                            Intent(this, HeartbeatService::class.java)
                        )
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}