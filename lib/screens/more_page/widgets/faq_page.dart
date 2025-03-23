// الأسئلة الشائعة (FAQ) لتطبيق Biblio

import 'package:biblio/utils/components/leading_icon.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqList = <Map<String, String>>[
      {
        'question': 'Q1'.tr(),
        'answer': 'Ans1'.tr(),
      },
      {
        'question': 'Q2'.tr(),
        'answer': 'Ans2'.tr(),
      },
      {
        'question': 'Q3'.tr(),
        'answer': 'Ans3'.tr(),
      },
      {
        'question': 'Q4'.tr(),
        'answer': 'Ans4'.tr(),
      },
      {
        'question': 'Q5'.tr(),
        'answer': 'Ans5'.tr(),
      },
      {
        'question': 'Q6'.tr(),
        'answer': 'Ans6'.tr(),
      },
      {
        'question': 'Q7'.tr(),
        'answer': 'Ans7'.tr(),
      },
      {
        'question': 'Q8'.tr(),
        'answer': 'Ans8'.tr(),
      },
      {
        'question': 'Q9'.tr(),
        'answer': 'Ans9'.tr(),
      },
      {
        'question': 'Q10'.tr(),
        'answer': 'Ans10'.tr(),
      },
      {
        'question': 'Q11'.tr(),
        'answer': 'Ans11'.tr(),
      },
      {
        'question': 'Q12'.tr(),
        'answer': 'Ans12'.tr(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const LeadingIcon(),
        title: Text(
          'FAQ'.tr(),
          style: TextStyle(
            color: kTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            height: 1.sp,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 16.sp,
        ),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            collapsedIconColor: kMainColor,
            iconColor: kMainColor,
            title: Text(
              faqList[index]['question']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: kMainColor,
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5.sp,
                  horizontal: 16.sp,
                ),
                child: Text(
                  faqList[index]['answer']!,
                  style: const TextStyle(
                    color: kTextColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
