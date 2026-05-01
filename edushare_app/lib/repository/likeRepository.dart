import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class LikeRepository {
  final baseUrl = "http://10.0.2.2:8000"; // emulator

  Future<Map<String, dynamic>> toggleLike(String postId) async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();

    final res = await http.post(
      Uri.parse("$baseUrl/like-post"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_token": token,
        "postId": postId,
      }),
    );

    return jsonDecode(res.body);
  }

  Future<int> getLikeCount(String postId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/like-count/$postId"),
    );

    return jsonDecode(res.body)["count"];
  }

  Future<bool> checkLiked(String postId) async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();

    final res = await http.post(
      Uri.parse("$baseUrl/check-liked"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_token": token,
        "postId": postId,
      }),
    );

    return jsonDecode(res.body)["liked"];
  }
}