import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../screens/image_viewer_screen.dart';
import '../screens/pdf_viewer_screen.dart';
import '../screens/video_viewer_screen.dart';


Future<void> openAttachment({
  required BuildContext context,
  required String fileType,
  required String fileUrl,
  required String fileName,
}) async {
  /// IMAGE
  if (fileType == "image") {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageViewerScreen(
          imageUrl: fileUrl,
        ),
      ),
    );

    return;
  }
  if (fileType == "video") {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoViewerScreen(
          videoUrl: fileUrl,
        ),
      ),
    );

    return;
  }

  if (fileName.toLowerCase().endsWith(".pdf")) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerScreen(
          pdfUrl: fileUrl,
        ),
      ),
    );

    return;
  }
  /// DOCX / PPTX / XLSX
  try {

    final dir = await getTemporaryDirectory();

    final path = "${dir.path}/$fileName";

    await Dio().download(fileUrl, path);

    await OpenFilex.open(path);

  } catch (e) {

    debugPrint("OPEN FILE ERROR: $e");
  }
}