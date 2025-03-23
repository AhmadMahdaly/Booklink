import 'dart:async';

import 'package:biblio/cubit/user/request_otp_cubit.dart';
import 'package:biblio/screens/login/widgets/custom_verification_code.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({
    required this.email,
    super.key,
  });
  final String email;

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  bool isButtonDisabled = false; // لمنع الضغط على الزر أثناء العد التنازلي
  int timeLeft = 60; // المدة بالثواني
  Timer? timer;
  @override
  void initState() {
    super.initState();
    startTimer(); // بدء العد التنازلي
  }

  void startTimer() {
    setState(() {
      isButtonDisabled = true;
      timeLeft = 60;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          isButtonDisabled = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              spacing: 16.sp,
              children: [
                /// Header
                const H(h: 90),
                SvgPicture.asset(
                  'assets/svg/logo.svg',
                  colorFilter: const ColorFilter.mode(
                    kMainColor,
                    BlendMode.srcIn,
                  ),
                  width: 115.sp,
                ),
                Text(
                  'OTP code'.tr(),
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'OTP Msg'.tr(),
                  style: TextStyle(
                    color: kTextShadowColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const H(h: 16),
                CustomVerificationCode(
                  email: widget.email,
                ),
                const H(h: 10),

                /// Button
                Row(
                  children: [
                    Text(
                      "Didn't receive the code?".tr(),
                      style: TextStyle(
                        color: kHeader1Color,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      onTap: isButtonDisabled
                          ? null
                          : () async {
                              await context
                                  .read<RequestOtpCubit>()
                                  .requestOtp(widget.email, context);
                              startTimer();
                            },
                      child: isButtonDisabled
                          ? Text(
                              '⏳ ${'Wait'.tr()} $timeLeft ${'second'.tr()}',
                              style: TextStyle(
                                color: kMainColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Text(
                              ' ${'Send again'.tr()}',
                              style: TextStyle(
                                color: kMainColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: kMainColor,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
