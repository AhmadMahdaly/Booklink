import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Get book photo
Future<String?> getBooksPhoto(
  BuildContext context,
  int id,
) async {
  final supabase = Supabase.instance.client;
  try {
    /// استرجاع رابط الصورة من قاعدة البيانات
    final response = await supabase
        .from('books')
        .select('cover_image_url')
        .eq('id', id)
        .single();

    /// استخراج رابط الصورة
    final photoUrl = response['cover_image_url'] as String;
    return photoUrl;
  } catch (e) {
    return null;
  }
}

Future<String?> getBooksPhotoI(
  BuildContext context,
  int id,
) async {
  final supabase = Supabase.instance.client;
  try {
    /// استرجاع رابط الصورة من قاعدة البيانات
    final response = await supabase
        .from('books')
        .select('cover_book_url2')
        .eq('id', id)
        .single();

    /// استخراج رابط الصورة
    final photoUrl = response['cover_book_url2'] as String;
    return photoUrl;
  } catch (e) {
    showSnackBar(
      context,
      'هناك صعوبة في الوصول لصورة الكتاب، يمكنك التواصل مع الدعم الفني.',
    );
  }
  return null;
}
