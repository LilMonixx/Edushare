import 'package:flutter/material.dart';
class Answer {
  final String author;
  final String avatar;
  final String time;
  final String content;
  final bool isExpert;
  final bool isAccepted;

  Answer({
    required this.author,
    required this.avatar,
    required this.time,
    required this.content,
    this.isExpert = false,
    this.isAccepted = false,
  });
}