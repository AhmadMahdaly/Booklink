import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteBookCubit extends Cubit<AppStates> {
  DeleteBookCubit() : super(AppInitialState());
  SupabaseClient supabase = Supabase.instance.client;

  Future<void> deleteBook(
    Map<String, dynamic> book,
  ) async {
    emit(AppLoadingState());
    try {
      final response = await Supabase.instance.client
          .from('books')
          .select('cover_image_url')
          .eq('id', book['id'].toString())
          .single();

      final oldPhotoUrl = response['cover_image_url'] as String;
      final oldFileName = oldPhotoUrl.split('/').last;
      await Supabase.instance.client.storage
          .from('book_covers')
          .remove([oldFileName]);

      final responsed = await Supabase.instance.client
          .from('books')
          .select('cover_book_url2')
          .eq('id', book['id'].toString())
          .single();
      final oldPhotoUrlI = responsed['cover_book_url2'] as String;
      final oldFileNameI = oldPhotoUrlI.split('/').last;

      await Supabase.instance.client.storage
          .from('book_covers')
          .remove([oldFileNameI]);
      await Supabase.instance.client.from('conversations').delete().eq(
            'book_id',
            book['id'].toString(),
          );

      await Supabase.instance.client.from('books').delete().eq(
            'id',
            book['id'].toString(),
          );
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
