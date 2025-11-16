import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_widgets/border_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferTypesWidget extends StatelessWidget {
  const OfferTypesWidget({required this.book, super.key});
  final Map<String, dynamic> book;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (book['offer_type'].toString() == 'للبيع')
          Container(
            width: 100,
            height: 26,
            margin: EdgeInsets.symmetric(horizontal: 16.sp),
            decoration: ShapeDecoration(
              color: const Color(0xFFF0F6FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.sp),
                  topRight: Radius.circular(12.sp),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5.sp,
              children: [
                Icon(
                  Icons.sell,
                  size: 12.sp,
                ),
                Text(
                  book['offer_type'].toString(),
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.30,
                  ),
                ),
              ],
            ),
          )
        else
          book['offer_type'] == 'للتبرع'
              ? Container(
                  width: 100,
                  height: 26,
                  margin: EdgeInsets.symmetric(horizontal: 16.sp),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE4FFF3),
                    shape: RoundedRectangleBorder(
                      borderRadius: borderRadius(),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5.sp,
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        size: 12.sp,
                        color: const Color(0xFF4DC591),
                      ),
                      Text(
                        book['offer_type'].toString(),
                        style: TextStyle(
                          color: const Color(0xFF4DC591),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.30,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: 100,
                  height: 26,
                  margin: EdgeInsets.symmetric(horizontal: 16.sp),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF0F6FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: borderRadius(),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5.sp,
                    children: [
                      Icon(
                        Icons.sync_outlined,
                        size: 12.sp,
                      ),
                      Text(
                        book['offer_type'].toString(),
                        style: TextStyle(
                          color: kMainColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.30,
                        ),
                      ),
                    ],
                  ),
                ),
      ],
    );
  }
}
