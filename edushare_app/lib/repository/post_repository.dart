import '../services/api_service.dart';

class PostRepository {
  Future<Map<String, dynamic>> createPost({
    required String idToken,
    required String content,
    required String subject,
  }) async {
    final res = await ApiService.post("/create-post", {
      "id_token": idToken,
      "content": content,
      "subject": subject,
    });

    return res;
  }
}