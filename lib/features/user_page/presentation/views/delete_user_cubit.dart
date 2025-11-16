import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteUserCubit extends Cubit<AppStates> {
  DeleteUserCubit() : super(AppInitialState());

  final supabase = Supabase.instance.client;

  Future<void> deleteAccount() async {
    emit(AppLoadingState());
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        return;
      }
      // حذف الحساب من Supabase Auth
      final supabase = SupabaseClient(
        dotenv.env['SUPABASE_URL'] ?? '', // رابط المشروع
        dotenv.env['SUPABASE_ADMIN'] ?? '', // مفتاح الخدمة
      );

      await supabase.auth.admin.deleteUser(user.id);

      // حذف البيانات المرتبطة بالمستخدم من قاعدة البيانات
      await supabase.from('users').delete().eq('id', user.id);

      await Future.delayed(
        const Duration(seconds: 2),
      ); // محاكاة التأخير
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
