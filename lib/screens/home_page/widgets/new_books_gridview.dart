import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:biblio/cubit/books/fetch_located_books_cubit.dart';
import 'package:biblio/screens/home_page/widgets/new_books_gridview_body.dart';
import 'package:biblio/screens/home_page/widgets/no_located_books.dart';
import 'package:biblio/screens/home_page/widgets/sign_to_see_new_books_widget.dart';
import 'package:biblio/services/error_message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewBooksGridView extends StatefulWidget {
  const NewBooksGridView({super.key});

  @override
  State<NewBooksGridView> createState() => _NewBooksGridViewState();
}

class _NewBooksGridViewState extends State<NewBooksGridView> {
  @override
  void initState() {
    super.initState();
    context.read<FetchLocatedBooksCubit>().fetchLocatedBooks();
  }

  @override
  Widget build(BuildContext context) {
    String? user;
    if (Supabase.instance.client.auth.currentUser?.id == null) {
      user = null;
    } else {
      user = Supabase.instance.client.auth.currentUser!.id;
    }
    return BlocConsumer<FetchLocatedBooksCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<FetchLocatedBooksCubit>();
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kMainColor,
            toolbarHeight: 80.sp,
            centerTitle: true,

            /// Title
            title: Row(
              spacing: 10.sp,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Latest books'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SvgPicture.asset(
                  'assets/svg/logo.svg',
                  height: 16.sp,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),

            /// Leading
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context); // إزالة جميع الصفحات
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 22.sp,
                color: Colors.white,
              ),
            ),
          ),
          body: state is AppLoadingState
              ? const LoadingWidget()
              : user == null
                  ? const SignToSeeNewBooks()
                  : cubit.books.isNotEmpty
                      ? NewBooksGridviewBody(cubit: cubit)
                      : const NoLocatedBooks(),
        );
      },
    );
  }
}
