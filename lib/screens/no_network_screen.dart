import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoNetworkScreen extends StatelessWidget {
  const NoNetworkScreen({super.key});
  Future<void> fetchDate(BuildContext context) async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        strokeWidth: 0.9,
        color: kMainColor,
        onRefresh: () => fetchDate(context),
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/no-signal.png',
                  height: 100.sp,
                  color: kMainColor,
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: 347,
                  child: Text(
                    'يبدو أن هناك خطأ ما في الاتصال بالشبكة، برجاء المحاولة مرة أخرى',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
