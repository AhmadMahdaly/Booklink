import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/books/fetch_located_books_cubit.dart';
import 'package:biblio/screens/home_page/widgets/new_books_listview_body.dart';
import 'package:biblio/screens/home_page/widgets/no_located_books.dart';
import 'package:biblio/screens/home_page/widgets/sign_to_see_new_books_widget.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return user == null
        ? const SignToSeeNewBooks()
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
                      ? NewBooksListviewBody(cubit: cubit)
                      : const NoLocatedBooks();
            },
          );
  }
}
