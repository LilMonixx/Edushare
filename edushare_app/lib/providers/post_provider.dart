import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repository/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _repo = PostRepository();

  bool loading = false;

  Future<bool> createPost({
    required String content,
    required String subject,
  }) async {
    try {
      loading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      print("USER: $user");

      if (user == null) return false;

      // 🔥 FIX 1: force refresh + xử lý null
      final idToken = await user.getIdToken(true);

      if (idToken == null) {
        print("Token is null");
        return false;
      } else {
        print("istoken: $idToken" );
      }

      await _repo.createPost(
        idToken: idToken,
        content: content,
        subject: subject,
      );

      return true;
    } catch (e) {
      print("Create post error: $e");
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}