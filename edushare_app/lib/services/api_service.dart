import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const baseUrl = "http://10.0.2.2:8000";

  static Future<Map<String, dynamic>> post(
      String path,
      Map<String, dynamic> body,
      ) async {
    final res = await http.post(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception("API Error: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final res = await http.get(
      Uri.parse("$baseUrl$path"),
    );

    if (res.statusCode != 200) {
      throw Exception("API Error: ${res.body}");
    }

    return jsonDecode(res.body);
  }
}