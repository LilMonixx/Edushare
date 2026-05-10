import 'package:flutter/material.dart';

class Subject extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const Subject(this.title, this.icon, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // 👈 FIX CHÍNH
        children: [
          CircleAvatar(
            radius: 20, // 👈 nên set luôn cho chắc
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6), // 👈 giảm từ 10 → 6
          Text(
            title,
            style: const TextStyle(fontSize: 12), // 👈 giảm nhẹ
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
