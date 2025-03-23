import 'package:biblio/cubit/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteButtonCubit extends Cubit<AppStates> {
  FavoriteButtonCubit() : super(AppInitialState());
  bool isFavorite = false;
  SupabaseClient supabase = Supabase.instance.client;
  final user = Supabase.instance.client.auth.currentUser;

  Future<void> loadFavoriteState({
    required String bookId,
  }) async {
    isFavorite = false;
    emit(AppLoadingState());
    try {
      if (user != null) {
        final userId = user!.id;
        final response = await supabase
            .from('favorites')
            .select()
            .eq('user_id', userId)
            .eq('book_id', bookId)
            .maybeSingle();
        if (response != null) {
          isFavorite = true;
        }
      }
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }

  Future<void> toggleFavorite({
    required String bookId,
  }) async {
    emit(AppLoadingState());
    try {
      final userId = supabase.auth.currentUser!.id;
      if (isFavorite) {
        // إزالة من المفضلة
        await supabase
            .from('favorites')
            .delete()
            .eq('user_id', userId)
            .eq('book_id', bookId);
      } else {
        // إضافة إلى المفضلة
        await supabase.from('favorites').insert({
          'user_id': userId,
          'book_id': bookId,
        });
      }

      isFavorite = !isFavorite;
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
