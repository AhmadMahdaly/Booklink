import 'package:biblio/utils/components/custom_textformfield.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderBookBody extends StatelessWidget {
  const OrderBookBody({
    required TextEditingController messageController,
    super.key,
  }) : _messageController = messageController;

  final TextEditingController _messageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: ListView(
        children: [
          Text(
            'WriteRequest'.tr(),
            style: TextStyle(
              color: kTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 1.50.sp,
            ),
          ),
          const H(h: 20),
          CustomTextformfield(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required data'.tr();
              }
              return null;
            },
            maxLines: 100,
            contentPadding: EdgeInsets.only(
              bottom: 170.sp,
              right: 12.sp,
              left: 12.sp,
              top: 12.sp,
            ),
            controller: _messageController,
          ),
        ],
      ),
    );
  }
}
