import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/cubit/messages/fetch_messages_cubit.dart';
import 'package:biblio/services/get_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FromUserInMessage extends StatelessWidget {
  const FromUserInMessage({
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
      child: InkWell(
        onLongPress: () => showDialog<String>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: kScaffoldBackgroundColor,
              title: Text(
                'هل تريد حذف الرسالة؟',
                style: TextStyle(
                  color: kMainColor,
                  fontSize: 15.sp,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(fontSize: 13.sp, color: kTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<FetchMessagesCubit>(context)
                        .deleteMessage(messageId: msgId);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'موافق',
                    style: TextStyle(fontSize: 13.sp, color: kHeader1Color),
                  ),
                ),
              ],
            );
          },
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
      ),
    );
  }
}
