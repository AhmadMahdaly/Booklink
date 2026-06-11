import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/services/providers/main_app_providers.dart';
import 'package:biblio/features/auth/presentation/views/login_screen.dart';
import 'package:biblio/features/auth/presentation/views/register_page.dart';
import 'package:biblio/features/books/presentation/views/add_book.dart';
import 'package:biblio/features/books/presentation/views/edit_my_book.dart';
import 'package:biblio/features/chat/presentation/views/order_book/order_book_page.dart';
import 'package:biblio/features/intro/onboard/onboard_screen.dart';
import 'package:biblio/features/intro/splash/splash_screen.dart';
import 'package:biblio/features/main_layout/main_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Booklink extends StatelessWidget {
  const Booklink({super.key});

  @override
  Widget build(BuildContext context) {
    /// ScreenUtils
    return ScreenUtilInit(
      designSize: const Size(
        390,
        844,
      ),
      minTextAdapt: true,
      child:

          /// Remove focus from any input element
          GestureDetector(
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.unfocus();
          }
        },
        child: MultiBlocProvider(
          providers: mainAppProviders(),

          /// MaterialApp
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ReBook',
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
            ],

            /// Localizations
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,

            /// Theme
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                backgroundColor: kScaffoldBackgroundColor,
                iconTheme: IconThemeData(
                  color: kMainColor,
                ),
              ),
              scaffoldBackgroundColor: kScaffoldBackgroundColor,
              textTheme: Theme.of(
                context,
              ).textTheme.apply(
                    fontFamily: 'Avenir',
                  ),
            ),

            /// Routes
            routes: {
              SplashScreen.id: (context) => const SplashScreen(),
              OnboardScreen.id: (context) => const OnboardScreen(),
              LoginScreen.id: (context) => const LoginScreen(),
              RegisterScreen.id: (context) => const RegisterScreen(),
              NavigationBarApp.id: (context) => const NavigationBarApp(),
              AddBook.id: (context) => const AddBook(),
              EditBook.id: (context) => const EditBook(),
              OrderTheBookPage.id: (context) => const OrderTheBookPage(),
            },
            initialRoute: SplashScreen.id,
          ),
        ),
      ),
    );
  }
}
