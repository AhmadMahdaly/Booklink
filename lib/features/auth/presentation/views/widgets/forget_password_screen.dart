import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/services/error_message.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:biblio/core/shared_widgets/custom_button.dart';
import 'package:biblio/core/shared_widgets/custom_textformfield.dart';
import 'package:biblio/features/user_page/presentation/views/request_otp_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestOtpCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<RequestOtpCubit>();
        return Scaffold(
          body: state is AppLoadingState
              ? const LoadingWidget()
              : SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.sp),
                      child: Column(
                        spacing: 16.sp,
                        children: [
                          /// Header
                          90.verticalSpace,
                          SvgPicture.asset(
                            'assets/svg/logo.svg',
                            colorFilter: const ColorFilter.mode(
                              kMainColor,
                              BlendMode.srcIn,
                            ),
                            width: 115.sp,
                          ),
                          Text(
                            'ForgotPassword?'.tr(),
                            style: TextStyle(
                              color: kMainColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'EnterYourEmail'.tr(),
                            style: TextStyle(
                              color: kTextShadowColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          16.verticalSpace,

                          /// Email
                          Row(
                            children: [
                              Text(
                                'Email'.tr(),
                                style: TextStyle(
                                  color: kHeader1Color,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          CustomTextformfield(
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            controller: _emailController,
                            text: 'Email'.tr(),
                          ),
                          10.verticalSpace,

                          /// Button
                          CustomButton(
                            // isActive: false,
                            onTap: () {
                              final email = _emailController.text;
                              cubit.requestOtp(email, context);
                            },
                            text: 'Send code'.tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
