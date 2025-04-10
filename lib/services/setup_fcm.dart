import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// دالة لمعالجة الإشعارات عندما يكون التطبيق مغلقًا
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await showNotification(message);
}

/// تهيئة الإشعارات عند بدء تشغيل التطبيق
Future<void> setupFCM() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  /// طلب الإذن للإشعارات
  await flutterLocalNotificationsPlugin.initialize(initSettings);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

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
