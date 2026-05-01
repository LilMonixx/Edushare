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


  List<Question> searchResults = [];
  bool searching = false;
  bool hasMoreSearch = true;

  String? searchLastId;
  String currentKeyword = "";

  String? selectedSubject;


  Future<void> search(String keyword, {String? subject}) async {
    currentKeyword = keyword.trim();
    selectedSubject = subject;

    searchResults.clear();
    searchLastId = null;
    hasMoreSearch = true;

    notifyListeners();
    await loadMoreSearch();
  }

  Future<void> loadMoreSearch() async {
    if (searching || !hasMoreSearch) return;

    searching = true;
    notifyListeners();

    try {
      final data = await _repo.searchQuestions(
        keyword: currentKeyword,
        subject: selectedSubject, // 👈 THÊM CÁI NÀY
        limit: 10,
        lastId: searchLastId,
      );

      if (data.isEmpty) {
        hasMoreSearch = false;
      } else {
        final newItems = data.map((e) {
          return Question.fromMap(e, e["postId"]);
        }).toList();

        if (newItems.isNotEmpty) {
          searchResults.addAll(newItems);
          searchLastId = newItems.last.id;
        } else {
          hasMoreSearch = false;
        }
      }
    } catch (e) {
      print("Search error: $e");
    }

    searching = false;
    notifyListeners();
  }

}