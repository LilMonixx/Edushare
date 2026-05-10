import 'dart:io';

import 'package:dio/dio.dart';

import 'api_service.dart';

class CloudinaryService {

  static Future<String> uploadFile(File file) async {

    final ext = file.path
        .split('.')
        .last
        .toLowerCase();

    /// detect resource type
    String resourceType = "image";

    if ([
      "mp4",
      "mov",
      "avi",
      "mkv"
    ].contains(ext)) {

      resourceType = "video";

    } else if ([
      "pdf",
      "doc",
      "docx",
      "xls",
      "xlsx",
      "ppt",
      "pptx",
      "zip",
      "rar"
    ].contains(ext)) {

      resourceType = "raw";
    }

    /// xin signature
    final signData = await ApiService.get(
      "/cloudinary-signature",
    );

    final formData = FormData.fromMap({

      "file": await MultipartFile.fromFile(file.path),

      "api_key": signData["apiKey"],

      "timestamp":
      signData["timestamp"].toString(),

      "signature": signData["signature"],

      "folder": "posts",
    });

    try {

      final response = await Dio().post(

        "https://api.cloudinary.com/v1_1/"
            "${signData["cloudName"]}/"
            "$resourceType/upload",

        data: formData,
      );

      print("CLOUDINARY RESPONSE: ${response.data}");

      return response.data["secure_url"];

    } catch (e) {

      print("❌ CLOUDINARY ERROR: $e");

      throw Exception("Upload failed");
    }
  }
}