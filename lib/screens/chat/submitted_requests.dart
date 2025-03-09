import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/messages/fetch_user_conversations_cubit.dart';
import 'package:biblio/screens/chat/conversation_card.dart';
import 'package:biblio/screens/chat/no_new_messages.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
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
            ? const AppIndicator()
            : fetchUserConCubit.sendConversations.isEmpty
                ? RefreshIndicator(
                    strokeWidth: 0.9,
                    color: kMainColor,
                    onRefresh: fetchDate,
                    child: const NoNewMessages(),
                  )
                : state is AppLoadingState
                    ? const AppIndicator()
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
