import 'dart:convert';
import 'package:http/http.dart' as http;

class AiRepository {
  final String baseUrl = "http://10.0.2.2:5678/webhook/ai-chat";

  Future<String> sendMessage(String message) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": message}),
    );

    String body = res.body.trim();

    if (body.startsWith("=")) {
      body = body.substring(1);
    }

    try {
      final data = jsonDecode(body);
      return data["message"] ?? body;
    } catch (_) {
      return body;
    }
  }
}