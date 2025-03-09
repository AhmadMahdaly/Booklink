import 'package:biblio/screens/home_page/widgets/no_located_books.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:biblio/utils/components/login_user_not_found.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignToSeeNewBooks extends StatelessWidget {
  const SignToSeeNewBooks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.sp,
      children: [
        const H(h: 16),
        Text(
          'قم بتسجيل الدخول لرؤية الكتب المعروضة في منطقتك:',
          style: TextStyle(
            color: kTextColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        const LoginUserNotFound(),
        const TryToDiscoverCategory(),
      ],
    );
  }
}
