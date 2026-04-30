import 'package:edushare_app/widgets/tag.dart';
import 'package:flutter/material.dart';
import '../models/Question.dart'; // 👈 thêm

class QuestionCard extends StatelessWidget {
  final Question question; // 👈 thay toàn bộ params
  final VoidCallback? onTap; // 👈 để handle click

  const QuestionCard({
    required this.question,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // 👈 thêm để bắt tap
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

            /// USER
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white10,
                  child: Text(question.name.substring(0, 2)), // 👈 initials
                ),
                const SizedBox(width: 12),

                Text(
                  question.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),

                const Icon(Icons.access_time,
                    size: 14, color: Colors.white38),
                const SizedBox(width: 4),

                Text(
                  question.time,
                  style: const TextStyle(color: Colors.white38),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// QUESTION
            Text(
              question.content, // 👈 đổi
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),

            /// TAGS
            Row(
              children: [
                TagWidget(text: question.tag, isHot: false), // 👈 fix
                if (question.isHot) ...[
                  const SizedBox(width: 8),
                  const TagWidget(text: "Hot", isHot: true),
                ]
              ],
            ),

            const SizedBox(height: 12),

            const Divider(color: Colors.white10),

            const SizedBox(height: 8),

            /// FOOTER
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline,
                    size: 18, color: Colors.white54),
                const SizedBox(width: 6),
                Text("${question.answers} answers",
                    style: const TextStyle(color: Colors.white54)),

                const SizedBox(width: 20),

                const Icon(Icons.thumb_up_outlined,
                    size: 18, color: Colors.white54),
                const SizedBox(width: 6),
                Text("${question.likes} likes",
                    style: const TextStyle(color: Colors.white54)),
              ],
            )
          ],
        ),
      ),
    );
  }
}