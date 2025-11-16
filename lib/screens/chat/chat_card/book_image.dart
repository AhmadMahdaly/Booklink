import 'package:biblio/core/constants/colors_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookImage extends StatelessWidget {
  const BookImage({required this.bookImage, super.key});
  final String bookImage;
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
      child: CachedNetworkImage(
        imageUrl: bookImage,
        fit: BoxFit.cover,
        height: 60.sp,
        width: 60.sp,
        errorListener: (_) => Container(
          height: 60.sp,
          width: 60.sp,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kLightBlue,
            borderRadius: BorderRadius.circular(320),
          ),
          child: Icon(
            Icons.blur_on_outlined,
            size: 24.sp,
            color: kMainColor,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 60.sp,
          width: 60.sp,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kLightBlue,
            borderRadius: BorderRadius.circular(320),
          ),
          child: Icon(
            Icons.archive_outlined,
            size: 24.sp,
            color: kMainColor,
          ),
        ),
      ),
    );
  }
}
