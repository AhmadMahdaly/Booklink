import 'package:biblio/core/constants/colors_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoNetworkScreen extends StatelessWidget {
  const NoNetworkScreen({super.key});
  Future<void> fetchDate(BuildContext context) async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        strokeWidth: 0.9,
        color: kMainColor,
        onRefresh: () => fetchDate(context),
        child: Center(
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
                  'NetworkError'.tr(),
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
    );
  }
}
