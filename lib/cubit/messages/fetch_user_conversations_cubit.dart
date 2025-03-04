import 'package:biblio/cubit/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchUserConversationsCubit extends Cubit<AppStates> {
  FetchUserConversationsCubit() : super(AppInitialState());

  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> sendConversations = [];
  List<Map<String, dynamic>> receiverConversations = [];
  Future<void> fetchSendConversations() async {
    emit(AppLoadingState());
    try {
      if (Supabase.instance.client.auth.currentUser?.id == null) {
      } else {
        final user = Supabase.instance.client.auth.currentUser!.id;

        final response = await supabase
            .from('conversation_participants')
            .select(
              'conversation_id,receiver_id, user_id, book_image, title_book, receiver, sender,is_read_in, is_read_out, conversations(created_at)',
            )
            .eq('user_id', user)
            .order('conversation_id', ascending: false);
        sendConversations = List<Map<String, dynamic>>.from(response);
      }
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }

  Future<void> fetchReceiverConversations() async {
    emit(AppLoadingState());
    try {
      if (Supabase.instance.client.auth.currentUser?.id == null) {
      } else {
        final user = Supabase.instance.client.auth.currentUser!.id;

        final response = await supabase
            .from('conversation_participants')
            .select(
              'conversation_id, user_id, receiver_id, is_read_in, is_read_out, book_image, title_book, receiver, sender, conversations(created_at)',
            )
            .eq('receiver_id', user)
            .order('conversation_id', ascending: false);
        receiverConversations = List<Map<String, dynamic>>.from(response);
      }
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
