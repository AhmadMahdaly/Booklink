import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_widgets/custom_button.dart';
import 'package:biblio/screens/book/add_book_page/add_book.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyLibrary extends StatelessWidget {
  const EmptyLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/Reading glasses-cuate.svg',
            height: 80.sp,
          ),
          Text(
            'Empty library'.tr(),
            style: TextStyle(
              color: kTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          24.verticalSpace,
          CustomBorderBotton(
            padding: 56,
            text: 'AddBook'.tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBook(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
