import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateUserFavoriteLocationCubit extends Cubit<AppStates> {
  UpdateUserFavoriteLocationCubit() : super(AppInitialState());
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> updateUserFavoriteLocation(
    String favoriteLocations,
    String url, {
    required String userId,
  }) async {
    emit(AppLoadingState());
    try {
      await supabase.from('books').update({
        'location_url': url,
        'fav_location': favoriteLocations,
      }).eq('user_id', userId);
      await supabase.from('users').update({
        'location_url': url,
        'fav_location': favoriteLocations,
      }).eq('id', userId);
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
