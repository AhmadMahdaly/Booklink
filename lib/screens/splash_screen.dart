import 'package:biblio/animations/animate_do.dart';
import 'package:biblio/screens/auth_check.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// this splash screen for my app //
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String id = 'SplashScreen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // This is setting the time for disappeare //
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthCheck(),
        ),
      );
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomFadeInDown(
              duration: 600,
              child: SizedBox(
                height: 100.sp,
                width: 140.sp,
                child: Image.asset(
                  'assets/icons/icon.png',
                  width: 140.sp,
                ),
              ),
            ),
            const H(h: 10),
            Text(
              'BookLink',
              style: TextStyle(
                color: kLightBlue,
                fontSize: 32.sp,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
