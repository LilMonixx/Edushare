import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/DocFile.dart';
import '../services/FileService.dart';
import 'package:http/http.dart' as http;

import 'DeviceUploadScreen.dart';

class SelectDocumentScreen extends StatefulWidget {
  const SelectDocumentScreen({super.key});

  @override
  State<SelectDocumentScreen> createState() =>
      _SelectDocumentScreenState();
}

class _SelectDocumentScreenState
    extends State<SelectDocumentScreen> {

  bool loading = true;

  List<DocFile> docs = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  /// note
  Future<File> downloadFile(String url, String name) async {

    final response = await http.get(Uri.parse(url));

    final dir = await getTemporaryDirectory();

    final file = File("${dir.path}/$name");

    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  Future<void> loadData() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {

      setState(() {
        loading = false;
      });

      return;
    }

    final attachments =
    await AttachmentService
        .getUserAttachments(user.uid);

    /// CHỈ LOAD FILE TÀI LIỆU
    final documentAttachments =
    attachments.where((file) {

      final type =
      file.fileType.toLowerCase();

      return
        type.contains("pdf") ||
            type.contains("doc") ||
            type.contains("docx") ||
            type.contains("txt") ||
            type.contains("ppt") ||
            type.contains("pptx");

    }).toList();

    final loadedDocs =
    documentAttachments.map((file) {

      return DocFile(

        id: file.attachmentId,

        title: file.fileName,

        size: formatFileSize(
          file.fileSize,
        ),

        time: "Recently",

        path: file.fileUrl,

        icon: getFileIcon(
          file.fileType,
        ),
      );
    }).toList();

    setState(() {

      docs = loadedDocs;

      loading = false;
    });
  }

  String formatFileSize(int bytes) {

    if (bytes < 1024) {
      return "$bytes B";
    }

    if (bytes < 1024 * 1024) {

      return
        "${(bytes / 1024).toStringAsFixed(1)} KB";
    }

    return
      "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }

  IconData getFileIcon(String type) {

    final t = type.toLowerCase();

    if (t.contains("pdf")) {
      return Icons.picture_as_pdf;
    }

    if (t.contains("doc")) {
      return Icons.description;
    }

    if (t.contains("ppt")) {
      return Icons.slideshow;
    }

    if (t.contains("txt")) {
      return Icons.notes;
    }

    return Icons.insert_drive_file;
  }

  Color getFileColor(IconData icon) {

    if (icon == Icons.picture_as_pdf) {
      return Colors.red;
    }

    if (icon == Icons.description) {
      return Colors.blue;
    }

    if (icon == Icons.slideshow) {
      return Colors.orange;
    }

    if (icon == Icons.notes) {
      return Colors.green;
    }

    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: SafeArea(

        child: Padding(

          padding:
          const EdgeInsets.symmetric(
            horizontal: 16,
          ),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              /// HEADER
              Row(

                children: [

                  GestureDetector(

                    onTap: () =>
                        Navigator.pop(context),

                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(

                    "Select Document",

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(

                "Choose a document to generate quiz from",

                style: TextStyle(
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(

                child: loading

                    ? const Center(
                  child:
                  CircularProgressIndicator(
                    color: Color(0xff4CD137),
                  ),
                )

                    : docs.isEmpty

                    ? const Center(
                  child: Text(
                    "No documents found",
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                )

                    : ListView.separated(

                  itemCount: docs.length,

                  separatorBuilder:
                      (_, __) =>
                  const SizedBox(
                    height: 12,
                  ),

                  itemBuilder:
                      (context, index) {

                    final doc = docs[index];

                    final color =
                    getFileColor(
                      doc.icon,
                    );

                    return GestureDetector(

                      onTap: () async {

                        try {

                          final downloadedFile =
                          await downloadFile(
                            doc.path,
                            doc.title,
                          );

                          if (!mounted) return;

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) => DeviceUploadScreen(
                                initialFile: downloadedFile,
                              ),
                            ),
                          );

                        } catch (e) {

                          ScaffoldMessenger.of(context)
                              .showSnackBar(

                            SnackBar(
                              content: Text(
                                "Failed to load file: $e",
                              ),
                            ),
                          );
                        }
                      },

                      child: Container(

                        padding:
                        const EdgeInsets.all(16),

                        decoration: BoxDecoration(

                          color:
                          const Color(
                            0xFF111111,
                          ),

                          borderRadius:
                          BorderRadius.circular(
                            16,
                          ),

                          border: Border.all(
                            color:
                            Colors.white10,
                          ),
                        ),

                        child: Row(

                          children: [

                            Container(

                              padding:
                              const EdgeInsets.all(
                                10,
                              ),

                              decoration:
                              BoxDecoration(

                                color: color
                                    .withOpacity(
                                  0.2,
                                ),

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  10,
                                ),
                              ),

                              child: Icon(
                                doc.icon,
                                color: color,
                              ),
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  Text(

                                    doc.title,

                                    style:
                                    const TextStyle(

                                      color:
                                      Colors.white,

                                      fontWeight:
                                      FontWeight
                                          .w600,
                                    ),

                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Text(

                                    "${doc.size} · ${doc.time}",

                                    style:
                                    const TextStyle(

                                      fontSize: 12,

                                      color:
                                      Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(

                              Icons.chevron_right,

                              color:
                              Colors.white38,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}