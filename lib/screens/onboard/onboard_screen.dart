import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_widgets/custom_button.dart';
import 'package:biblio/screens/login/login_screen.dart';
import 'package:biblio/screens/login/register_page.dart';
import 'package:biblio/screens/onboard/widgets/sign_as_visitor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});
  static String id = 'OnboardScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

          /// Image header
          SizedBox(
        child: Image.asset(
          'assets/images/onboared_view_2.png',
          filterQuality: FilterQuality.high,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          16.verticalSpace,

          /// Title Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ReadAndChange'.tr(),
                style: TextStyle(
                  color: kMainColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              8.horizontalSpace,
              SvgPicture.asset(
                'assets/svg/logo.svg',
                height: 20.sp,
              ),
            ],
          ),
          8.verticalSpace,

          /// Desc text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Text(
              'IntBooklink'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kTextColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          16.verticalSpace,

          /// Login
          CustomButton(
            padding: 16,
            text: 'Login'.tr(),
            onTap: () {
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
          ),
          10.verticalSpace,

          /// Sign up
          CustomBorderBotton(
            padding: 16,
            text: 'NewAccount'.tr(),
            onTap: () {
              Navigator.pushReplacementNamed(context, RegisterScreen.id);
            },
          ),
          10.verticalSpace,

          /// To HomePage as visitor
          const SignAsVisitor(),
          34.verticalSpace,
        ],
      ),
    );
  }
}
