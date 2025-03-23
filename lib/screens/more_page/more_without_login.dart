import 'package:biblio/screens/more_page/widgets/category_for_more.dart';
import 'package:biblio/screens/more_page/widgets/faq_page.dart';
import 'package:biblio/screens/more_page/widgets/terms_and_conditions_page.dart';
import 'package:biblio/screens/onboard/onboard_screen.dart';
import 'package:biblio/utils/components/border_radius.dart';
import 'package:biblio/utils/components/custom_button.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreWithoutLogin extends StatelessWidget {
  const MoreWithoutLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          /// Personal card
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(16.sp),
            width: MediaQuery.of(context).size.width,
            height: 98,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: borderRadius(),
            ),
            child: CustomBorderBotton(
              text: 'Login'.tr(),
              onTap: () {
                Navigator.pushReplacementNamed(context, OnboardScreen.id);
              },
            ),
          ),

          CategoryForMore(
            text: 'FAQ'.tr(),
            icon: Icons.live_help_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const FAQPage();
                  },
                ),
              );
            },
          ),

          const H(h: 12),

          CategoryForMore(
            text: 'TermsAndConditions'.tr(),
            icon: Icons.text_snippet_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const TermsAndConditionsPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
