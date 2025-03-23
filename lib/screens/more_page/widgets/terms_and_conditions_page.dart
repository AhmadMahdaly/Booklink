// صفحة الشروط والأحكام لتطبيق Biblio

import 'package:biblio/utils/components/leading_icon.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final terms = <String>[
      'Term1',
      'Term2',
      'Term3',
      'Term4',
      'Term5',
      'Term6',
      'Term7',
      'Term8',
      'Term9',
      'Term10',
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const LeadingIcon(),
        title: Text(
          'TermsAndConditions'.tr(),
          style: TextStyle(
            color: kTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            height: 1.sp,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: terms.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.sp,
              vertical: 8.sp,
            ),
            child: Card(
              color: const Color(0xFFFCFCFC),
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Text(
                  terms[index],
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
