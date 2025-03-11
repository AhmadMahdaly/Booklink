import 'package:biblio/cubit/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchUserDataCubit extends Cubit<AppStates> {
  FetchUserDataCubit() : super(AppInitialState());

  final supabase = Supabase.instance.client;

  String name = '';
  String email = '';
  Future<void> fetchUserData() async {
    emit(AppLoadingState());
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return;
      }

      final response = await supabase
          .from('users')
          .select('username')
          .eq('id', user.id)
          .single();
      name = response['username'] as String;

      final response1 = await supabase
          .from('users')
          .select('email')
          .eq('id', user.id)
          .single();
      email = response1['email'] as String;

      emit(AppSuccessState());
    } catch (e) {
      emit(
        AppErrorState(e.toString()),
      );
    }
  }

  Future<void> updateUserData({
    required String inName,
    required String inEmail,
    required String inPassword,
  }) async {
    emit(AppLoadingState());
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return;
      }
      var newName = inName;
      var newEmail = inEmail;
      final newPassword = inPassword;
      if (newName.isEmpty || newName == null) {
        final response = await supabase
            .from('users')
            .select('username')
            .eq('id', user.id)
            .single();
        newName = response['username'] as String;
      }
      if (newEmail.isEmpty || newEmail == null) {
        final response = await supabase
            .from('users')
            .select('email')
            .eq('id', user.id)
            .single();
        newEmail = response['email'] as String;
      }

      /// تحديث الاسم في قاعدة البيانات
      await supabase.from('users').update(
        {'username': newName},
      ).eq(
        'id',
        user.id,
      );
      await supabase.from('books').update({
        'user_name': newName,
      }).eq(
        'user_id',
        user.id,
      );
      if (newPassword.isEmpty || newPassword == null) {
      } else {
        await supabase.auth.updateUser(
          UserAttributes(
            email: newEmail,
          ),
        );
      }
      if (newPassword.isEmpty || newPassword == null) {
      } else {
        await supabase.auth.updateUser(
          UserAttributes(
            password: newPassword,
          ),
        );
      }
      emit(AppSuccessState());
    } catch (e) {
      emit(
        AppErrorState(e.toString()),
      );
    }
  }

  Future<void> fetchUserName() async {
    emit(AppLoadingState());
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return;
      }

      /// استعلام لإحضار اسم المستخدم
      final response = await supabase
          .from('users')

          /// اسم الجدول
          .select('username')

          /// العمود المطلوب
          .eq('id', user.id)

          /// البحث باستخدام معرف المستخدم
          .single();

      /// استرجاع صف واحد فقط
      emit(AppSuccessState());
      return response['username'];
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }

  Future<String?> getUserPhoto() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      return null;
    }
    try {
      emit(AppLoadingState());

      /// استرجاع رابط الصورة من قاعدة البيانات
      final response = await supabase
          .from('users')

          /// تحديد الحقل المطلوب
          .select('image')
          .eq('id', user.id)

          /// جلب سجل واحد فقط
          .single();

      final photoUrl = response['image'] as String;
      emit(AppSuccessState());

      /// استخراج رابط الصورة
      return photoUrl;
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
    return null;
  }
}
