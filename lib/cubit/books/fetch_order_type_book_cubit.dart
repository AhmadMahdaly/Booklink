import 'package:biblio/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchOrderTypeBookCubit extends Cubit<AppStates> {
  FetchOrderTypeBookCubit() : super(AppInitialState());
  SupabaseClient supabase = Supabase.instance.client;
  List<String> offerTypes = [];
  String? selectedOffer;

  /// Fetch order type
  Future<void> fetchOrderType(BuildContext context) async {
    emit(AppLoadingState());
    final cubit = context.read<FetchOrderTypeBookCubit>();

    try {
      final response = await supabase.from('offer_type').select('type');
      offerTypes = response.map((e) => e['type'] as String).toList();
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
