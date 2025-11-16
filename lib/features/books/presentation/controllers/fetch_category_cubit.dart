import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchBookCategoryCubit extends Cubit<AppStates> {
  FetchBookCategoryCubit() : super(AppInitialState());
  SupabaseClient supabase = Supabase.instance.client;
  List<String> categories = [];
  String? selectedCategory;

  /// Fetch Category
  Future<void> fetchCategories() async {
    emit(AppLoadingState());
    try {
      final response = await supabase
          .from('categories')
          .select('name')
          .order('id', ascending: true);
      categories = response.map((e) => e['name'] as String).toList();
      if (!isClosed) {
        emit(AppSuccessState());
      }
    } catch (e) {
      if (!isClosed) {
        emit(AppErrorState(e.toString()));
      }
    }
  }

  /// Fetch Books
  List<Map<String, dynamic>> books = [];
  Future<void> fetchBooks(String category) async {
    emit(AppLoadingState());
    try {
      final response = await supabase
          .from('books')
          .select('*')
          .eq('category', category)
          .order('title', ascending: true);
      if (response != null) {
        books = List<Map<String, dynamic>>.from(response);
        emit(AppSuccessState());
      }
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
