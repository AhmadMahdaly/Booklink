import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:flutter/material.dart';

void errorMessage(String message, BuildContext context) {
  if (message.contains('Connection terminated during handshake') ||
      message.contains('Connection reset by peer') ||
      message.contains('Connection closed before full header was received') ||
      message.contains('Connection terminated during handshake')) {
    showSnackBar(context, 'قد تكون هناك مشكلة في الإتصال');
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
}
