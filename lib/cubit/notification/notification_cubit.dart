// import 'package:biblio/cubit/app_states.dart';
// import 'package:bloc/bloc.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationCubit extends Cubit<AppStates> {
//   NotificationCubit() : super(AppInitialState());

//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// // دالة لمعالجة الإشعارات عندما يكون التطبيق مغلقًا
//   Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     if (kDebugMode) {
//       print('🔔 إشعار جديد في الخلفية: ${message.notification?.title}');
//       emit(AppSuccessState());
//     }
//   } // تهيئة الإشعارات عند بدء تشغيل التطبيق

//   Future<void> setupFCM() async {
//     const androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidSettings);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

//     final messaging = FirebaseMessaging.instance;
//     await messaging.requestPermission(); // طلب الإذن للإشعارات
//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//     await FirebaseMessaging.instance.setAutoInitEnabled(true);
//     // استقبال الإشعارات أثناء تشغيل التطبيق
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('📢 إشعار مستلم: ${message.notification?.title}');
//       showNotification(message);
//       emit(AppSuccessState());
//     });

//     // استقبال الإشعارات عند النقر على الإشعار
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print('🚀 تم فتح التطبيق بسبب الإشعار: ${message.notification?.title}');
//     });
//   }

// // دالة لإظهار الإشعار المحلي
//   Future<void> showNotification(RemoteMessage message) async {
//     const androidDetails = AndroidNotificationDetails(
//       '1',
//       'General Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     // const iosDetails = DarwinNotificationDetails();
//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       //  iOS: iosDetails
//     );

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? 'إشعار جديد',
//       message.notification?.body ?? '',
//       notificationDetails,
//     );
//   }
// }
