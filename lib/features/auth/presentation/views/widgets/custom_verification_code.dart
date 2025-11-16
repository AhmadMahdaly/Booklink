import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_widgets/show_snackbar.dart';
import 'package:biblio/features/auth/presentation/views/widgets/new_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomVerificationCode extends StatefulWidget {
  const CustomVerificationCode({required this.email, super.key});
  final String email;
  @override
  State<CustomVerificationCode> createState() => _CustomVerificationCodeState();
}

class _CustomVerificationCodeState extends State<CustomVerificationCode> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _onEditing = true;
  String? code;

  Future<void> confirmReset(String otp) async {
    try {
      await supabase.auth.verifyOTP(
        email: widget.email,
        token: otp,
        type: OtpType.recovery,
      );
    } on AuthException catch (authError) {
      showSnackBar(context, authError.message);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return VerificationCode(
      length: 6,
      margin: EdgeInsets.symmetric(horizontal: 2.sp),
      textStyle: TextStyle(
        fontSize: 20.sp,
        color: kMainColor,
      ),
      underlineColor: kBorderColor,
      cursorColor: kMainColor,
      onCompleted: (String value) {
        try {
          setState(() {
            code = value;
            confirmReset(code!);
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const NewPasswordPage();
              },
            ),
          );
        } catch (e) {
          showSnackBar(context, e.toString());
        }
      },
      onEditing: (bool value) {
        setState(() {
          _onEditing = value;
        });
        if (!_onEditing) FocusScope.of(context).unfocus();
      },
    );
  }
}
