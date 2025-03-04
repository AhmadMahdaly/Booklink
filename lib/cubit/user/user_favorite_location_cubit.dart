import 'package:biblio/cubit/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserFavoriteLocationCubit extends Cubit<AppStates> {
  UserFavoriteLocationCubit() : super(AppInitialState());
  final SupabaseClient supabase = Supabase.instance.client;
  String? favoriteLocation;
  String? urlLocation;
  Future<void> getUserFavoriteLocation({
    required String userId,
    required BuildContext context,
  }) async {
    emit(AppLoadingState());
    try {
      final response = await supabase
          .from('books')
          .select('fav_location')
          .eq('book_id', userId)
          .single();
      favoriteLocation = response['fav_location'].toString();

      final urlLocationResponse = await supabase
          .from('books')
          .select('location_url')
          .eq('user_id', userId)
          .single();
      urlLocation = urlLocationResponse['location_url'].toString();
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
