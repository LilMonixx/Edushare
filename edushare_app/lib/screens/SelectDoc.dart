import 'package:flutter/material.dart';
import '../models/DocFile.dart';
import 'Quiz_set_up.dart';

class SelectDocumentScreen extends StatelessWidget {
  const SelectDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context), // ✅ FIX
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Select Document",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                "Choose a document to generate quiz from",
                style: TextStyle(color: Colors.white54),
              ),

              const SizedBox(height: 20),

              /// LIST FILE
              Expanded(
                child: ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = docs[index]; // 👈 doc nằm ở đây

                    return GestureDetector(
                      onTap: () {
                        /// ✅ CHUYỂN MÀN HÌNH
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizSetupScreen(doc: doc),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111111),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.description,
                                  color: Colors.red),
                            ),
                            const SizedBox(width: 12),

                            /// TEXT
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${doc.size} · ${doc.time}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(Icons.chevron_right,
                                color: Colors.white38),
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