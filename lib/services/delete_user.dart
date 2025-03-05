import 'package:biblio/screens/onboard/onboard_screen.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteUser extends StatefulWidget {
  const DeleteUser({super.key});

  @override
  State<DeleteUser> createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  bool _isDeleting = false;

  Future<void> deleteAccount(BuildContext context) async {
    setState(() {
      _isDeleting = true;
    });
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        // throw Exception('لم يتم تسجيل الدخول.');
      }
      // حذف الحساب من Supabase Auth
      final supabase = SupabaseClient(
        dotenv.env['SUPABASE_URL'] ?? '', // رابط المشروع
        dotenv.env['SUPABASE_ADMIN'] ?? '', // مفتاح الخدمة
      );

      await supabase.auth.admin.deleteUser(user!.id);

      // حذف البيانات المرتبطة بالمستخدم من قاعدة البيانات

      final deleteResponse =
          await supabase.from('users').delete().eq('id', user.id);

      // ignore: avoid_dynamic_calls
      if (deleteResponse.error != null) {
        throw Exception(
            // ignore: avoid_dynamic_calls
            // 'حدث خطأ أثناء حذف بيانات المستخدم: ${deleteResponse.error!.message}',
            );
      }

      await Future.delayed(
        const Duration(seconds: 2),
      ); // محاكاة التأخير

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف الحساب بنجاح!'),
          ),
        );

        /// توجيه المستخدم إلى صفحة البداية
        await Navigator.pushNamedAndRemoveUntil(
          context,
          OnboardScreen.id,
          (route) => false,
        );
      }
    } catch (e) {
      // showSnackBar(context, 'خطأ $e');
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
      if (mounted) {
        // await Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   OnboardScreen.id,
        //   (route) => false,
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isDeleting
        ? const AppIndicator()
        :

        /// Delete Account
        Row(
            children: [
              TextButton(
                onPressed: () async {
                  // ignore: inference_failure_on_function_invocation
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('تأكيد حذف الحساب'),
                      content: const Text(
                        'هل أنت متأكد أنك تريد حذف حسابك؟\n ستختفي كل بياناتك ومعلوماتك بمجرد قبولك بحذف الحساب.',
                      ),
                      actions: [
                        ///
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('إلغاء'),
                        ),

                        ///
                        ElevatedButton(
                          onPressed: () async {
                            await deleteAccount(context);
                          },
                          child: const Text('حذف الحساب'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'حذف الحساب',
                  style: TextStyle(
                    color: const Color(0xFFEA1C25),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          );
  }
}
