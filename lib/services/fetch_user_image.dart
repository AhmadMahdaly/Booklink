import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///
/// Get user photo
Future<String?> getUserPhoto(BuildContext context) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) {
    showSnackBar(context, 'يوجد صعوبة في الوصول للمستخدم المُسجل.');
    return null;
  }
  try {
    /// استرجاع رابط الصورة من قاعدة البيانات
    final response = await supabase
        .from('users')

        /// تحديد الحقل المطلوب
        .select('image')
        .eq('id', user.id)

        /// جلب سجل واحد فقط
        .single();

    final photoUrl = response['image'] as String;

    /// استخراج رابط الصورة
    return photoUrl;
  } catch (e) {
    showSnackBar(context, 'لم يتم العثور على الصورة للمستخدم.');
  }
  return null;
}
