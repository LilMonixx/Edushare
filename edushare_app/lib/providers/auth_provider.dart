import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repository/auth_repository.dart';
import '../services/api_service.dart';

import 'dart:async';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  User? user;
  bool loading = false;

  StreamSubscription<User?>? _sub;

  Future<void> init() async {
    user = _repo.getCurrentUser();
    notifyListeners();

    _sub?.cancel();

    _sub = _repo.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  bool get isLoggedIn => user != null;



  Future<void> loginWithGoogle() async {
    loading = true;
    notifyListeners();

    try {
      final u = await _repo.signInWithGoogle();

      if (u != null) {
        user = u;

        final idToken = await u.getIdToken(true);

        final res = await ApiService.post("/login", {
          "id_token": idToken,
        });

        print("Backend login success: $res");
      }
    } catch (e) {
      print("Login error: $e");
    }

    loading = false;
    notifyListeners();
  }
  // ================= LOGOUT =================
  Future<void> logout() async {
    await _repo.signOut();
    user = null;
    notifyListeners();
  }
}