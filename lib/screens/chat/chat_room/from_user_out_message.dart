import 'package:biblio/services/get_time.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FromUserOutMessage extends StatelessWidget {
  const FromUserOutMessage({
    required this.content,
    required this.timestamp,
    super.key,
  });
  final String content;
  final String timestamp;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // إزالة الخطوط
      ),
      child: SizedBox(
        child: ExpansionTile(
          backgroundColor: kLightBlue,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          showTrailingIcon: false,
          title: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.all(8.sp),
              margin: EdgeInsets.symmetric(
                horizontal: 16.sp,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.sp),
                  bottomLeft: Radius.circular(12.sp),
                  bottomRight: Radius.circular(12.sp),
                ),
                color: kMainColor,
              ),
              child: Text(
                content,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          children: [
            Text(
              getTimeDifference(timestamp, context),
              style: TextStyle(
                color: kTextColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
