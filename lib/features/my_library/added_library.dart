import 'package:biblio/features/books/presentation/views/book_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddedLibrary extends StatelessWidget {
  const AddedLibrary({required this.books, super.key});
  final List<Map<String, dynamic>> books;
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
          final book = books[index];
          return BookItem(
            book: book,
          );
        },
        itemCount: books.length,
      ),
    );
  }
}
