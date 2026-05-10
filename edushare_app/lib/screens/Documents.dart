import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/DocFile.dart';
import '../models/File_model.dart';
import '../services/FileService.dart';
import '../utils/open_attachment.dart';
import '../widgets/doc_item.dart';
import '../widgets/media_item.dart';


class MyDocumentsScreen extends StatefulWidget {
  const MyDocumentsScreen({super.key});

  @override
  State<MyDocumentsScreen> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
  List<AttachmentModel> attachments = [];

  List<AttachmentModel> filtered = [];

  bool loading = true;

  String search = "";

  int selectedTab = 0; // 0 = Files, 1 = Media



  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final data = await AttachmentService
        .getUserAttachments(user.uid);

    setState(() {

      attachments = data;

      filtered = data;

      loading = false;
    });
  }

  void onSearch(String value) {

    search = value;

    setState(() {

      filtered = attachments.where((e) {

        return e.fileName
            .toLowerCase()
            .contains(value.toLowerCase());

      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFiles = selectedTab == 0;

    final fileItems = filtered.where((e) {

      return e.fileType == "document";

    }).toList();

    final mediaItems = filtered.where((e) {

      return e.fileType == "image" ||
          e.fileType == "video";

    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header (GIỮ NGUYÊN)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Documents",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CD964),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.black),
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// Search + Filter (GIỮ NGUYÊN)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),

                      child: Row(
                        children: [

                          const Icon(Icons.search, color: Colors.grey),

                          const SizedBox(width: 8),

                          Expanded(
                            child: TextField(
                              onChanged: onSearch,

                              style: const TextStyle(color: Colors.white),

                              decoration: const InputDecoration(
                                hintText: "Search documents...",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.tune, color: Colors.grey),
                  )
                ],
              ),

              const SizedBox(height: 16),

              /// Tabs (GIỮ NGUYÊN)
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildTab("Files", 0, Icons.insert_drive_file),
                    _buildTab("Media", 1, Icons.image),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                   "${isFiles ? fileItems.length : mediaItems.length} items",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Text(
                    "Sort by Date",
                    style: TextStyle(color: Color(0xFF4CD964)),
                  )
                ],
              ),

              const SizedBox(height: 12),

              /// Grid (CHỈ SỬA ĐOẠN NÀY)
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isFiles
                      ? ListView.separated(
                    key: const ValueKey("list"),

                    itemCount: fileItems.length,

                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 10),

                    itemBuilder: (context, index) {

                      final item = fileItems[index];

                      return GestureDetector(

                        onTap: () {

                          openAttachment(
                            context: context,
                            fileType: item.fileType,
                            fileUrl: item.fileUrl,
                            fileName: item.fileName,
                          );
                        },

                        child: Container(

                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C1E),
                            borderRadius: BorderRadius.circular(16),
                          ),

                          child: Row(
                            children: [

                              const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red,
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [

                                    Text(
                                      item.fileName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "${item.fileSize} bytes",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : GridView.builder(
                    key: const ValueKey("grid"),
                    itemCount: mediaItems.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) {
                      final item = mediaItems[index];

                      return GestureDetector(

                        onTap: () {

                          openAttachment(
                            context: context,
                            fileType: item.fileType,
                            fileUrl: item.fileUrl,
                            fileName: item.fileName,
                          );
                        },

                        child: ClipRRect(

                          borderRadius: BorderRadius.circular(18),

                          child: Stack(
                            fit: StackFit.expand,

                            children: [

                              Image.network(
                                item.fileUrl,
                                fit: BoxFit.cover,
                              ),

                              if (item.fileType == "video")
                                const Center(
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Tab giữ nguyên
  Widget _buildTab(String title, int index, IconData icon) {
    bool isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4CD964) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isSelected ? Colors.black : Colors.grey, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}