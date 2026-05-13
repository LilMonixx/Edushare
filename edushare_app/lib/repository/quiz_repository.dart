import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class QuizRepository {
  final String baseUrl = "http://10.0.2.2:5678/webhook/ai-quiz";

  Future<List<dynamic>> generateQuiz({
    required File file,
    required String title,
    required int count,
    required String difficulty,
    required List<String> types,
  }) async {

    final request = http.MultipartRequest("POST", Uri.parse(baseUrl));

    request.files.add(
      await http.MultipartFile.fromPath("file", file.path),
    );

    request.fields["title"] = title;
    request.fields["count"] = count.toString();
    request.fields["difficulty"] = difficulty;
    request.fields["types"] = jsonEncode(types);

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print("RAW RESPONSE: $body");

    final json = jsonDecode(body);

    // ✅ GIỐNG FILE TEST CỦA BẠN
    final raw = (json["data"] ?? []) as List;

    final formatted = raw.map((item) {

      final options = List<String>.from(item["options"]);

      return {
        "question": item["question"],
        "answers": options,
        "correct": options.indexOf(item["answer"]),
      };

    }).toList();

    return formatted;
  }
}