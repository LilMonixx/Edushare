import '../services/api_service.dart';

class QuestionRepository {
  Future<List<dynamic>> fetchQuestions({
    int limit = 10,
    String? lastId,
  }) async {
    final res = await ApiService.get(
      "/posts",
      query: {
        "limit": limit.toString(),
        if (lastId != null && lastId.isNotEmpty)
          "lastId": lastId,
      },
    );

    return res["data"];
  }
}