import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/features/category/widgets/see_all.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoLocatedBooks extends StatelessWidget {
  const NoLocatedBooks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          spacing: 4.sp,
          children: [
            Text(
              'There is  no books'.tr(),
              style: TextStyle(
                color: kTextColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const TryToDiscoverCategory(),
          ],
        ),
      ),
    );
  }
}

class TryToDiscoverCategory extends StatelessWidget {
  const TryToDiscoverCategory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${'You can try exploring'.tr()} ',
          style: TextStyle(
            color: kTextColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const CategorySeeAll();
                },
              ),
            );
          },
          child: Text(
            'the different categories'.tr(),
            style: TextStyle(
              color: kTextColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: kMainColor,
            ),
          ),
        ),
        Text(
          ' ${'to find what suits you'.tr()}',
          style: TextStyle(
            color: kTextColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
