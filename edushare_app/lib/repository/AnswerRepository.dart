import '../services/api_service.dart';

class AnswerRepository {

  Future<Map<String, dynamic>> createAnswer({
    required String postId,
    required String content,
    required String userId,
    required String userName,
    required String? userAvatar,
  }) async {
    final res = await ApiService.post("/answers", {
      "postId": postId,
      "content": content,
      "userId": userId,
      "userName": userName,
      "userAvatar": userAvatar,
    });



    return res;
  }

  Future<List<dynamic>> getAnswers(String postId) async {
    final res = await ApiService.get(
      "/getanswers",
      query: {"postId": postId},
    );


    print(res);

    // CASE 1: backend trả {data: [...]}
    if (res["data"] != null && res["data"] is List) {
      return List<dynamic>.from(res["data"]);
    }

    // CASE 2: backend trả sai format hoặc null
    return [];
  }
}