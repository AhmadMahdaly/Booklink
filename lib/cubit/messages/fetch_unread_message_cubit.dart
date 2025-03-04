import 'package:biblio/cubit/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchUnreadMessageCubit extends Cubit<AppStates> {
  FetchUnreadMessageCubit() : super(AppInitialState());
  final supabase = Supabase.instance.client;

  int notificationCount = 0;
  Future<void> fetchUnreadMessages({
    required String otherId,
  }) async {
    emit(AppLoadingState());
    try {
      String? user;
      if (Supabase.instance.client.auth.currentUser?.id == null) {
        user = null;
      } else {
        user = Supabase.instance.client.auth.currentUser?.id;
      }
      if (user != null) {
        final response = await supabase
            .from('messages')
            .select('content')
            .eq('is_read', false)
            .eq('other_id', user);
        final messages = List<Map<String, dynamic>>.from(response);
        notificationCount = messages.length;
      }
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
