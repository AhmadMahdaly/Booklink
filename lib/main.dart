// import 'dart:io';

import 'package:biblio/booklink.dart';
// import 'package:biblio/services/my_observer.dart';
import 'package:biblio/utils/controller/connectivity_controller.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // هذا الكود يعمل عند وصول إشعار أثناء إغلاق التطبيق
//   print("رسالة جديدة: ${message.messageId}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// تحقق من الإتصال بالشبكة
  await ConnectivityController.instance.init();
  await EasyLocalization.ensureInitialized();

  /// Bloc observer
  // Bloc.observer = MyObserver();

  /// load env
  await dotenv.load();

  // /// Firebase
  // Platform.isAndroid
  //     ? await Firebase.initializeApp(
  //         options: FirebaseOptions(
  //           apiKey: dotenv.env['CURRENT_KEY'] ?? '',
  //           appId: dotenv.env['MOBILE_SDK_APP_ID'] ?? '',
  //           messagingSenderId: dotenv.env['PROJECT_NUMBER'] ?? '',
  //           projectId: dotenv.env['PROJECT_ID'] ?? '',
  //         ),
  //       )
  //     : await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// initialize supabase
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then(
    (_) {
      runApp(
        EasyLocalization(
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
          path: 'assets/translations',
          fallbackLocale: const Locale('ar'),
          startLocale: const Locale('ar'),
          child: const Booklink(),
        ),
      );
    },
  );
}

/// shorebird patch --platforms=android --release-version=1.0.4+5
