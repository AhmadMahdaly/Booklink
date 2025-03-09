import 'package:biblio/cubit/messages/create_conversation_cubit.dart';
import 'package:biblio/cubit/messages/send_messages_cubit.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Padding orderButton(
  BuildContext context,
  CreateConversationCubit createConCubit,
  String otherName,
  String uuser,
  String bookUser,
  String titleBook,
  String bookImage,
  SendMessagesCubit sendMsgCubit,
  TextEditingController messageController,
  int bookId,
) {
  return Padding(
    padding: EdgeInsets.all(16.sp),
    child: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CustomButton(
        onTap: () async {
          try {
            if (messageController.text.isEmpty) return;
            await createConCubit.createConversation(
              sender: otherName,
              receiver: uuser,
              otherId: bookUser,
              titleBook: titleBook,
              bookImg: bookImage,
              bookId: bookId.toString(),
            );
            await sendMsgCubit.sendIncomeMessage(
              content: messageController.text,
              conversationId: createConCubit.conversationId.toString(),
            );
          } catch (e) {
            errorMessage(e.toString(), context);
          }
        },
        text: 'إرسال',
      ),
    ),
  );
}
