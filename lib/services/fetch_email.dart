import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;
String? userId;

/// ID المستخدم لتحديده بعد تسجيل الدخول

Future<void> fetchEmail(BuildContext context) async {
  try {
    /// الحصول على المستخدم الحالي
    final user = supabase.auth.currentUser;
    if (user == null) {
      showSnackBar(context, 'يوجد صعوبة في الوصول للمستخدم المُسجل.');
      throw Exception('المستخدم غير مسجل الدخول.');
    }

    /// استعلام لإحضار اسم المستخدم
    final response = await supabase

        /// اسم الجدول
        .from('users')

        /// العمود المطلوب
        .select('email')

        /// البحث باستخدام معرف المستخدم
        .eq('id', user.id)

        /// استرجاع صف واحد فقط
        .single();

    return response['email'];
  } catch (e) {
    showSnackBar(
      context,
      'حدث صعوبة في الحصول على البريد الإلكتروني المُسجل.. يمكنك التواصل مع الدعم الفني',
    );
  }
}
