import 'package:biblio/core/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookPrice extends StatelessWidget {
  const BookPrice({required this.book, super.key});
  final Map<String, dynamic> book;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.sp,
      ),
      child: Row(
        children: [
          if (book['offer_type'].toString() == 'للبيع')
            Container(
              width: 100,
              height: 26,
              // margin: EdgeInsets.symmetric(horizontal: 16.sp),
              decoration: ShapeDecoration(
                color: const Color(0xFFF0F6FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.sp),
                    bottomRight: Radius.circular(12.sp),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5.sp,
                children: [
                  Text(
                    book['price'].toString(),
                    style: TextStyle(
                      color: kMainColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' جنيه',
                    style: TextStyle(
                      color: kMainColor,
                      fontSize: 13.sp,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
