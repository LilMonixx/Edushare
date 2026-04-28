import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/SplashScreen.dart';
import '../screens/login.dart';
import 'auth_provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.isLoggedIn) {
      return SplashScreen();
    }

    return const StudyShareScreen();
  }
}