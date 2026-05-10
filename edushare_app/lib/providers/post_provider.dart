import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repository/post_repository.dart';
import '../services/upload_file.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _repo = PostRepository();

  bool loading = false;

  Future<bool> createPost({
    required String content,
    required String subject,
    required List<XFile> images,
    required List<XFile> files,
  }) async {
    try {
      loading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final idToken = await user.getIdToken(true);
      if (idToken == null) return false;

      /// 🔥 UPLOAD FILES TRƯỚC
      final attachments = await uploadAttachments(images, files);

      /// 🔥 SEND TO BACKEND
      await _repo.createPost(
        idToken: idToken,
        content: content,
        subject: subject,
        attachments: attachments,
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