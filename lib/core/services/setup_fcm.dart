import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// دالة لمعالجة الإشعارات عندما يكون التطبيق مغلقًا
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await showNotification(message);
}

final supabase = Supabase.instance.client;
final _firebaseMessaging = FirebaseMessaging.instance;

/// تهيئة الإشعارات عند بدء تشغيل التطبيق
Future<void> setupFCM() async {
  const androidSettings = AndroidInitializationSettings('ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  /// طلب الإذن للإشعارات
  await flutterLocalNotificationsPlugin.initialize(initSettings);
  await _firebaseMessaging.setAutoInitEnabled(true);

  /// استقبال الإشعارات أثناء تشغيل التطبيق
  FirebaseMessaging.onMessage.listen(showNotification);

  /// استقبال الإشعارات عند النقر على الإشعار
  FirebaseMessaging.onMessageOpenedApp.listen(showNotification);
}

/// دالة لإظهار الإشعار المحلي
Future<void> showNotification(RemoteMessage message) async {
  const androidDetails = AndroidNotificationDetails(
    '1',
    'General Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  // const iosDetails = DarwinNotificationDetails();
  const notificationDetails = NotificationDetails(
    android: androidDetails,
    //  iOS: iosDetails
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? 'NowNotification'.tr(),
    message.notification?.body ?? '',
    notificationDetails,
  );
}

Future<void> saveTokenToSupabase(String token) async {
  try {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      await supabase.from('fcm_tokens').upsert(
        {
          'user_id': userId,
          'token': token,
          'platform': 'android',
        },
        onConflict: 'user_id, token',
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error saving FCM token: $e');
    }
  }
}

Future<void> deleteTokenToSupabase() async {
  try {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      await supabase.from('fcm_tokens').delete().eq('user_id', userId);
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error delete FCM token: $e');
    }
  }
}

Future<void> initNotifications() async {
  await _firebaseMessaging.requestPermission();
  final fcmToken = await _firebaseMessaging.getToken();

  if (fcmToken != null) {
    // print('FCM Token: $fcmToken');
    await saveTokenToSupabase(fcmToken);
  }
  _firebaseMessaging.onTokenRefresh.listen(saveTokenToSupabase);
}
