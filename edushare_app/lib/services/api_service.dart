import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const baseUrl = "http://192.168.4.8:8000";
  //static const baseUrl = "http://172.20.10.2:8000";

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    print('🟢 ApiService POST $path');
    print('🟢 Body: $body');

    final res = await http.post(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 10));

    print('🟢 Response status: ${res.statusCode}');
    print('🟢 Response body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception("API Error: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final cleanQuery = query?..removeWhere((key, value) => value == null);

    final uri = Uri.parse("$baseUrl$path").replace(queryParameters: cleanQuery);

    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    print('🟢 ApiService GET $path');
    print('🟢 Query: $cleanQuery');

    final res = await http.get(
      uri,
      headers: {if (token != null) "Authorization": "Bearer $token"},
    ).timeout(const Duration(seconds: 10));

    print('🟢 Response status: ${res.statusCode}');
    print('🟢 Response body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception("API Error: ${res.body}");
    }

    return jsonDecode(res.body);
  }
}
