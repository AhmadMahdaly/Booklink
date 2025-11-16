import 'package:biblio/core/animations/animate_do.dart';
import 'package:biblio/core/constants/colors_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoNewMessages extends StatelessWidget {
  const NoNewMessages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFadeInUp(
      duration: 300,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          spacing: 10.sp,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.email_outlined,
              size: 46.sp,
              color: kBorderColor,
            ),
            Text(
              'No new requests'.tr(),
              style: TextStyle(
                color: kTextShadowColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
