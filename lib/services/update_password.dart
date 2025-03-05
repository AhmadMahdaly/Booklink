import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

Future<void> updatePassword(String newPassword, BuildContext context) async {
  try {
    await supabase.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
  } catch (e) {
    showSnackBar(
      context,
      'حدث خطأ أثناء تغيير كلمة المرور، يمكنك التواصل مع الدعم الفني.',
    );
  }
}
