import 'package:flutter/material.dart';
import '../models/Question.dart';
import 'pdf_thumnail.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final VoidCallback? onTap;

  const QuestionCard({
    required this.question,
    this.onTap,
    super.key,
  });

  String _formatTime(DateTime? time) {
    if (time == null) return "just now";
    final now = DateTime.now();
    final diff = now.difference(time).inMinutes;

    if (diff < 60) return "${diff}m ago";
    if (diff < 1440) return "${(diff / 60).round()}h ago";
    return "${time.day}/${time.month}/${time.year}";
  }

  Widget _buildAttachments() {

    if (question.attachments.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: question.attachments.length,
        itemBuilder: (context, index) {

          final att = question.attachments[index];

          /// ================= IMAGE =================
          if (att.fileType == "image") {

            return Container(
              margin: const EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  att.fileUrl,
                  width: 110,
                  height: 100,
                    fit: BoxFit.contain,
                ),
              ),
            );
          }

          /// ================= VIDEO =================
          if (att.fileType == "video") {

            return Container(
              width: 110,
              height: 100,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 42,
                ),
              ),
            );
          }

          /// ================= DOCUMENT =================

          return Container(
            width: 140,
            height: 200,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white10),
            ),
            clipBehavior: Clip.antiAlias,

            child: Column(
              children: [

                /// PDF PREVIEW
                Expanded(
                  child: PdfThumbnail(
                    url: att.fileUrl,
                  ),
                ),

                /// FILE NAME
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  color: Colors.black87,

                  child: Text(
                    att.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0B0F19),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= USER =================
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white10,
                  backgroundImage: question.userAvatar != null
                      ? NetworkImage(question.userAvatar!)
                      : null,
                  child: question.userAvatar == null
                      ? Text(
                    question.userName.isNotEmpty
                        ? question.userName[0].toUpperCase()
                        : "?",
                  )
                      : null,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    question.userName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  _formatTime(question.createdAt),
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ================= CONTENT =================
            Text(
              question.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),
            if (question.attachments.isNotEmpty) ...[
              //const SizedBox(height: 14),
              _buildAttachments(),
            ],

            const SizedBox(height: 12),

            /// ================= SUBJECT TAG =================
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1ED760).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                question.subject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF1ED760),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}