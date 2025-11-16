import 'package:biblio/core/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    this.isActive = true,
    this.onTap,
    super.key,
    this.padding = 0,
  });

  final String text;
  final bool isActive;
  final void Function()? onTap;
  final int padding;
  @override
  Widget build(BuildContext context) {
    return isActive
        ? InkWell(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: padding.sp),
              alignment: Alignment.center,
              width: double.infinity,
              height: 56.sp,
              decoration: ShapeDecoration(
                color: kMainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          )
        : InkWell(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: padding.sp),
              alignment: Alignment.center,
              width: double.infinity,
              height: 56.sp,
              decoration: ShapeDecoration(
                color: kDisableButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: kTextShadowColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
  }
}

class CustomBorderBotton extends StatelessWidget {
  const CustomBorderBotton({
    required this.text,
    this.padding = 0,
    this.borderColor = kMainColor,
    super.key,
    this.onTap,
  });

  final Color borderColor;
  final void Function()? onTap;
  final String text;
  final int padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: padding.sp),
        alignment: Alignment.center,
        width: double.infinity,
        height: 56.sp,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
            side: const BorderSide(),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            color: kMainColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
