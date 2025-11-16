import 'package:biblio/features/more_page/more_with_login.dart';
import 'package:biblio/features/more_page/more_without_login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return user == null || user.isAnonymous
        ? const MoreWithoutLogin()
        : const MoreWithLogin();
  }
}
