import 'dart:async';

import 'package:biblio/cubit/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchCubit extends Cubit<AppStates> {
  SearchCubit() : super(AppInitialState());

  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> books = [];
  Timer? debounce;

  // دالة البحث مع تأخير (Debounce) لمنع البحث مع كل حرف يكتبه المستخدم
  void searchBooks(String query) {
    emit(AppLoadingState());
    try {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 700), () async {
        if (query.isEmpty) {
          books = [];
          emit(AppSuccessState());
          return;
        }

        final response = await supabase.from('books').select('*').or(
              'title.ilike.%$query%,author.ilike.%$query%',
            ); // بحث في العنوان أو المؤلف

        books = response;
        emit(AppSuccessState());
      });
    } catch (e) {
      if (!isClosed) {
        emit(AppErrorState(e.toString()));
      }
    }
  }
}
