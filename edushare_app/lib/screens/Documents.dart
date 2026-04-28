import 'package:flutter/material.dart';

import '../models/DocFile.dart';
import '../widgets/doc_item.dart';
import '../widgets/media_item.dart';


class MyDocumentsScreen extends StatefulWidget {
  const MyDocumentsScreen({super.key});

  @override
  State<MyDocumentsScreen> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
  int selectedTab = 1; // 0 = Files, 1 = Media

  /// DATA
  List<DocFile> docs = [
    DocFile(
      id: "1",
      title: "Report.pdf",
      size: "2MB",
      time: "10:30",
      path: "/storage/docs/report.pdf",
    ),
    DocFile(
      id: "2",
      title: "Notes.txt",
      size: "500KB",
      time: "Yesterday",
      path: "/storage/docs/notes.txt",
    ),
  ];

  final List<MediaFile> medias = [
    MediaFile(
        title: "Lesson Video",
        size: "45MB",
        time: "1h ago",
        isVideo: true,
        duration: "12:34"),
    MediaFile(
        title: "Image 1",
        size: "3MB",
        time: "2h ago",
        isVideo: false),
    MediaFile(
        title: "Clip",
        size: "20MB",
        time: "Yesterday",
        isVideo: true,
        duration: "05:12"),
    MediaFile(
        title: "Photo",
        size: "2MB",
        time: "3 days ago",
        isVideo: false),
    MediaFile(
        title: "Video 2",
        size: "60MB",
        time: "Last week",
        isVideo: true,
        duration: "09:20"),
    MediaFile(
        title: "Image 2",
        size: "4MB",
        time: "Today",
        isVideo: false),
  ];

  @override
  Widget build(BuildContext context) {
    final isFiles = selectedTab == 0;

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
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            "Search documents...",
                            style: TextStyle(color: Colors.grey),
                          )
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
                    "${isFiles ? docs.length : medias.length} items",
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
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return DocItem(doc: docs[index]);
                    },
                  )
                      : GridView.builder(
                    key: const ValueKey("grid"),
                    itemCount: medias.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) {
                      return MediaItem(media: medias[index]);
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