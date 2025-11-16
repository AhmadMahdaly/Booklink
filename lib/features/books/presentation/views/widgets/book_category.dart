import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookPageCategory extends StatelessWidget {
  const BookPageCategory({required this.book, super.key});
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
        child: Row(
          children: [
            Text(
              'التصنيف: ',
              style: TextStyle(
                color: const Color(0xFFA2A2A2),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              book['category'].toString(),
              style: TextStyle(
                color: const Color(0xFFA2A2A2),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
