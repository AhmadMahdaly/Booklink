import 'package:biblio/screens/no_network_screen.dart';
import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:flutter/material.dart';

void errorMessage(String message, BuildContext context) {
  try {
    if (message.contains('Connection terminated during handshake')) {
      showSnackBar(context, 'قد تكون هناك مشكلة في الإتصال');
    } else if (message.contains('Connection reset by peer')) {
      showSnackBar(context, 'قد تكون هناك مشكلة في الإتصال');
    } else if (message
        .contains('Connection closed before full header was received')) {
      showSnackBar(context, 'قد تكون هناك مشكلة في الإتصال');
    } else if (message.contains(
      'ClientException with SocketException: Failed host lookup',
    )) {
      showSnackBar(context, 'قد تكون هناك مشكلة في الإتصال');
    } else if (message.contains(
      'No address associated with hostname',
    )) {
      showSnackBar(context, 'قد تكون هناك مشكلة في الإتصال');
    } else if (message.contains('Connection terminated during handshake')) {
      showSnackBar(context, 'قد تكون هناك مشكلة في الإتصال');
    } else if (message.contains(
      'Access token is expired and refreshing failed, aborting api request',
    )) {
      showSnackBar(context, 'قد تكون هناك مشكلة في الإتصال');
    } else if (message
        .contains('Access token is expired and refreshing failed')) {
      // showSnackBar(context, 'قد تكون هناك مشكلة في الإتصال');
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
        'هذا الحساب مسجل بالفعل أو أن البيانات غير صحيحة',
      );
    } else if (message.contains('Invalid login credentials')) {
      showSnackBar(
        context,
        'بيانات تسجيل الدخول غير صحيحة',
      );
    } else if (message.contains('Email is not valid')) {
      showSnackBar(
        context,
        'البريد الإلكتروني غير صالح',
      );
    } else if (message.contains('Password is not valid')) {
      showSnackBar(
        context,
        'كلمة المرور غير صالحة',
      );
    } else if (message.contains('User not found')) {
      showSnackBar(
        context,
        'المستخدم غير موجود',
      );
    } else if (message.contains('Password should be at least 6 characters')) {
      showSnackBar(
        context,
        'كلمة المرور ضعيفة',
      );
    }
  } catch (e) {
    showSnackBar(context, 'حدث خطأ، يمكنك التواصل مع الدعم الفني');
  }
}
