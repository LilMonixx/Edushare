import 'package:flutter/material.dart';
class DocFile {
  final String id;
  final String title;
  final String size;
  final String time;
  final String path;
  final IconData icon;

  DocFile({
    required this.id,
    required this.title,
    required this.size,
    required this.time,
    required this.path,
    this.icon = Icons.insert_drive_file,
  });
}