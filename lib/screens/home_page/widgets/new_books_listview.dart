import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/books/fetch_located_books_cubit.dart';
import 'package:biblio/screens/book/book_page/book_page.dart';
import 'package:biblio/screens/home_page/widgets/no_located_books.dart';
import 'package:biblio/screens/home_page/widgets/show_book.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:biblio/utils/components/login_user_not_found.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewBooksListview extends StatefulWidget {
  const NewBooksListview({super.key});

  @override
  State<NewBooksListview> createState() => _NewBooksListviewState();
}

class _NewBooksListviewState extends State<NewBooksListview> {
  @override
  void initState() {
    super.initState();
    context.read<FetchLocatedBooksCubit>().fetchLocatedBooks(context);
  }

  @override
  Widget build(BuildContext context) {
    String? user;
    if (Supabase.instance.client.auth.currentUser?.id == null) {
      user = null;
    } else {
      user = Supabase.instance.client.auth.currentUser!.id;
    }
    return user == null
        ? Column(
            spacing: 12.sp,
            children: [
              const H(h: 16),
              Text(
                'قم بتسجيل الدخول لرؤية الكتب المعروضة في منطقتك:',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const LoginUserNotFound(),
              const TryToDiscoverCategory(),
            ],
          )
        : BlocConsumer<FetchLocatedBooksCubit, AppStates>(
            listener: (context, state) {
              if (state is AppErrorState) {
                errorMessage(state.message, context);
              }
            },
            builder: (context, state) {
              final cubit = context.read<FetchLocatedBooksCubit>();
              return state is AppLoadingState
                  ? const AppIndicator()
                  : cubit.books.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 8.sp),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final book = cubit.books[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowBookItem(
                                      book: book,
                                    ),
                                  ),
                                );
                              },
                              child: ShowBook(
                                book: book,
                              ),
                            );
                          },
                          itemCount: cubit.books.length,
                        )
                      : const NoLocatedBooks();
            },
          );
  }
}
