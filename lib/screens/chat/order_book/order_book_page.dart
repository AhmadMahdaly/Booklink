import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:biblio/core/shared_widgets/leading_icon.dart';
import 'package:biblio/cubit/books/fetch_book_page_cubit.dart';
import 'package:biblio/cubit/messages/create_conversation_cubit.dart';
import 'package:biblio/cubit/messages/send_messages_cubit.dart';
import 'package:biblio/screens/chat/chat_room/conversation_room.dart';
import 'package:biblio/screens/chat/order_book/order_book_body.dart';
import 'package:biblio/screens/chat/order_book/order_button.dart';
import 'package:biblio/services/error_message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTheBookPage extends StatefulWidget {
  const OrderTheBookPage({super.key});
  static String id = 'OrderTheBookPage';

  @override
  State<OrderTheBookPage> createState() => _OrderTheBookPageState();
}

class _OrderTheBookPageState extends State<OrderTheBookPage> {
  final _messageController = TextEditingController();
  late int bookId = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
      setState(() {
        bookId = args['book_id'] as int;
        BlocProvider.of<FetchBookPageCubit>(context).fetchBook(bookId);
      });
    });
  }

  void navigateToBookMsgRoom() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationRoom(
          conversationId:
              context.read<CreateConversationCubit>().conversationId.toString(),
          titleBook: BlocProvider.of<FetchBookPageCubit>(context).titleBook,
          userName: BlocProvider.of<FetchBookPageCubit>(context).otherName,
          otherId: BlocProvider.of<FetchBookPageCubit>(context).bookUser,
          messageType: 'out',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchBookPageCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      builder: (context, state) {
        final fetchBookPageCubit = context.read<FetchBookPageCubit>();
        final titleBook = fetchBookPageCubit.titleBook;
        final bookUser = fetchBookPageCubit.bookUser;
        final bookImage = fetchBookPageCubit.bookImage;
        final otherName = fetchBookPageCubit.otherName;
        final uuser = fetchBookPageCubit.uuser;
        return BlocConsumer<SendMessagesCubit, AppStates>(
          listener: (context, state) {
            if (state is AppErrorState) {
              errorMessage(state.message, context);
            }
          },
          builder: (context, state) {
            final sendMsgCubit = context.read<SendMessagesCubit>();
            return BlocConsumer<CreateConversationCubit, AppStates>(
              listener: (context, state) {
                if (state is AppErrorState) {
                  errorMessage(state.message, context);
                }
                if (state is AppSuccessState) {
                  navigateToBookMsgRoom();
                }
              },
              builder: (context, state) {
                final createConCubit = context.read<CreateConversationCubit>();
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      context.locale == const Locale('ar')
                          ? 'رسالة لطلب كتاب $titleBook'
                          : '$titleBook Book request message',
                      style: TextStyle(
                        color: kMainColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.71.sp,
                      ),
                    ),

                    /// Leading
                    leading: const LeadingIcon(),
                  ),
                  body: state is AppLoadingState
                      ? const LoadingWidget()
                      : OrderBookBody(messageController: _messageController),
                  bottomNavigationBar: state is AppLoadingState
                      ? const SizedBox()
                      : orderButton(
                          context,
                          createConCubit,
                          otherName,
                          uuser,
                          bookUser,
                          titleBook,
                          bookImage,
                          sendMsgCubit,
                          _messageController,
                          bookId,
                        ),
                );
              },
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
