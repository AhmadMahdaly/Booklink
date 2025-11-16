import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/screens/book/add_book_page/add_book.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.sp),
          ),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.symmetric(horizontal: 16.sp),
          width: MediaQuery.of(context).size.width,
          height: 140.sp,
          child: Image.asset(
            'assets/images/home_banner.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Container(
          margin: EdgeInsets.all(10.sp),
          child: Column(
            spacing: 6.sp,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ReadAndChange'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  5.horizontalSpace,
                  SvgPicture.asset(
                    'assets/svg/logo.svg',
                    height: 24.sp,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              Align(
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  isRepeatingAnimation: false,
                  displayFullTextOnTap: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'BannerMsg'.tr(),
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                      ),
                      speed: const Duration(milliseconds: 50),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const AddBook();
                        },
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 8.sp),
                    width: 131,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    child: Text(
                      'Start now'.tr(),
                      style: TextStyle(
                        color: kMainColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
