import 'package:flutter/material.dart';
import '../repository/question_repository.dart';

class QuestionProvider extends ChangeNotifier {
  final QuestionRepository repo;

  QuestionProvider(this.repo);

  List<dynamic> questions = [];
  bool loading = false;
  bool isOffline = false;

  Future<void> load(bool isOnline) async {
    loading = true;
    notifyListeners();

    final data = await repo.getQuestions(isOnline);

    questions = data;
    isOffline = !isOnline;

    loading = false;
    notifyListeners();
  }
}