import 'package:biblio/core/shared_widgets/show_snackbar.dart';
import 'package:biblio/screens/no_network_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void errorMessage(String message, BuildContext context) {
  try {
    if (message.contains('Connection terminated during handshake') ||
        message.contains('Connection reset by peer') ||
        message.contains('Connection closed before full header was received') ||
        message.contains(
          'ClientException with SocketException: Failed host lookup',
        ) ||
        message.contains(
          'No address associated with hostname',
        ) ||
        message.contains('Connection terminated during handshake') ||
        message.contains(
          'Access token is expired and refreshing failed, aborting api request',
        )) {
      showSnackBar(context, 'NetworkError'.tr());
    } else if (message
        .contains('Access token is expired and refreshing failed')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NoNetworkScreen(),
        ),
      );
    } else if (message
        .contains('JSON object requested, multiple (or no) rows returned')) {
    } else if (message.contains(
      'duplicate key value violates unique constraint "users_id_key"',
    )) {
      showSnackBar(
        context,
        'credentialsError'.tr(),
      );
    } else if (message.contains('Invalid login credentials')) {
      showSnackBar(
        context,
        'credentialsError2'.tr(),
      );
    } else if (message.contains('Email is not valid')) {
      showSnackBar(
        context,
        'WrongEmail'.tr(),
      );
    } else if (message.contains('Password is not valid')) {
      showSnackBar(
        context,
        'WrongPassword'.tr(),
      );
    } else if (message.contains('User not found')) {
      showSnackBar(
        context,
        'UserNotFound'.tr(),
      );
    } else if (message.contains('Password should be at least 6 characters')) {
      showSnackBar(
        context,
        'WeakPassword'.tr(),
      );
    }
  } catch (e) {
    showSnackBar(context, 'GeneralError'.tr());
  }
}
