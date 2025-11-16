import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/features/main_layout/main_layout.dart';
import 'package:biblio/features/select_your_location/select_your_location_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCubit extends Cubit<AppStates> {
  AuthCubit() : super(AppInitialState());
  SupabaseClient user = Supabase.instance.client;
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AppLoadingState());
    try {
      await user.auth.signInWithPassword(email: email, password: password);

      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(AppLoadingState());
    try {
      await user.auth.signUp(
        email: email,
        password: password,
        data: {'Display name': name},
      );
      await user.from('users').insert({
        // ربط المستخدم باستخدام UID
        'id': user.auth.currentUser!.id,
        'username': name,
        'email': email,
      });
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AppLoadingState());
    try {
      await user.auth.signOut();
      emit(AppSuccessState());
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }

  GoogleSignIn? googleUser;
  Future<AuthResponse> googleSignIn(
    BuildContext context,
  ) async {
    emit(AppLoadingState());
    try {
      final webClientId = dotenv.env['WEB_CLIENT_ID'] ?? '';
      final googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        emit(AppErrorState('WrongError'.tr()));
        return AuthResponse();
      }

      final response = await user.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      await user.from('users').select().eq(
            'email',
            googleUser.email,
          );
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const NavigationBarApp();
          },
        ),
      );
      emit(AppSuccessState());
      return response;
    } catch (e) {
      emit(AppErrorState(e.toString()));
      return AuthResponse();
    }
  }

  Future<AuthResponse> googleSignUp(
    BuildContext context,
  ) async {
    emit(AppLoadingState());
    try {
      final webClientId = dotenv.env['WEB_CLIENT_ID'] ?? '';
      final googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        emit(AppErrorState('WrongError'.tr()));
        return AuthResponse();
      }

      final response = await user.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      await user.from('users').insert({
        // ربط المستخدم باستخدام UID
        'id': user.auth.currentUser!.id,
        'username': googleUser.displayName,
        'email': googleUser.email,
        'image': googleUser.photoUrl,
      });
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const SelectYourLocationScreen();
          },
        ),
      );
      emit(AppSuccessState());
      return response;
    } catch (e) {
      emit(AppErrorState(e.toString()));
      return AuthResponse();
    }
  }
}
