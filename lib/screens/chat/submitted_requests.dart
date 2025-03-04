import 'package:biblio/animations/animate_do.dart';
import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/messages/fetch_user_conversations_cubit.dart';
import 'package:biblio/screens/chat/conversation_card.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                    child: CustomFadeInUp(
                      duration: 300,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          spacing: 10.sp,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 46.sp,
                              color: kBorderColor,
                            ),
                            Text(
                              'لا توجد طلبات جديدة',
                              style: TextStyle(
                                color: kTextShadowColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
