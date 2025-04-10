import 'package:biblio/services/get_time.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToUserMessage extends StatelessWidget {
  const ToUserMessage({
    required this.content,
    required this.timestamp,
    required this.msgId,
    super.key,
  });
  final String msgId;
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
          backgroundColor: Colors.white,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          showTrailingIcon: false,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(8.sp),
              margin: EdgeInsets.symmetric(
                horizontal: 16.sp,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.sp),
                  bottomLeft: Radius.circular(12.sp),
                  bottomRight: Radius.circular(12.sp),
                ),
                color: kLightBlue,
              ),
              child: Text(
                content,
                style: TextStyle(
                  color: kTextColor,
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
