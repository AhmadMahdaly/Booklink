import 'dart:io';
import 'dart:ui';

import 'package:biblio/core/services/setup_fcm.dart';
import 'package:biblio/core/shared_controllers/connectivity_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConnectivityController.instance.init();
  await EasyLocalization.ensureInitialized();

  /// Bloc observer
  // Bloc.observer = MyObserver();

  await dotenv.load();

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

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await setupFCM();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_KEY'] ?? '',
  );
}
