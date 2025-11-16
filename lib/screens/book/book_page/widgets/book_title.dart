import 'package:biblio/core/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookPageTitle extends StatelessWidget {
  const BookPageTitle({required this.book, super.key});
  final Map<String, dynamic> book;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.sp,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.sp,
          vertical: 8.sp,
        ),
        child: Text(
          book['title'].toString(),
          style: TextStyle(
            color: kMainColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
