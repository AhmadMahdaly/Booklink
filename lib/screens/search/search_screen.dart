import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/search/search_cubit.dart';
import 'package:biblio/screens/book/book_page/book_page.dart';
import 'package:biblio/screens/search/search_bar.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookSearchScreen extends StatelessWidget {
  const BookSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<SearchCubit>();
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 100.sp,
            leadingWidth: 30.sp,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 22.sp,
                color: kMainColor,
              ),
            ),
            title: const SearchBarWidget(),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.sp),
            child: Column(
              children: [
                Expanded(
                  child: cubit.books.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/Reading glasses-cuate.svg',
                                height: 80.sp,
                              ),
                              Text(
                                'لا توجد نتائج',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: cubit.books.length,
                          itemBuilder: (context, index) {
                            final book = cubit.books[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 12.sp),
                              color: kLightBlue,
                              child: ListTile(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowBookItem(
                                      book: book,
                                    ),
                                  ),
                                ),
                                leading: book['cover_image_url'] != null
                                    ? Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.sp),
                                        ),
                                        child: Image.network(
                                          book['cover_image_url'].toString(),
                                          width: 50.sp,
                                          height: 50.sp,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(Icons.book, size: 50.sp),
                                title: Text(
                                  book['title'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                subtitle: Text("✍ ${book['author']}"),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
