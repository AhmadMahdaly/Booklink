import 'package:biblio/cubit/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SendMessagesCubit extends Cubit<AppStates> {
  SendMessagesCubit() : super(AppInitialState());
  final supabase = Supabase.instance.client;

  /// Send Message
  Future<void> sendIncomeMessage({
    required String conversationId,
    required String content,
  }) async {
    emit(AppLoadingState());
    try {
      final userId = supabase.auth.currentUser?.id;
      final otherIdResponse = await supabase
          .from('conversation_participants')
          .select('receiver_id, user_id')
          .eq('conversation_id', conversationId)
          .single();
      final otherId = otherIdResponse['receiver_id'].toString() == userId
          ? otherIdResponse['user_id'].toString()
          : otherIdResponse['receiver_id'].toString();

      await supabase.from('messages').insert({
        'conversation_id': conversationId,
        'user_id': userId,
        'content': content,
        'other_id': otherId,
      });
      await supabase
          .from('conversation_participants')
          .update({'is_read_out': false})
          .eq('conversation_id', conversationId)
          .eq('user_id', userId!);
      await supabase
          .from('conversation_participants')
          .update({'is_read_in': false})
          .eq('conversation_id', conversationId)
          .eq('receiver_id', userId);
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }

  Future<void> sendOutgoingMessage({
    required String conversationId,
    required String content,
  }) async {
    emit(AppLoadingState());
    try {
      final userId = supabase.auth.currentUser?.id;
      final otherIdResponse = await supabase
          .from('conversation_participants')
          .select('receiver_id, user_id')
          .eq('conversation_id', conversationId)
          .single();
      final otherId = otherIdResponse['receiver_id'].toString() == userId
          ? otherIdResponse['user_id'].toString()
          : otherIdResponse['receiver_id'].toString();
      await supabase.from('messages').insert({
        'conversation_id': conversationId,
        'user_id': userId,
        'content': content,
        'other_id': otherId,
      });
      await supabase
          .from('conversation_participants')
          .update({'is_read_out': false})
          .eq('conversation_id', conversationId)
          .eq('user_id', userId!);
      await supabase
          .from('conversation_participants')
          .update({'is_read_in': false})
          .eq('conversation_id', conversationId)
          .eq('receiver_id', userId);
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
// widget.conversation['user_id'] == user &&
// widget.conversation['is_read_in'] == false ||

// widget.conversation['receiver_id'] == user &&
// widget.conversation['is_read_out'] == false
