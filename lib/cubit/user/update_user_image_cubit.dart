import 'dart:io';

import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateUserImageCubit extends Cubit<AppStates> {
  UpdateUserImageCubit() : super(AppInitialState());
  final supabase = Supabase.instance.client;

  Future<void> uploadImage(
    File userImage,
  ) async {
    emit(AppLoadingState());
    try {
      if (userImage == null) {
        return;
      }

      /// رفع الصورة إلى Supabase Storage
      final fileName = DateTime.now().toIso8601String();
      await supabase.storage.from('user-photos').upload(
            fileName,
            userImage,
          );
      final imageUrl =
          supabase.storage.from('user-photos').getPublicUrl(fileName);

      /// حفظ رابط الصورة في جدول users
      final response = await supabase
          .from('users')
          .select('image')
          .eq('id', supabase.auth.currentUser!.id)
          .single();
      final oldPhotoUrl = response['image'] as String;
      final oldFileName = oldPhotoUrl.split('/').last;

      /// حذف الصورة القديمة
      await supabase.storage.from('user-photos').remove([oldFileName]);
      await supabase.from('users').update({
        'image': imageUrl,
      }).eq(
        'id',
        supabase.auth.currentUser!.id,
      );
      await supabase.from('books').update({
        'user_image': imageUrl,
      }).eq(
        'user_id',
        supabase.auth.currentUser!.id,
      );
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
