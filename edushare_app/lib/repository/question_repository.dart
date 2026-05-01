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

  Future<List<dynamic>> searchQuestions({
    required String keyword,
    String? subject,
    int limit = 10,
    String? lastId,
  }) async {
    final res = await ApiService.get(
      "/posts/search",
      query: {
        "q": keyword,
        "limit": limit.toString(),
        if (subject != null) "subject": subject, // 👈 THÊM
        if (lastId != null && lastId.isNotEmpty)
          "lastId": lastId,
      },
    );

    return res["data"];
  }


}