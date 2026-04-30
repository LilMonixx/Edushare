import 'package:flutter/material.dart';
import '../repository/AnswerRepository.dart';

class AnswerProvider extends ChangeNotifier {
  final AnswerRepository _repo = AnswerRepository();

  bool loading = false;
  List answers = [];

  Future<void> createAnswer({
    required String postId,
    required String content,
    required String userId,
    required String userName,
    String? userAvatar,
  }) async {
    loading = true;
    notifyListeners();

    try {
      await _repo.createAnswer(
        postId: postId,
        content: content,
        userId: userId,
        userName: userName,
        userAvatar: userAvatar,
      );


      await loadAnswers(postId);
    } catch (e) {
      print("createAnswer error: $e");
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadAnswers(String postId) async {
    loading = true;
    notifyListeners();

    try {
      final data = await _repo.getAnswers(postId);
      answers = data;
    } catch (e) {
      print("loadAnswers error: $e");
    }

    loading = false;
    notifyListeners();
  }


  void clear() {
    answers = [];
    notifyListeners();
  }
}