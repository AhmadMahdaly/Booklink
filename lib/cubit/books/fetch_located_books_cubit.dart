import 'package:biblio/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchLocatedBooksCubit extends Cubit<AppStates> {
  FetchLocatedBooksCubit() : super(AppInitialState());
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> books = [];
  // List<Map<String, dynamic>> countryBooks = [];

  Future<void> fetchLocatedBooks(BuildContext context) async {
    emit(AppLoadingState());
    final cubit = context.read<FetchLocatedBooksCubit>();
    try {
      String? user;
      if (Supabase.instance.client.auth.currentUser?.id == null) {
        user = null;
      } else {
        user = Supabase.instance.client.auth.currentUser?.id;
      }
      if (user != null) {
        final responsed =
            await supabase.from('users').select('city').eq('id', user).single();

        final city = responsed['city'] as String;
        final response = await supabase
            .from('books')
            // ignore: avoid_redundant_argument_values
            .select('*')
            .eq('city', city)
            .order('created_at', ascending: false);
        books = List<Map<String, dynamic>>.from(response);
      }

      emit(AppSuccessState());
    } catch (e) {
      if (!cubit.isClosed) {
        emit(AppErrorState(e.toString()));
      }
    }
  }
}
