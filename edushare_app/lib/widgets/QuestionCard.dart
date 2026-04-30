import 'package:flutter/material.dart';
import '../models/Question.dart';

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