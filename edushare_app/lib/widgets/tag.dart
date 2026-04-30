import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final String text;
  final bool isHot;

  const TagWidget({
    super.key,
    required this.text,
    required this.isHot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isHot
            ? Colors.green.withOpacity(0.2)
            : Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isHot ? Colors.green : Colors.white70,
          fontSize: 12,
        ),
      ),
    );
  }
}