import 'package:flutter/material.dart';
import '../models/Question.dart';
import '../repository/question_repository.dart';

class QuestionProvider extends ChangeNotifier {
  final QuestionRepository _repo = QuestionRepository();

  List<Question> questions = [];
  bool loading = false;
  bool hasMore = true;
  DateTime? lastTime;

  String? lastId;

  Future<void> loadInitial() async {
    questions.clear();
    lastId = null;
    hasMore = true;

    notifyListeners(); // 👈 QUAN TRỌNG

    await loadMore();
  }

  Future<void> loadMore() async {
    if (loading || !hasMore) return;

    loading = true;
    notifyListeners();

    try {
      final data = await _repo.fetchQuestions(
        limit: 10,
        lastId: lastId,
      );

      if (data.isEmpty) {
        hasMore = false;
      } else {
        final newItems = data.map((e) {
          return Question.fromMap(e, e["postId"]);
        }).toList();

        if (newItems.isNotEmpty) {
          lastId = newItems.last.id;
          questions.addAll(newItems);
        }

      }
    } catch (e) {
      print("Load questions error: $e");
    }

    loading = false;
    notifyListeners();
  }
}