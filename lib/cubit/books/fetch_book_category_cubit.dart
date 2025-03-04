import 'package:biblio/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchBookCategoryCubit extends Cubit<AppStates> {
  FetchBookCategoryCubit() : super(AppInitialState());
  SupabaseClient supabase = Supabase.instance.client;
  List<String> categories = [];
  String? selectedCategory;

  /// Fetch Category
  Future<void> fetchCategories(BuildContext context) async {
    emit(AppLoadingState());
    final cubit = context.read<FetchBookCategoryCubit>();

    try {
      final response = await supabase
          .from('categories')
          .select('name')
          .order('id', ascending: true);
      categories = response.map((e) => e['name'] as String).toList();
      if (!cubit.isClosed) {
        emit(AppSuccessState());
      }
    } catch (e) {
      if (!cubit.isClosed) {
        emit(AppErrorState(e.toString()));
      }
    }
  }
}
