import 'package:biblio/core/constants/colors_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> showCustomDialog(
  BuildContext context,
  String text,
) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: kLightBlue,
          title: Text(
            'Confirm'.tr(),
            style: TextStyle(
              color: kMainColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            text,
            style: TextStyle(
              color: kMainColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(
                false,
              ),
              child: Text(
                'No'.tr(),
                style: TextStyle(
                  color: kMainColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(
                context,
              ).pop(
                true,
              ),
              child: Text(
                'Yes'.tr(),
                style: TextStyle(
                  color: kMainColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ) ??
      false;
}
