import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchBookPageCubit extends Cubit<AppStates> {
  FetchBookPageCubit() : super(AppInitialState());
  final SupabaseClient supabase = Supabase.instance.client;
  String titleBook = '';
  String bookUser = '';
  String bookImage = '';
  String otherName = '';
  String uuser = '';

  Future<void> fetchBook(int bookId) async {
    emit(AppLoadingState());
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        ///
        return;
      }
      final titleResponse = await supabase
          .from('books')
          .select('title')
          .eq('id', bookId)
          .single();
      titleBook = titleResponse['title'].toString();
      final bookImageResponse = await supabase
          .from('books')
          .select('cover_image_url')
          .eq('id', bookId)
          .single();
      bookImage = bookImageResponse['cover_image_url'].toString();

      final userIdResponsed = await supabase
          .from('books')
          .select('user_id')
          .eq('id', bookId)
          .single();
      bookUser = userIdResponsed['user_id'].toString();

      final userNameResponse = await supabase
          .from('books')
          .select('user_name')
          .eq('id', bookId)
          .single();
      otherName = userNameResponse['user_name'].toString();

      final senderResponse = await supabase
          .from('users')
          .select('username')
          .eq('id', user.id)
          .single();

      uuser = senderResponse['username'].toString();
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
