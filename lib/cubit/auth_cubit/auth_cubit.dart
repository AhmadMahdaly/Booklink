import 'dart:developer';

import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/screens/navigation_bar/navigation_bar.dart';
import 'package:biblio/screens/select_your_location_screen.dart';
import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:bloc/bloc.dart';
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
    required BuildContext context,
  }) async {
    emit(AppLoadingState());
    try {
      await user.auth.signInWithPassword(email: email, password: password);

      emit(AppSuccessState());
    } on AuthException catch (e) {
      log(e.toString());
      if (e.message ==
          'ClientException: Connection closed before full header was received') {
        showSnackBar(context, 'قد تكون هناك مشكلة في اتصال الإنترنت');
      }
      if (e.message ==
          'HandshakeException: Connection terminated during handshake') {
        showSnackBar(context, 'قد تكون هناك مشكلة في اتصال الإنترنت');
      }
      emit(AppErrorState(e.message));
    } catch (e) {
      log(e.toString());
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
    } on AuthException catch (e) {
      log(e.toString());
      if (e.message ==
          'ClientException: Connection closed before full header was received') {
        await signOut(context);
      }
      emit(AppErrorState(e.message));
    } catch (e) {
      log(e.toString());
      emit(AppErrorState(e.toString()));
    }
  }

  Future<void> signOut(BuildContext context) async {
    emit(AppLoadingState());
    try {
      await user.auth.signOut();
      emit(AppSuccessState());
    } on AuthException catch (e) {
      log(e.toString());
      if (e.message.contains(
        'Connection reset by peer',
      )) {
        showSnackBar(context, 'قد تكون هناك مشكلة في اتصال الإنترنت');
      }
      if (e.message.contains(
        'Connection closed before full header was received',
      )) {
        showSnackBar(context, 'قد تكون هناك مشكلة في اتصال الإنترنت');
      }
      if (e.message.contains(
        'Connection terminated during handshake',
      )) {
        showSnackBar(context, 'قد تكون هناك مشكلة في اتصال الإنترنت');
      }
      emit(AppErrorState(e.message));
    } catch (e) {
      log(e.toString());
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
        emit(AppErrorState('حدث خطأ ما'));
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
    } on AuthException catch (e) {
      log(e.toString());
      if (e.message.contains(
        'Connection reset by peer',
      )) {
        showSnackBar(context, 'قد تكون هناك مشكلة في اتصال الإنترنت');
      }
      if (e.message.contains(
        'Connection closed before full header was received',
      )) {
        showSnackBar(context, 'قد تكون هناك مشكلة في اتصال الإنترنت');
      }
      if (e.message.contains(
        'Connection terminated during handshake',
      )) {
        showSnackBar(context, 'قد تكون هناك مشكلة في اتصال الإنترنت');
      }
      emit(AppErrorState(e.message));
      return AuthResponse();
    } catch (e) {
      log(e.toString());
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
        emit(AppErrorState('حدث خطأ ما'));
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
    } on PostgrestException catch (e) {
      if (e.message ==
          'duplicate key value violates unique constraint "users_id_key"') {
        showSnackBar(
          context,
          'هذا الحساب مسجل بالفعل أو أن البيانات غير صحيحة',
        );
      }
      emit(AppErrorState(e.message));
      return AuthResponse();
    } on AuthException catch (e) {
      log(e.toString());
      if (e.message.contains(
        'Connection reset by peer',
      )) {
        showSnackBar(context, 'قد تكون هناك مشكلة في اتصال الإنترنت');
      }
      if (e.message.contains(
        'Connection closed before full header was received',
      )) {
        showSnackBar(context, 'قد تكون هناك مشكلة في اتصال الإنترنت');
      }
      if (e.message.contains(
        'Connection terminated during handshake',
      )) {
        showSnackBar(context, 'قد تكون هناك مشكلة في اتصال الإنترنت');
      }
      emit(AppErrorState(e.message));
      return AuthResponse();
    } catch (e) {
      log(e.toString());
      emit(AppErrorState(e.toString()));
      return AuthResponse();
    }
  }
}
