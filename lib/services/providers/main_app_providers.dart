import 'package:biblio/cubit/auth_cubit/auth_cubit.dart';
import 'package:biblio/cubit/books/delete_book_cubit.dart';
import 'package:biblio/cubit/books/fetch_book_page_cubit.dart';
import 'package:biblio/cubit/books/fetch_category_cubit.dart';
import 'package:biblio/cubit/books/fetch_located_books_cubit.dart';
import 'package:biblio/cubit/books/update_book_cubit.dart';
import 'package:biblio/cubit/books/upload_book_cubit.dart';
import 'package:biblio/cubit/favorite_function/favorite_button_cubit.dart';
import 'package:biblio/cubit/favorite_function/my_list_cubit.dart';
import 'package:biblio/cubit/messages/create_conversation_cubit.dart';
import 'package:biblio/cubit/messages/fetch_messages_cubit.dart';
import 'package:biblio/cubit/messages/fetch_unread_message_cubit.dart';
import 'package:biblio/cubit/messages/fetch_user_conversations_cubit.dart';
import 'package:biblio/cubit/messages/send_messages_cubit.dart';
import 'package:biblio/cubit/search/search_cubit.dart';
import 'package:biblio/cubit/user/delete_user_cubit.dart';
import 'package:biblio/cubit/user/fetch_user_data_cubit.dart';
import 'package:biblio/cubit/user/get_user_qty_books_cubit.dart';
import 'package:biblio/cubit/user/request_otp_cubit.dart';
import 'package:biblio/cubit/user/save_user_location_cubit.dart';
import 'package:biblio/cubit/user/update_user_favorite_location_cubit.dart';
import 'package:biblio/cubit/user/update_user_image_cubit.dart';
import 'package:biblio/cubit/user/user_favorite_location_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> mainAppProviders() {
  return [
    /// Auth Cubit
    BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
    ),

    /// Books Cubits
    BlocProvider<FetchBookCategoryCubit>(
      create: (context) => FetchBookCategoryCubit(),
    ),
    BlocProvider<MyListCubit>(
      create: (context) => MyListCubit(),
    ),
    BlocProvider<UploadBookCubit>(
      create: (context) => UploadBookCubit(),
    ),
    BlocProvider<FetchLocatedBooksCubit>(
      create: (context) => FetchLocatedBooksCubit(),
    ),
    BlocProvider<DeleteBookCubit>(
      create: (context) => DeleteBookCubit(),
    ),
    BlocProvider<FetchBookPageCubit>(
      create: (context) => FetchBookPageCubit(),
    ),
    BlocProvider<UpdateBookCubit>(
      create: (context) => UpdateBookCubit(),
    ),

    /// User Cubits
    BlocProvider<FavoriteButtonCubit>(
      create: (context) => FavoriteButtonCubit(),
    ),
    BlocProvider<SaveUserLocationCubit>(
      create: (context) => SaveUserLocationCubit(),
    ),
    BlocProvider<GetUserQtyBooksCubit>(
      create: (context) => GetUserQtyBooksCubit(),
    ),
    BlocProvider<FetchUserDataCubit>(
      create: (context) => FetchUserDataCubit(),
    ),
    BlocProvider<UpdateUserImageCubit>(
      create: (context) => UpdateUserImageCubit(),
    ),
    BlocProvider<UserFavoriteLocationCubit>(
      create: (context) => UserFavoriteLocationCubit(),
    ),
    BlocProvider<UpdateUserFavoriteLocationCubit>(
      create: (context) => UpdateUserFavoriteLocationCubit(),
    ),
    BlocProvider<DeleteUserCubit>(
      create: (context) => DeleteUserCubit(),
    ),

    /// Messages Cubits
    BlocProvider<CreateConversationCubit>(
      create: (context) => CreateConversationCubit(),
    ),
    BlocProvider<FetchMessagesCubit>(
      create: (context) => FetchMessagesCubit(),
    ),
    BlocProvider<FetchUserConversationsCubit>(
      create: (context) => FetchUserConversationsCubit(),
    ),
    BlocProvider<SendMessagesCubit>(
      create: (context) => SendMessagesCubit(),
    ),
    BlocProvider<FetchUnreadMessageCubit>(
      create: (context) => FetchUnreadMessageCubit(),
    ),
    BlocProvider<RequestOtpCubit>(
      create: (context) => RequestOtpCubit(),
    ),
    // BlocProvider<NotificationCubit>(
    //   create: (context) => NotificationCubit(),
    // ),

    /// Search Cubit
    BlocProvider<SearchCubit>(
      create: (context) => SearchCubit(),
    ),
  ];
}
