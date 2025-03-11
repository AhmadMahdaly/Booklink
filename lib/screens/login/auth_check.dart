import 'package:biblio/screens/navigation_bar/navigation_bar.dart';
import 'package:biblio/screens/no_network_screen.dart';
import 'package:biblio/screens/onboard/onboard_screen.dart';
import 'package:biblio/utils/controller/connectivity_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});
  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final supabase = Supabase.instance.client;
  /*Retrieve the current user and assign the value to the _user variable. Notice that
this page sets up a listener on the user's auth state using onAuthStateChange. */
  User? _user;
  @override
  void initState() {
    _getAuth();
    super.initState();
  }

  Future<void> _getAuth() async {
    if (mounted) {
      setState(() {
        _user = supabase.auth.currentUser;
      });
    }
    supabase.auth.onAuthStateChange.listen((event) {
      if (mounted) {
        setState(() {
          _user = event.session?.user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// في حالة وجود انترنت متصل
    return ValueListenableBuilder(
      valueListenable: ConnectivityController.instance.isConnected,
      builder: (_, value, __) {
        if (value) {
          ///
          return _user == null
              ? const OnboardScreen()
              : const NavigationBarApp();
        } else {
          /// في حالة عدم وجود انترنت متصل
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'No NetWork',
            home: NoNetworkScreen(),
          );
        }
      },
    );
  }
}
