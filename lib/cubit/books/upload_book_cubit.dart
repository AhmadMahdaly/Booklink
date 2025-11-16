import 'dart:io';

import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/screens/book/add_book_page/models/book_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadBookCubit extends Cubit<AppStates> {
  UploadBookCubit() : super(AppInitialState());
  final SupabaseClient supabase = Supabase.instance.client;

  /// Upload book
  Future<void> uploadBook({
    required String title,
    required String author,
    required String desc,
    required String state,
    required String price,
    required String selectedCategory,
    required String selectedOffer,
    required File coverFirstImage,
    required File coverSecondImage,
  }) async {
    emit(AppLoadingState());

    try {
      /// رفع الصورة إلى Supabase Storage
      final fileName = DateTime.now().toIso8601String();
      await supabase.storage
          .from('book_covers')
          .upload(fileName, coverFirstImage);
      final imageUrl =
          supabase.storage.from('book_covers').getPublicUrl(fileName);

      ///
      final fileNameI = DateTime.now().toIso8601String();
      await supabase.storage
          .from('book_covers')
          .upload(fileNameI, coverSecondImage);
      final imageUrlI =
          supabase.storage.from('book_covers').getPublicUrl(fileNameI);

      final response = await supabase
          .from('users')
          .select('username')
          .eq('id', Supabase.instance.client.auth.currentUser!.id)
          .single();
      final userName = response['username'];

      final userImageResponse = await supabase
          .from('users')
          .select('image')
          .eq('id', Supabase.instance.client.auth.currentUser!.id)
          .single();
      final userImage = userImageResponse['image'];

      final userCityResponse = await supabase
          .from('users')
          .select('city')
          .eq('id', Supabase.instance.client.auth.currentUser!.id)
          .single();
      final userLocation = userCityResponse['city'];

      final userCountryResponse = await supabase
          .from('users')
          .select('country')
          .eq('id', Supabase.instance.client.auth.currentUser!.id)
          .single();
      final userCountry = userCountryResponse['country'];

      final favlocationResponse = await supabase
          .from('users')
          .select('fav_location')
          .eq('id', Supabase.instance.client.auth.currentUser!.id)
          .single();
      final favLocation = favlocationResponse['fav_location'];

      final urlResponse = await supabase
          .from('users')
          .select('location_url')
          .eq('id', Supabase.instance.client.auth.currentUser!.id)
          .single();
      final url = urlResponse['location_url'];

      final userCreateAtResponse = await supabase
          .from('users')
          .select('created_at')
          .eq('id', Supabase.instance.client.auth.currentUser!.id)
          .single();
      final userCreatedAt = userCreateAtResponse['created_at'];

      final book = BookModel(
        coverImageUrl: imageUrl,
        coverImageUrlI: imageUrlI,
        title: title,
        author: author,
        description: desc,
        condition: state,
        category: selectedCategory,
        offerType: selectedOffer,
        price: int.tryParse(price) ?? 0,
        userId: supabase.auth.currentUser!.id,
        userName: userName.toString(),
        userImage: userImage.toString(),
        userCity: userLocation.toString(),
        userCountry: userCountry.toString(),
        userCreatedAt: userCreatedAt.toString(),
        url: url.toString(),
        favLocation: favLocation.toString(),
      );
      // إضافة بيانات الكتاب إلى الجدول
      await supabase.from('books').insert([book.toJson()]);
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
