import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_widgets/login_user_not_found.dart';
import 'package:biblio/features/home_page/widgets/no_located_books.dart';
import 'package:easy_localization/easy_localization.dart';
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
        16.verticalSpace,
        Text(
          '${'Log in to see'.tr()}:',
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
