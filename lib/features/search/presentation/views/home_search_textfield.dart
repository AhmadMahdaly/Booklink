import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/features/search/presentation/views/search_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeSearchTextfield extends StatelessWidget {
  const HomeSearchTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookSearchScreen()),
      ),
      readOnly: true,
      cursorColor: kMainColor,
      decoration: InputDecoration(
        hintText: 'SearchHere'.tr(),
        hintStyle: TextStyle(
          color: const Color(0xFF969697),
          fontSize: 12.sp,
          fontWeight: FontWeight.w300,
        ),
        prefixIcon: Container(
          margin: EdgeInsets.all(8.sp),
          padding: EdgeInsets.all(5.sp),
          width: 32.sp,
          height: 32.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              15.sp,
            ),
          ),
          child: SvgPicture.asset(
            'assets/svg/Magnifier.svg',
            colorFilter: const ColorFilter.mode(
              Color(0xFF213555),
              BlendMode.srcIn,
            ),
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFECECEC),
        contentPadding: EdgeInsets.all(5.sp),
        border: border(),
        enabledBorder: border(),
        focusedBorder: border(),
      ),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color(
          0xFFF4F4F4,
        ),
      ),
      borderRadius: BorderRadius.circular(12.sp),
    );
  }
}
