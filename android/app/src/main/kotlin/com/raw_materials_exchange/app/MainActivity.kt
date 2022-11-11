package com.raw_materials_exchange.app

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.net.Uri


class MainActivity : FlutterActivity() {
    private val CHANNEL = "rawmaterials/openTelegram"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler({
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "openTelegram") {
                val batteryLevel = openTelegram()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        })

    }

    private fun openTelegram(): Int {
        val telegram = Intent(Intent.ACTION_VIEW, Uri.parse("https://telegram.me/rawpoint_partner"))
        startActivity(telegram)


        return 1
    }
}
