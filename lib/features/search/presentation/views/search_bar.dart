import 'dart:async';

import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/services/error_message.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/custom_textformfield.dart';
import 'package:biblio/features/search/presentation/controllers/search_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  Timer? debounce;
  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<SearchCubit>();
        return TextField(
          onChanged: cubit.searchBooks,
          controller: searchController,
          autofocus: true,
          cursorWidth: 0.5.sp,
          cursorColor: kMainColor,
          decoration: InputDecoration(
            hintText: 'SearchBy'.tr(),
            hintStyle: TextStyle(
              color: const Color(0xFF969697),
              fontSize: 12.sp,
              fontWeight: FontWeight.w300,
            ),
            filled: true,
            fillColor: const Color(0xFFECECEC),
            contentPadding: EdgeInsets.symmetric(horizontal: 20.sp),
            border: border(),
            enabledBorder: border(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.sp),
              borderSide: const BorderSide(
                color: kMainColor,
              ),
            ),
            suffixIcon: InkWell(
              onTap: () => cubit.searchBooks(searchController.text),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.sp),
                padding: EdgeInsets.symmetric(horizontal: 5.sp),
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
            ),
          ),
        );
      },
    );
  }
}
