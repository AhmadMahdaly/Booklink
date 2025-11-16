import 'package:biblio/core/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookPageDescription extends StatelessWidget {
  const BookPageDescription({required this.book, super.key});
  final Map<String, dynamic> book;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.sp,
        vertical: 5.sp,
      ),
      child: SizedBox(
        width: 351.sp,
        child: Text(
          book['description'].toString(),
          style: TextStyle(
            color: kTextColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.85,
          ),
        ),
      ),
    );
  }
}
