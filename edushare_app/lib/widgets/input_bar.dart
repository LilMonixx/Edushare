import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF53F55B),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_file_rounded),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Ask me anything...",
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                ),
              ),
            ),
          ),
          const Icon(Icons.mic_none_rounded),
        ],
      ),
    );
  }
}