import 'package:biblio/booklink.dart';
import 'package:biblio/core/init/initializer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  await initializeApp();

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
}

/// shorebird release android
/// shorebird patch --platforms=android --release-version=1.0.12+13
