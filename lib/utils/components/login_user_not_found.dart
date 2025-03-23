import 'package:biblio/screens/onboard/onboard_screen.dart';
import 'package:biblio/utils/components/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoginUserNotFound extends StatelessWidget {
  const LoginUserNotFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomBorderBotton(
        padding: 24,
        text: 'Login'.tr(),
        onTap: () {
          Navigator.pushReplacementNamed(
            context,
            OnboardScreen.id,
          );
        },
      ),
    );
  }
}
