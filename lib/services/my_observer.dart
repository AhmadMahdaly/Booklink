import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class MyObserver implements BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    log('onChange: $change');
  }

  @override
  void onClose(BlocBase bloc) {
    log('onClose: $bloc');
  }

  @override
  void onCreate(BlocBase bloc) {
    log('onCreate: $bloc');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError: $error');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {}

  @override
  void onTransition(Bloc bloc, Transition transition) {}
}
