import 'package:biblio/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchMessagesCubit extends Cubit<AppStates> {
  FetchMessagesCubit() : super(AppInitialState());
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> messages = [];
  String name = '';
  int notificationCount = 0;
  Future<void> fetchUserName({
    required String userId,
  }) async {
    emit(AppLoadingState());
    try {
      final response1 =
          await supabase.from('users').select('username').eq('id', userId);
      name = response1.toString();
      emit(AppSuccessState());
    } catch (e) {
      if (!isClosed) {
        emit(AppErrorState(e.toString()));
      }
    }
  }

  /// fetch Messages
  Future<void> fetchMessages({
    required String conversationId,
  }) async {
    emit(AppLoadingState());
    try {
      final response = await supabase
          .from('messages')
          .select('content, created_at, user_id, other_id, id')
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false);
      messages = List<Map<String, dynamic>>.from(response);

      emit(AppSuccessState());
    } catch (e) {
      if (!isClosed) {
        emit(AppErrorState(e.toString()));
      }
    }
  }

  Future<void> markMessagesAsRead({
    required String conversationId,
    required BuildContext context,
  }) async {
    emit(AppLoadingState());
    try {
      await supabase
          .from('messages')
          .update({'is_read': true})
          .eq('other_id', Supabase.instance.client.auth.currentUser!.id)
          .eq('conversation_id', conversationId)
          .eq('is_read', false);
      context.read<FetchMessagesCubit>().notificationCount = 0;
      notificationCount = 0;
      await supabase
          .from('conversation_participants')
          .update({'is_read_in': true})
          .eq('conversation_id', conversationId)
          .eq('user_id', Supabase.instance.client.auth.currentUser!.id);
      await supabase
          .from('conversation_participants')
          .update({'is_read_out': true})
          .eq('conversation_id', conversationId)
          .eq('receiver_id', Supabase.instance.client.auth.currentUser!.id);
      emit(AppSuccessState());
    } catch (e) {
      if (!isClosed) {
        emit(AppErrorState(e.toString()));
      }
    }
  }
}

// Future<void> deleteMessage({required String messageId}) async {
//   emit(DeleteMessageLoading());
//   try {
//     await supabase.from('messages').delete().eq('id', messageId);
//     emit(DeleteMessageSuccess());
//   } on AuthException catch (e) {
//     log(e.toString());
//     emit(DeleteMessageError(e.message));
//   } catch (e) {
//     log(e.toString());
//     emit(DeleteMessageError(e.toString()));
//   }
// }

// Future<void> deleteConversation({required String conversationId}) async {
//   emit(DeleteConversationLoading());
//   try {
//     await supabase.from('conversations').delete().eq('id', conversationId);
//     emit(DeleteConversationSuccess());
//   } on AuthException catch (e) {
//     log(e.toString());
//     emit(DeleteConversationError(e.message));
//   } catch (e) {
//     log(e.toString());
//     emit(DeleteConversationError(e.toString()));
//   }
// }

// Future<void> deleteConversationParticipant({required String conversationId}) async {
//   emit(DeleteConversationParticipantLoading());
//   try {
//     await supabase
//         .from('conversation_participants')
//         .delete()
//         .eq('conversation_id', conversationId);
//     emit(DeleteConversationParticipantSuccess());
//   } on AuthException catch (e) {
//     log(e.toString());
//     emit(DeleteConversationParticipantError(e.message));
//   } catch (e) {
//     log(e.toString());
//     emit(DeleteConversationParticipantError(e.toString()));
//   }
// }

// Future<void> deleteConversationMessages({required String conversationId}) async {
//   emit(DeleteConversationMessagesLoading());
//   try {
//     await supabase.from('messages').delete().eq('conversation_id', conversationId);
//     emit(DeleteConversationMessagesSuccess());
//   } on AuthException catch (e) {
//     log(e.toString());
//     emit(DeleteConversationMessagesError(e.message));
//   } catch (e) {
//     log(e.toString());
//     emit(DeleteConversationMessagesError(e.toString()));
//   }
// }
