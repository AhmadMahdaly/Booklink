import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/features/main_layout/main_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignAsVisitor extends StatelessWidget {
  const SignAsVisitor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const NavigationBarApp();
            },
          ),
        );
      },
      child: Text(
        'SkipNow'.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF3E5879),
          fontSize: 14.sp,
          fontWeight: FontWeight.w800,
          decoration: TextDecoration.underline,
          decorationColor: kMainColor,
        ),
      ),
    );
  }
}
