import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    required this.title,
    required this.icon,
    super.key,
    this.onTap,
  });
  final String title;
  final String icon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 5.sp),
        width: 82.sp,
        height: 82.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.sp),
          color: kLightBlue,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5.sp,
          children: [
            5.verticalSpace,
            SizedBox(
              child: CachedNetworkImage(
                imageUrl: icon,
                height: 32.sp,
                width: 32.sp,
                color: kMainColor,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                progressIndicatorBuilder: (context, url, progress) =>
                    LoadingWidget(
                  size: 10.sp,
                ),
              ),
            ),
            SizedBox(
              height: 40.sp,
              width: 70,
              child: Align(
                child: Text(
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  title,
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            3.verticalSpace,
          ],
        ),
      ),
    );
  }
}
