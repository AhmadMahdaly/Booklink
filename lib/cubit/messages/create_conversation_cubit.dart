import 'package:biblio/cubit/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateConversationCubit extends Cubit<AppStates> {
  CreateConversationCubit() : super(AppInitialState());
  final supabase = Supabase.instance.client;
  int? conversationId;
  String? otherUserId;

  /// Create Conversation
  Future<void> createConversation({
    required String otherId,
    required String titleBook,
    required String bookImg,
    required String bookId,
    required String sender,
    required String receiver,
  }) async {
    emit(AppLoadingState());
    try {
      final userId = supabase.auth.currentUser!.id;
      otherUserId = otherId;

      final response = await supabase
          .from('conversations')
          .insert({'book_id': bookId})
          .select('id')
          .single();
      conversationId = response['id'] as int;

      // إضافة المستخدمين إلى المحادثة
      await supabase.from('conversation_participants').insert(
        {
          'receiver_id': otherId,
          'conversation_id': conversationId,
          'user_id': userId,
          'book_image': bookImg,
          'title_book': titleBook,
          'book_id': bookId,
          'receiver': receiver,
          'sender': sender,
        },
      );

      emit(AppSuccessState());
    } catch (e) {
      if (!isClosed) {
        emit(AppErrorState(e.toString()));
      }
    }
  }
}
