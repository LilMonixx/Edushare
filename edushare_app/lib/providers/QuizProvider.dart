import 'package:flutter/material.dart';
import '../repository/quiz_repository.dart';
import 'dart:io';

class QuizProvider extends ChangeNotifier {
  final QuizRepository repository;

  QuizProvider(this.repository);

  bool loading = false;
  List<dynamic> quizData = [];
  String? error;

  Future<void> generateQuiz({
    required File file,
    required String title,
    required int count,
    required String difficulty,
    required List<String> types,
  }) async {

    loading = true;
    error = null;
    notifyListeners();

    try {
      final result = await repository.generateQuiz(
        file: file,
        title: title,
        count: count,
        difficulty: difficulty,
        types: types,
      );

      // 🔥 FIX: đảm bảo format giống test
      quizData = List<Map<String, dynamic>>.from(result);

    } catch (e) {
      error = e.toString();
      quizData = [];
    }

    loading = false;
    notifyListeners();
  }
}