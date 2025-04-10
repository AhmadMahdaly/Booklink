import 'dart:io';
import 'dart:ui';

import 'package:biblio/booklink.dart';
import 'package:biblio/services/setup_fcm.dart';
// import 'package:biblio/services/my_observer.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:biblio/utils/controller/connectivity_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// تحقق من الإتصال بالشبكة
  await ConnectivityController.instance.init();
  await EasyLocalization.ensureInitialized();

  /// Bloc observer
  // Bloc.observer = MyObserver();

  /// load env
  await dotenv.load();

  /// Firebase
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: dotenv.env['CURRENT_KEY'] ?? '',
            appId: dotenv.env['MOBILE_SDK_APP_ID'] ?? '',
            messagingSenderId: dotenv.env['PROJECT_NUMBER'] ?? '',
            projectId: dotenv.env['PROJECT_ID'] ?? '',
          ),
        )
      : await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  /// Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await setupFCM();

  /// تهيئة Firebase Cloud Messaging
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print(fcmToken);

  /// initialize supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_KEY'] ?? '',
  );
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

/// shorebird release android
/// shorebird patch --platforms=android --release-version=1.0.12+13
