import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/show_snackbar.dart';
import 'package:biblio/features/auth/presentation/views/widgets/verification_code_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestOtpCubit extends Cubit<AppStates> {
  RequestOtpCubit() : super(AppInitialState());
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> requestOtp(String email, BuildContext context) async {
    emit(AppLoadingState());

    try {
      if (email.isEmpty) {
        showSnackBar(context, 'EnterYourEmail'.tr());
        return;
      }
      await supabase.auth.signInWithOtp(email: email);
      showSnackBar(
        context,
        'SentConfirmationCode'.tr(),
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationCodePage(
            email: email,
          ),
        ),
      );
      emit(AppSuccessState());
    } catch (generalError) {
      emit(AppErrorState(generalError.toString()));
    }
  }
}
