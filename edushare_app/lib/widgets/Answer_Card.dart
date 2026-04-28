import 'package:flutter/material.dart';

import '../models/Answer.dart';

class AnswerCard extends StatelessWidget {
  final Answer answer;

  const AnswerCard({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: answer.isAccepted
            ? const Color(0xFF062A1C)
            : const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: answer.isAccepted
            ? Border.all(color: const Color(0xFF1ED760))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF1C1C1E),
                child: Text(answer.avatar),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  answer.author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              if (answer.isExpert) _badge("Expert"),
              if (answer.isExpert) const SizedBox(width: 6),
              if (answer.isAccepted) _acceptedBadge(),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            answer.time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),

          const SizedBox(height: 12),

          /// CONTENT
          Text(
            answer.content,
            style: const TextStyle(height: 1.5),
          )
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