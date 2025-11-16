import 'package:biblio/core/shared_controllers/app_states.dart';
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

  Future<void> deleteMessage({required String messageId}) async {
    emit(AppLoadingState());
    try {
      await supabase.from('messages').delete().eq('id', messageId);
      emit(AppSuccessState());
    } on AuthException catch (e) {
      emit(AppErrorState(e.message));
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }

  Future<void> deleteConversation({
    required String conversationId,
  }) async {
    emit(AppLoadingState());
    try {
      await supabase.from('conversations').delete().eq('id', conversationId);
      await supabase
          .from('conversation_participants')
          .delete()
          .eq('conversation_id', conversationId);
      await supabase
          .from('messages')
          .delete()
          .eq('conversation_id', conversationId);
      emit(AppSuccessState());
    } on AuthException catch (e) {
      emit(AppErrorState(e.message));
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
