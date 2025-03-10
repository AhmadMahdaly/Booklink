import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportImage extends StatelessWidget {
  const SupportImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.sp),
      height: 60.sp,
      width: 60.sp,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(320),
      ),
      child: Image.asset('assets/icons/icon app.png'),
    );
  }
}
