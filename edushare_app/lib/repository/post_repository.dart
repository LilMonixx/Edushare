import '../services/api_service.dart';

class PostRepository {
  Future<Map<String, dynamic>> createPost({
    required String idToken,
    required String content,
    required String subject,
    required List<Map<String, dynamic>> attachments,
  }) async {
    final res = await ApiService.post("/create-post", {
      "id_token": idToken,
      "content": content,
      "subject": subject,
      "attachments": attachments,
    });

    return res;
  }
}