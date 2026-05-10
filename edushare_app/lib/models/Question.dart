import 'dart:convert';

import 'attachment.dart';

class Question {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;

  final String content;
  final String subject;
  final String status;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Attachment> attachments;

  Question({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.subject,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.attachments,
  });

  factory Question.fromMap(Map<String, dynamic> map, String docId) {
    return Question(
      id: docId,

      userId: map["userId"] ?? "",

      // 🔥 NEW FROM BACKEND
      userName: map["authorName"] ?? "Unknown",
      userAvatar: map["authorAvatar"],

      content: map["content"] ?? "",
      subject: map["subject"] ?? "",
      status: map["status"] ?? "",

      // 🔥 FIX DATE SAFE
      createdAt: map["createdAt"] != null
          ? DateTime.tryParse(map["createdAt"].toString())
          : null,

      updatedAt: map["updatedAt"] != null
          ? DateTime.tryParse(map["updatedAt"].toString())
          : null,
      attachments: (map["attachments"] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e))
          .toList() ?? [],
    );
  }
}