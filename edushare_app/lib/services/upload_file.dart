import 'package:camera/camera.dart';
import 'dart:io';

import '../services/cloudinary_service.dart';

String detectFileType(String fileName) {
  final ext = fileName.toLowerCase().split('.').last;

  const imageExt = ['jpg', 'jpeg', 'png', 'webp', 'gif'];
  const videoExt = ['mp4', 'mov', 'mkv', 'avi'];
  const docExt = [
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'zip',
    'rar'
  ];

  if (imageExt.contains(ext)) return "image";
  if (videoExt.contains(ext)) return "video";
  if (docExt.contains(ext)) return "document";

  return "document";
}

Future<List<Map<String, dynamic>>> uploadAttachments(
    List<XFile> images,
    List<XFile> files,
    ) async {
  List<Map<String, dynamic>> result = [];

  final allFiles = [...images, ...files];

  for (final f in allFiles) {
    final file = File(f.path);

    final url = await CloudinaryService.uploadFile(file);

    result.add({
      "file_url": url,
      "file_name": f.name,
      "file_type": detectFileType(f.name), // 🔥 FIX HERE
      "file_size": await file.length(),
    });
  }

  return result;
}