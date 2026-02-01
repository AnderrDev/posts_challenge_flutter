package com.example.posts_challenge

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity(), NotificationApi, NotificationPermissionApi {
    companion object {
        const val CHANNEL_ID = "smart_notifications_channel"
        const val NOTIFICATION_ID = 1
        const val PERMISSION_REQUEST_CODE = 101
    }

    private var pendingResult: ((Result<Boolean>) -> Unit)? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Setup Pigeon API
        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger
        NotificationApi.setUp(binaryMessenger, this)
        NotificationPermissionApi.setUp(binaryMessenger, this)
        createNotificationChannel()
    }

    override fun showNotification(payload: NotificationPayload) {
        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle(payload.title)
            .setContentText(payload.body)
            .setPriority(NotificationCompat.PRIORITY_HIGH)

        val notificationManager: NotificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(NOTIFICATION_ID, builder.build())
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Smart Notifications"
            val descriptionText = "Notifications for likes"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    override fun checkPermission(): Boolean {
        if (Build.VERSION.SDK_INT >= 33) {
            return checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) == 
                android.content.pm.PackageManager.PERMISSION_GRANTED
        }
        return true
    }

    override fun requestPermission(callback: (Result<Boolean>) -> Unit) {
        if (Build.VERSION.SDK_INT >= 33) {
            if (checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) == 
                android.content.pm.PackageManager.PERMISSION_GRANTED) {
                callback(Result.success(true))
            } else {
                pendingResult = callback
                requestPermissions(
                    arrayOf(android.Manifest.permission.POST_NOTIFICATIONS),
                    PERMISSION_REQUEST_CODE
                )
            }
        } else {
            callback(Result.success(true))
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            val granted = grantResults.isNotEmpty() && 
                grantResults[0] == android.content.pm.PackageManager.PERMISSION_GRANTED
            pendingResult?.invoke(Result.success(granted))
            pendingResult = null
        }
    }
}
