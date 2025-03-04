import 'package:biblio/cubit/books/delete_book_cubit.dart';
import 'package:biblio/screens/book/edit_book/edit_my_book.dart';
import 'package:biblio/screens/navigation_bar/navigation_bar.dart';
import 'package:biblio/utils/components/show_dialog.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

PopupMenuButton<String> editAndDeletePopupMenuButton(
  BuildContext context,
  Map<String, dynamic> book,
) {
  return PopupMenuButton<String>(
    color: kLightBlue,
    onSelected: (value) async {
      if (value == 'edit') {
        await Navigator.pushNamed(
          context,
          EditBook.id,
          arguments: {'bookId': book['id']},
        );
      } else if (value == 'delete') {
        final shouldExit = await showCustomDialog(
          context,
          'ستقوم بحذف الكتاب؟',
        );

        if (shouldExit!) {
          await context.read<DeleteBookCubit>().deleteBook(
                book,
              );
          await Navigator.pushReplacementNamed(
            context,
            NavigationBarApp.id,
          );
        }
      }
    },
    itemBuilder: (BuildContext context) {
      return [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.mode_edit_outline_outlined,
                size: 24.sp,
                color: kMainColor,
              ),
              const SizedBox(width: 8),
              const Text('تعديل'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_rounded,
                color: kMainColor,
                size: 22.sp,
              ),
              const SizedBox(width: 8),
              const Text('مسح'),
            ],
          ),
        ),
      ];
    },
  );
}
