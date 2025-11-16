import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/services/error_message.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:biblio/features/chat/presentation/controllers/fetch_user_conversations_cubit.dart';
import 'package:biblio/features/chat/presentation/views/chat_card/conversation_card.dart';
import 'package:biblio/features/chat/presentation/views/no_new_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmittedRequests extends StatelessWidget {
  const SubmittedRequests({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> fetchDate() async {
      await context
          .read<FetchUserConversationsCubit>()
          .fetchSendConversations();
    }

    return BlocConsumer<FetchUserConversationsCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      builder: (context, state) {
        final fetchUserConCubit = context.read<FetchUserConversationsCubit>();
        return state is AppLoadingState
            ? const LoadingWidget()
            : fetchUserConCubit.sendConversations.isEmpty
                ? RefreshIndicator(
                    strokeWidth: 0.9,
                    color: kMainColor,
                    onRefresh: fetchDate,
                    child: const NoNewMessages(),
                  )
                : state is AppLoadingState
                    ? const LoadingWidget()
                    : RefreshIndicator(
                        strokeWidth: 0.9,
                        color: kMainColor,
                        onRefresh: fetchDate,
                        child: ListView.builder(
                          itemCount: fetchUserConCubit.sendConversations.length,
                          itemBuilder: (context, index) {
                            final conversations =
                                fetchUserConCubit.sendConversations[index];

                            return MessageCard(
                              conversation: conversations,
                              sender: conversations['sender'].toString(),
                              receiver: '',
                            );
                          },
                        ),
                      );
      },
    );
  }
}
