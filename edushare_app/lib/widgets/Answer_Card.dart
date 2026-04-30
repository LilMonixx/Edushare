import 'package:flutter/material.dart';

import '../models/Answer.dart';

class AnswerCard extends StatelessWidget {
  final dynamic answer;

  const AnswerCard({super.key, required this.answer});

  String formatTime(dynamic time) {
    if (time == null) return "just now";

    DateTime date;

    if (time is String) {
      date = DateTime.parse(time);
    } else if (time is int) {
      date = DateTime.fromMillisecondsSinceEpoch(time);
    } else {
      return "just now";
    }

    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: answer["userAvatar"] != ""
                    ? NetworkImage(answer["userAvatar"])
                    : null,
                child: answer["userAvatar"] == ""
                    ? Text(answer["userName"][0])
                    : null,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answer["userName"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      formatTime(answer["createdAt"]),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            answer["content"],
            style: const TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }


  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _acceptedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1ED760),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.check, size: 12, color: Colors.black),
          SizedBox(width: 4),
          Text(
            "Accepted",
            style: TextStyle(fontSize: 11, color: Colors.black),
          )
        ],
      ),
    );
  }
}