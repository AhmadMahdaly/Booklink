import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetUserQtyBooksCubit extends Cubit<AppStates> {
  GetUserQtyBooksCubit() : super(AppInitialState());
  final supabase = Supabase.instance.client;
  List<dynamic> qtyBooks = [];

  Future<void> getUserQTYbooks(String userId, BuildContext context) async {
    emit(AppLoadingState());
    try {
      final response = await supabase
          .from('books')
          // ignore: avoid_redundant_argument_values
          .select('*')
          .eq('user_id', userId);
      if (response != null) {
        qtyBooks = List<Map<String, dynamic>>.from(response);
      }
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
}
