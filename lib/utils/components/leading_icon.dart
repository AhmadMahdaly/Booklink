import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeadingIcon extends StatelessWidget {
  const LeadingIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context); // إزالة جميع الصفحات
      },
      icon: Icon(
        Icons.arrow_back_ios_new,
        size: 22.sp,
        color: kMainColor,
      ),
    );
  }
}
