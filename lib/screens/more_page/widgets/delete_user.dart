import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/user/delete_user_cubit.dart';
import 'package:biblio/screens/onboard/onboard_screen.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteUser extends StatelessWidget {
  const DeleteUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteUserCubit, AppStates>(
      listener: (context, state) {
        if (state is AppSuccessState) {
          showSnackBar(
            context,
            'AccountDeletedMsg'.tr(),
          );

          /// توجيه المستخدم إلى صفحة البداية
          Navigator.pushNamedAndRemoveUntil(
            context,
            OnboardScreen.id,
            (route) => false,
          );
        }
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<DeleteUserCubit>();
        return Row(
          children: [
            TextButton(
              onPressed: () async {
                await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm account deletion'.tr()),
                    content: Text('AccountDeletedMsg1'.tr()),
                    actions: [
                      ///
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'.tr()),
                      ),

                      ///
                      ElevatedButton(
                        onPressed: () async {
                          await cubit.deleteAccount();
                        },
                        child: Text('DeleteAccount'.tr()),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'DeleteAccount'.tr(),
                style: TextStyle(
                  color: const Color(0xFFEA1C25),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
