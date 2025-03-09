import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/books/delete_book_cubit.dart';
import 'package:biblio/screens/book/book_page/widgets/book_author.dart';
import 'package:biblio/screens/book/book_page/widgets/book_category.dart';
import 'package:biblio/screens/book/book_page/widgets/book_desc.dart';
import 'package:biblio/screens/book/book_page/widgets/book_image.dart';
import 'package:biblio/screens/book/book_page/widgets/book_location.dart';
import 'package:biblio/screens/book/book_page/widgets/book_price.dart';
import 'package:biblio/screens/book/book_page/widgets/book_title.dart';
import 'package:biblio/screens/book/book_page/widgets/book_user_label.dart';
import 'package:biblio/screens/book/book_page/widgets/edit_and_delete_popup_menu_button.dart';
import 'package:biblio/screens/book/book_page/widgets/offer_types_widget.dart';
import 'package:biblio/screens/book/book_page/widgets/post_date_and_time.dart';
import 'package:biblio/screens/chat/order_book/order_book_page.dart';
import 'package:biblio/screens/my_lib_page/widgets/favorate_button.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/components/custom_button.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:biblio/utils/components/leading_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShowBookItem extends StatelessWidget {
  const ShowBookItem({required this.book, super.key});
  final Map<String, dynamic> book;

  @override
  Widget build(BuildContext context) {
    String? user;
    if (Supabase.instance.client.auth.currentUser?.id == null) {
      user = null;
    } else {
      user = Supabase.instance.client.auth.currentUser!.id;
    }
    return BlocListener<DeleteBookCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            /// Edit button
            if (user == null)
              const SizedBox()
            else if (book['user_id'] == user)
              editAndDeletePopupMenuButton(context, book)

            /// Favorite button
            else if (book['user_id'] != user)
              FavoriteButton(
                bookId: book['id'].toString(),
              )
            else
              const SizedBox(),
          ],

          /// Leading
          leading: const LeadingIcon(),
        ),
        body: State is AppLoadingState
            ? const AppIndicator()
            : ListView(
                children: [
                  BookPageImage(book: book),
                  const H(h: 16),
                  Row(
                    children: [
                      BookPageTitle(book: book),
                      const Spacer(),
                      OfferTypesWidget(book: book),
                    ],
                  ),
                  Row(
                    children: [
                      BookPageAuthor(book: book),
                      const Spacer(),
                      BookPrice(book: book),
                    ],
                  ),
                  BookPageDescription(book: book),
                  BookPageCategory(book: book),
                  const H(h: 16),
                  BookUserLabel(book: book),
                  BookPageLocation(book: book),
                  PostBookDateAndTime(book: book),
                  const H(h: 36),
                ],
              ),
        bottomNavigationBar: user == null || book['user_id'] == user
            ? const SizedBox()
            : book['user_id'] != user
                ? Padding(
                    padding: EdgeInsets.only(
                      bottom: 16.sp,
                      top: 8.sp,
                    ),
                    child: CustomButton(
                      padding: 16,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          OrderTheBookPage.id,
                          arguments: {'book_id': book['id']},
                        );
                      },
                      text: 'طلب الكتاب',
                    ),
                  )
                : const SizedBox(),
      ),
    );
  }
}
