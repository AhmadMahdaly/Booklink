import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchLocatedBooksCubit extends Cubit<AppStates> {
  FetchLocatedBooksCubit() : super(AppInitialState());
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> books = [];

  Future<void> fetchLocatedBooks() async {
    emit(AppLoadingState());
    try {
      String? user;
      if (Supabase.instance.client.auth.currentUser?.id == null) {
        user = null;
      } else {
        user = Supabase.instance.client.auth.currentUser?.id;
      }
      if (user != null) {
        final responsed =
            await supabase.from('users').select('city').eq('id', user).single();
        final city = responsed['city'] as String;
        final response = await supabase
            .from('books')
            .select('*')
            .eq('city', city)
            .order('created_at', ascending: false);

        books = List<Map<String, dynamic>>.from(response);
        emit(AppSuccessState());
      }
      emit(AppSuccessState());
    } catch (e) {
      if (!isClosed) {
        emit(AppErrorState(e.toString()));
      }
    }
  }
}
