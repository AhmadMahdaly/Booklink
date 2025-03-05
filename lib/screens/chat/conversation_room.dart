import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/messages/fetch_messages_cubit.dart';
import 'package:biblio/cubit/messages/send_messages_cubit.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/components/custom_textformfield.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
      await context.read<FetchMessagesCubit>().markMessagesAsRead(
            conversationId: widget.conversationId,
            context: context,
          );
      if (message['user_id'] != null) {
        await context
            .read<FetchMessagesCubit>()
            .fetchUserName(userId: message['user_id'].toString());
      }
    } catch (e) {
      // showSnackBar(context, e.toString());
    }
  }

  String getTimeDifference() {
    final timestamp = message['created_at'].toString();
    final dateTime =
        DateTime.parse(timestamp).toLocal(); // تحويل UTC إلى التوقيت المحلي
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours == 0) {
      // اليوم
      return 'اليوم - ${DateFormat('hh:mm a', 'ar').format(dateTime)}';
      // } else if (difference.inHours == 22) {
      //   // أمس
      //   return "أمس - ${DateFormat('hh:mm a', 'ar').format(dateTime)}";
    } else if (difference.inDays < 7) {
      // أيام الأسبوع
      return "${DateFormat('EEEE', 'ar').format(dateTime)} - ${DateFormat('hh:mm a', 'ar').format(dateTime)}";
    } else {
      // التاريخ الكامل
      return "${DateFormat('yyyy/MM/dd', 'ar').format(dateTime)} - ${DateFormat('hh:mm a', 'ar').format(dateTime)}";
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
                        'طلب كتاب ${widget.titleBook}',
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
                      ? Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent, // إزالة الخطوط
                          ),
                          child: SizedBox(
                            child: ExpansionTile(
                              backgroundColor: kLightBlue,
                              tilePadding: EdgeInsets.zero,
                              childrenPadding: EdgeInsets.zero,
                              showTrailingIcon: false,
                              title: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: EdgeInsets.all(8.sp),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 16.sp,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.sp),
                                      bottomLeft: Radius.circular(12.sp),
                                      bottomRight: Radius.circular(12.sp),
                                    ),
                                    color: kMainColor,
                                  ),
                                  child: Text(
                                    message['content'].toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              children: [
                                Text(
                                  getTimeDifference(),
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : widget.messageType == 'out' &&
                              message['user_id'] ==
                                  supabase.auth.currentUser!.id
                          ? Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor:
                                    Colors.transparent, // إزالة الخطوط
                              ),
                              child: SizedBox(
                                child: ExpansionTile(
                                  backgroundColor: kLightBlue,
                                  tilePadding: EdgeInsets.zero,
                                  childrenPadding: EdgeInsets.zero,
                                  showTrailingIcon: false,
                                  title: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: EdgeInsets.all(8.sp),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16.sp,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12.sp),
                                          bottomLeft: Radius.circular(12.sp),
                                          bottomRight: Radius.circular(12.sp),
                                        ),
                                        color: kMainColor,
                                      ),
                                      child: Text(
                                        message['content'].toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  children: [
                                    Text(
                                      getTimeDifference(),
                                      style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor:
                                    Colors.transparent, // إزالة الخطوط
                              ),
                              child: SizedBox(
                                child: ExpansionTile(
                                  backgroundColor: Colors.white,
                                  tilePadding: EdgeInsets.zero,
                                  childrenPadding: EdgeInsets.zero,
                                  showTrailingIcon: false,
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: EdgeInsets.all(8.sp),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16.sp,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12.sp),
                                          bottomLeft: Radius.circular(12.sp),
                                          bottomRight: Radius.circular(12.sp),
                                        ),
                                        color: kLightBlue,
                                      ),
                                      child: Text(
                                        message['content'].toString(),
                                        style: TextStyle(
                                          color: kTextColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  children: [
                                    Text(
                                      getTimeDifference(),
                                      style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                      hintText: 'ارسل رسالة ...',
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
                            // log(e.toString());
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
