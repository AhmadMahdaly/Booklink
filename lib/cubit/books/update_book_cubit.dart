import 'package:biblio/cubit/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateBookCubit extends Cubit<AppStates> {
  UpdateBookCubit() : super(AppInitialState());
  SupabaseClient supabase = Supabase.instance.client;

  String selectedCategory = '';
  List<String> categories = [];
  String selectedOffer = '';
  List<String> offerTypes = [];
  String titleController = '';
  String descriptionController = '';
  String authorController = '';
  String conditionController = '';
  String priceController = '';
  // String photoUrlController = '';
  // String photoUrlControllerI = '';

  Future<void> initializeData(
    int bookId,
  ) async {
    emit(AppLoadingState());
    final user = supabase.auth.currentUser;
    try {
      if (user == null) {
        return;
      }
      await fetchCategories();
      await fetchOrderType();
      final newTitle = titleController;
      final newdesc = descriptionController;
      final newAuthor = authorController;
      final newCategory = selectedCategory;
      final newCondition = conditionController;
      final newOfferType = selectedOffer;
      final newprice = priceController;
      // final newUrl = photoUrlController;
      // final newUrlI = photoUrlControllerI;
      if (newTitle.isEmpty ||
              newTitle == null ||
              newdesc.isEmpty ||
              newdesc == null ||
              newAuthor.isEmpty ||
              newAuthor == null ||
              selectedCategory.isEmpty ||
              newCategory == null ||
              newCondition.isEmpty ||
              newCondition == null ||
              newOfferType.isEmpty ||
              newOfferType == null ||
              newprice.isEmpty ||
              newprice == null
          // || newUrl.isEmpty ||
          // newUrl == null ||
          // newUrlI.isEmpty ||
          // newUrlI == null
          ) {
        final response = await supabase
            .from('books')
            .select(
              'title,description,author,category,condition,offer_type,price,cover_image_url, cover_book_url2',
            )
            .eq('id', bookId)
            .single();
        final title = response['title'];
        final desc = response['description'];
        final author = response['author'];
        final category = response['category'];
        final condition = response['condition'];
        final offerType = response['offer_type'];
        final price = response['price'];
        // final photoUrl = response['cover_image_url'];
        // final photoUrlI = response['cover_book_url2'];

        /// لإظهار الداتا
        if (title != null ||
            desc != null ||
            author != null ||
            category != null ||
            condition != null ||
            offerType != null ||
            price != null) {
          titleController = title.toString();
          descriptionController = desc.toString();
          authorController = author.toString();
          conditionController = condition.toString();
          priceController = price.toString();
          selectedCategory = category.toString();
          selectedOffer = offerType.toString();
          // photoUrlController = photoUrl.toString();
          // photoUrlControllerI = photoUrlI.toString();
        }
      }

      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }

  Future<void> updateBook({
    required String bookId,
    required String title,
    required String description,
    required String author,
    required String category,
    required String condition,
    required String offerType,
    required int price,
  }) async {
    emit(AppLoadingState());
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('books').update({
        'price': price,
        'title': title,
        'author': author,
        'category': category,
        'description': description,
        'condition': condition,
        'offer_type': offerType,
      }).eq('id', bookId);
      await supabase.from('conversation_participants').update({
        'title_book': title,
      }).eq('book_id', bookId);

      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }

  Future<void> fetchCategories() async {
    final response = await supabase.from('categories').select('name');
    categories = response.map((e) => e['name'] as String).toList();
    emit(AppSuccessState());
  }

  Future<void> fetchOrderType() async {
    final response = await supabase.from('offer_type').select('type');
    emit(AppSuccessState());
    offerTypes = response.map((e) => e['type'] as String).toList();
  }
}
