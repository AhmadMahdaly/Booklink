import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_widgets/border_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryForMore extends StatelessWidget {
  const CategoryForMore({
    required this.text,
    required this.icon,
    super.key,
    this.onTap,
  });
  final void Function()? onTap;
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sp),
      width: MediaQuery.of(context).size.width,
      height: 48.sp,
      decoration: ShapeDecoration(
        color: const Color(0xFFFCFCFC),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.50.sp,
            color: const Color(0xFFF7F7F7),
          ),
          borderRadius: borderRadius(),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          spacing: 6.sp,
          children: [
            8.horizontalSpace,
            Icon(
              icon,
              color: kTextColor,
              size: 20.sp,
            ),
            Text(
              text,
              style: TextStyle(
                color: kTextColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 1.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
