import 'package:biblio/cubit/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaveUserLocationCubit extends Cubit<AppStates> {
  SaveUserLocationCubit() : super(AppInitialState());
  String? selectedCountry;
  String? selectedCity;
  Future<void> saveUserData() async {
    emit(AppLoadingState());
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user != null) {
        final userId = user.id;
        await supabase.from('users').update({
          'country': selectedCountry,
          'city': selectedCity,
        }).eq('id', userId);
        await supabase.from('books').update({
          'country': selectedCountry,
          'city': selectedCity,
        }).eq('user_id', userId);
      }

      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
