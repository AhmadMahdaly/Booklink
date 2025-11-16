import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/services/error_message.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/custom_textformfield.dart';
import 'package:biblio/features/chat/presentation/controllers/fetch_messages_cubit.dart';
import 'package:biblio/features/chat/presentation/controllers/send_messages_cubit.dart';
import 'package:biblio/features/chat/presentation/views/chat_room/from_user_in_message.dart';
import 'package:biblio/features/chat/presentation/views/chat_room/from_user_out_message.dart';
import 'package:biblio/features/chat/presentation/views/chat_room/to_user_message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationRoom extends StatefulWidget {
  const ConversationRoom({
    required this.conversationId,
    required this.titleBook,
    required this.userName,
    required this.otherId,
    required this.messageType,
    super.key,
  });
  final String conversationId;
  final String titleBook;
  final String userName;
  final String otherId;
  final String messageType;
  @override
  State<ConversationRoom> createState() => _ConversationRoomState();
}

class _ConversationRoomState extends State<ConversationRoom> {
  final supabase = Supabase.instance.client;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDate();
  }

  Map<String, dynamic> message = {};
  Future<void> fetchDate() async {
    try {
      await context.read<FetchMessagesCubit>().fetchMessages(
            conversationId: widget.conversationId,
          );

      /// If the message is incoming, mark it as read
      await context.read<FetchMessagesCubit>().markMessagesAsRead(
            conversationId: widget.conversationId,
            context: context,
          );

      /// Fetch the user name
      if (message['user_id'] != null) {
        await context
            .read<FetchMessagesCubit>()
            .fetchUserName(userId: message['user_id'].toString());
      }
    } catch (e) {
      errorMessage(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchMessagesCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      builder: (context, state) {
        context.read<FetchMessagesCubit>().fetchMessages(
              conversationId: widget.conversationId,
            );
        final cubit = context.read<FetchMessagesCubit>();
        return BlocConsumer<SendMessagesCubit, AppStates>(
          listener: (context, state) {
            if (state is AppErrorState) {
              errorMessage(state.message, context);
            }
          },
          builder: (context, state) {
            final sendMessageCubit = context.read<SendMessagesCubit>();
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 100.sp,
                backgroundColor: kMainColor,
                title: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6.sp,
                    children: [
                      Text(
                        context.locale == const Locale('ar')
                            ? 'طلب كتاب ${widget.titleBook}'
                            : '${widget.titleBook} Book request',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        widget.userName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kLightBlue,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Leading
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.expand_circle_down,
                      size: 40.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              body: ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                itemCount: cubit.messages.length,
                itemBuilder: (context, index) {
                  message = cubit.messages[index];
                  return widget.messageType == 'in' &&
                          message['user_id'] == supabase.auth.currentUser!.id
                      ? FromUserInMessage(
                          content: message['content'].toString(),
                          timestamp: message['created_at'].toString(),
                          msgId: message['id'].toString(),
                        )
                      : widget.messageType == 'out' &&
                              message['user_id'] ==
                                  supabase.auth.currentUser!.id
                          ? FromUserOutMessage(
                              content: message['content'].toString(),
                              timestamp: message['created_at'].toString(),
                              msgId: message['id'].toString(),
                            )
                          : ToUserMessage(
                              content: message['content'].toString(),
                              timestamp: message['created_at'].toString(),
                              msgId: message['id'].toString(),
                            );
                },
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 16.sp,
                    left: 16.sp,
                    right: 16.sp,
                  ),
                  child: TextField(
                    controller: _messageController,
                    maxLength: 365,
                    decoration: InputDecoration(
                      border: border(),
                      focusedBorder: border(),
                      enabledBorder: border(),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      hintText: 'Send a message'.tr(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: kMainColor,
                          size: 24.sp,
                        ),
                        onPressed: () {
                          if (_messageController.text.isEmpty) return;
                          try {
                            widget.messageType == 'in'
                                ? sendMessageCubit.sendIncomeMessage(
                                    content: _messageController.text,
                                    conversationId: widget.conversationId,
                                  )
                                : sendMessageCubit.sendOutgoingMessage(
                                    content: _messageController.text,
                                    conversationId: widget.conversationId,
                                  );
                            _messageController.clear();
                          } catch (e) {
                            errorMessage(e.toString(), context);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
