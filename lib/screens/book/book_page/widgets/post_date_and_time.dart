import 'package:biblio/core/constants/colors_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostBookDateAndTime extends StatelessWidget {
  const PostBookDateAndTime({required this.book, super.key});
  final Map<String, dynamic> book;

  @override
  Widget build(BuildContext context) {
    String getTimeDifference() {
      final now = DateTime.now();
      final specificDate = book['created_at'];
      final createdAt = DateTime.parse(specificDate.toString());
      final difference = now.difference(createdAt);
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} دقيقة';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} ساعة';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} يوم';
      } else {
        return DateFormat('dd-MM-yyyy').format(createdAt); // تاريخ واضح
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.sp,
        vertical: 5.sp,
      ),
      child: SizedBox(
        child: Text(
          'تم النشر منذ ${getTimeDifference()}',
          style: TextStyle(
            color: kMainColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
