package com.sunish.quick_bocks

//import io.flutter.app.FlutterApplication
//import io.flutter.plugin.common.PluginRegistry
//import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
//import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

//import `in`.jvapps.system_alert_window.SystemAlertWindowPlugin
//import io.flutter.app.FlutterApplication
//import io.flutter.plugin.common.PluginRegistry
//import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
//import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
//import io.flutter.view.FlutterMain
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
//import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
//
//import android.os.Build
//import android.app.NotificationManager
//import android.app.NotificationChannel
//import android.content.Context.NOTIFICATION_SERVICE
//
//
//public class Application: FlutterApplication(), PluginRegistrantCallback {
//
//    override fun onCreate() {
//        super.onCreate();
//        FlutterFirebaseMessagingService.setPluginRegistrant(this);
//        SystemAlertWindowPlugin.setPluginRegistrant(this);
//        createNotificationChannels();
//        FlutterMain.startInitialization(this);
//    }
//
//    override fun registerWith(registry: PluginRegistry?) {
//        if (!registry!!.hasPlugin("io.flutter.plugins.firebasemessaging")) {
//            FirebaseMessagingPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
//        }
//        if (!registry!!.hasPlugin("in.jvapps.system_alert_window")) {
//            SystemAlertWindowPlugin.registerWith(registry!!.registrarFor("in.jvapps.system_alert_window"));
//        }
//        if (!registry!!.hasPlugin("plugins.flutter.io.shared_preferences")) {
//            SharedPreferencesPlugin.registerWith(registry!!.registrarFor("plugins.flutter.io.shared_preferences"));
//        }
//    }
//
//    fun createNotificationChannels() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val name = "groupChannel";
//            val descriptionText = "This is the group channel";
//            val importance = NotificationManager.IMPORTANCE_HIGH;
//            val mChannel = NotificationChannel("59054", name, importance);
//            mChannel.description = descriptionText;
//            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager;
//            notificationManager.createNotificationChannel(mChannel);
//        }
//    }
//}


import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import io.flutter.view.FlutterMain
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin

class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
        FlutterMain.startInitialization(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        FirebaseMessagingPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
        FlutterLocalNotificationsPlugin.registerWith(registry!!.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    }
}