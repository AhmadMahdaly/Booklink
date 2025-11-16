import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/cubit/messages/create_conversation_cubit.dart';
import 'package:biblio/cubit/messages/fetch_messages_cubit.dart';
import 'package:biblio/cubit/messages/fetch_unread_message_cubit.dart';
import 'package:biblio/cubit/messages/fetch_user_conversations_cubit.dart';
import 'package:biblio/screens/chat/chat_card/book_image.dart';
import 'package:biblio/screens/chat/chat_card/support_image.dart';
import 'package:biblio/screens/chat/chat_room/conversation_room.dart';
import 'package:biblio/services/error_message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    required this.conversation,
    required this.sender,
    required this.receiver,
    super.key,
  });
  final Map<String, dynamic> conversation;
  final String sender;
  final String receiver;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() {
    try {
      context.read<FetchUnreadMessageCubit>().fetchUnreadMessages(
            otherId: widget.conversation['user_id'].toString(),
          );
    } catch (e) {
      errorMessage(e.toString(), context);
    }
  }

  void navigateToConversation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationRoom(
          messageType: widget.sender.isEmpty ? 'in' : 'out',
          conversationId: widget.conversation['conversation_id'].toString(),
          titleBook: widget.conversation['title_book'].toString(),
          userName: widget.sender.isEmpty ? widget.receiver : widget.sender,
          otherId:
              context.read<CreateConversationCubit>().otherUserId.toString(),
        ),
      ),
    ).then((_) {
      fetchData();
      context
        ..read<FetchUserConversationsCubit>().fetchReceiverConversations()
        ..read<FetchUserConversationsCubit>().fetchSendConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser!.id;
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: navigateToConversation,
      onLongPress: () => showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: kScaffoldBackgroundColor,
            title: Text(
              'هل تريد حذف المحادثة؟',
              style: TextStyle(
                color: kMainColor,
                fontSize: 15.sp,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'إلغاء',
                  style: TextStyle(fontSize: 13.sp, color: kTextColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  BlocProvider.of<FetchMessagesCubit>(context)
                      .deleteConversation(
                    conversationId:
                        widget.conversation['conversation_id'].toString(),
                  );
                  context
                    ..read<FetchUserConversationsCubit>()
                        .fetchReceiverConversations()
                    ..read<FetchUserConversationsCubit>()
                        .fetchSendConversations();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'موافق',
                  style: TextStyle(fontSize: 13.sp, color: kHeader1Color),
                ),
              ),
            ],
          );
        },
      ),
      child: Container(
        margin: EdgeInsets.only(
          right: 16.sp,
          left: 16.sp,
          top: 16.sp,
        ),
        decoration: BoxDecoration(
          color: kLightBlue,
          borderRadius: BorderRadius.circular(15.sp),
        ),
        height: 90.sp,

        /// Card Image
        child: Row(
          spacing: 20.sp,
          children: [
            if (widget.conversation['sender'] == 'Technical support')
              const SupportImage()
            else
              BookImage(
                bookImage: widget.conversation['book_image'].toString(),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5.sp,
              children: [
                SizedBox(
                  child: Text(
                    /// User Name
                    widget.sender.isEmpty ? widget.receiver : widget.sender,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kMainColor,
                      fontSize: 16.sp,

                      /// Bold if the message is unread
                      fontWeight: widget.conversation['receiver_id'] == user &&
                                  widget.conversation['is_read_out'] == false ||
                              widget.conversation['user_id'] == user &&
                                  widget.conversation['is_read_in'] == false
                          ? FontWeight.bold
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (widget.conversation['sender'] == 'Technical support')

                  /// Support Message
                  SizedBox(
                    child: Text(
                      'FollowComplaint'.tr(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kMainColor,
                        fontSize: 14.sp,
                        fontWeight: widget.conversation['user_id'] == user &&
                                    widget.conversation['is_read_in'] ==
                                        false ||
                                widget.conversation['receiver_id'] == user &&
                                    widget.conversation['is_read_out'] == false
                            ? FontWeight.bold
                            : FontWeight.w500,
                        height: 1.70,
                      ),
                    ),
                  )
                else

                  /// Book Title
                  SizedBox(
                    child: Text(
                      context.locale == const Locale('ar')
                          ? 'طلب كتاب ${widget.conversation['title_book']}'
                          : '${widget.conversation['title_book']} Book request',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kMainColor,
                        fontSize: 14.sp,
                        fontWeight: widget.conversation['user_id'] == user &&
                                    widget.conversation['is_read_in'] ==
                                        false ||
                                widget.conversation['receiver_id'] == user &&
                                    widget.conversation['is_read_out'] == false
                            ? FontWeight.bold
                            : FontWeight.w500,
                        height: 1.70,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
