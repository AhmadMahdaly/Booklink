import 'package:biblio/services/update_password.dart';
import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:flutter/material.dart';

Future<void> updateBook({
  required String bookId,
  required String title,
  required String description,
  required String author,
  required String category,
  required String condition,
  required String offerType,
  required int price,
  required BuildContext context,
}) async {
  try {
    await supabase.from('books').update({
      'price': price,
      'title': title,
      'author': author,
      'category': category,
      'description': description,
      'condition': condition,
      'offer_type': offerType,
    }).eq('id', bookId);

    showSnackBar(context, 'تم تعديل الكتاب.');
  } catch (e) {}
}
