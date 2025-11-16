import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/services/error_message.dart';
import 'package:biblio/core/services/setup_fcm.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/features/auth/presentation/controllers/auth_cubit.dart';
import 'package:biblio/features/intro/onboard/onboard_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return BlocConsumer<AuthCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
        if (state is AppSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            OnboardScreen.id,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return TextButton(
          onPressed: () async {
            try {
              await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: kLightBlue,
                  content: Text(
                    'LogOut?'.tr(),
                    style: const TextStyle(
                      color: kMainColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  actions: [
                    ///
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(
                        false,
                      ),
                      child: Text(
                        'Cancel'.tr(),
                        style: const TextStyle(
                          color: kMainColor,
                        ),
                      ),
                    ),

                    ///
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(
                          context,
                        ).pop(
                          true,
                        );
                        await cubit.signOut();
                        await deleteTokenToSupabase();
                      },
                      child: Text(
                        'Sign out'.tr(),
                        style: const TextStyle(
                          color: kMainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } catch (_) {}
          },
          child: Text(
            'Sign out'.tr(),
            style: TextStyle(
              color: const Color(0xFFEA1C25),
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      },
    );
  }
}
