import 'package:biblio/cubit/messages/create_conversation_cubit.dart';
import 'package:biblio/cubit/messages/fetch_unread_message_cubit.dart';
import 'package:biblio/cubit/messages/fetch_user_conversations_cubit.dart';
import 'package:biblio/screens/chat/conversation_room.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      // showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser!.id;

    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationRoom(
              messageType: widget.sender.isEmpty ? 'in' : 'out',
              conversationId: widget.conversation['conversation_id'].toString(),
              titleBook: widget.conversation['title_book'].toString(),
              userName: widget.sender.isEmpty ? widget.receiver : widget.sender,
              otherId: context
                  .read<CreateConversationCubit>()
                  .otherUserId
                  .toString(),
            ),
          ),
        ).then((_) {
          fetchData();
          context
            ..read<FetchUserConversationsCubit>().fetchReceiverConversations()
            ..read<FetchUserConversationsCubit>().fetchSendConversations();
        });
      },
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
        child: Row(
          spacing: 20.sp,
          children: [
            if (widget.conversation['sender'] == 'الدعم الفني')
              Container(
                margin: EdgeInsets.all(8.sp),
                height: 60.sp,
                width: 60.sp,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(320),
                ),
                child: Image.asset('assets/icons/icon app.png'),
              )
            else
              Container(
                margin: EdgeInsets.all(8.sp),
                height: 60.sp,
                width: 60.sp,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(320),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.conversation['book_image'].toString(),
                  fit: BoxFit.cover,
                  height: 60.sp,
                  width: 60.sp,
                  errorListener: (_) => Container(
                    height: 60.sp,
                    width: 60.sp,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kLightBlue,
                      borderRadius: BorderRadius.circular(320),
                    ),
                    child: Icon(
                      Icons.archive_outlined,
                      size: 24.sp,
                      color: kMainColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 60.sp,
                    width: 60.sp,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kLightBlue,
                      borderRadius: BorderRadius.circular(320),
                    ),
                    child: Icon(
                      Icons.archive_outlined,
                      size: 24.sp,
                      color: kMainColor,
                    ),
                  ),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5.sp,
              children: [
                SizedBox(
                  child: Text(
                    widget.sender.isEmpty ? widget.receiver : widget.sender,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kMainColor,
                      fontSize: 16.sp,
                      fontWeight: widget.conversation['receiver_id'] == user &&
                                  widget.conversation['is_read_out'] == false ||
                              widget.conversation['user_id'] == user &&
                                  widget.conversation['is_read_in'] == false
                          ? FontWeight.bold
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (widget.conversation['sender'] == 'الدعم الفني')
                  SizedBox(
                    child: Text(
                      'متابعة شكوى أو مقترح',
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
                  SizedBox(
                    child: Text(
                      'طلب كتاب: ${widget.conversation['title_book']}',
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
