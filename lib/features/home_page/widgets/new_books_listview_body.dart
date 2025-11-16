import 'package:biblio/features/books/presentation/controllers/fetch_located_books_cubit.dart';
import 'package:biblio/features/books/presentation/views/book_page.dart';
import 'package:biblio/features/home_page/widgets/show_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewBooksListviewBody extends StatelessWidget {
  const NewBooksListviewBody({
    required this.cubit,
    super.key,
  });

  final FetchLocatedBooksCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}
