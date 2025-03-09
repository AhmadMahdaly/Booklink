import 'package:biblio/cubit/books/fetch_located_books_cubit.dart';
import 'package:biblio/screens/book/book_item/book_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewBooksGridviewBody extends StatelessWidget {
  const NewBooksGridviewBody({
    required this.cubit,
    super.key,
  });

  final FetchLocatedBooksCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 16.sp,
          vertical: 16.sp,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.9,
          crossAxisSpacing: 16.sp,
          mainAxisSpacing: 16.sp,
        ),
        itemBuilder: (context, index) {
          final book = cubit.books[index];

          return BookItem(
            book: book,
          );
        },
        itemCount: cubit.books.length,
      ),
    );
  }
}
