import 'package:flutter/material.dart';

class QuizHeader extends StatelessWidget {
  const QuizHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.arrow_back_ios_new, color: Colors.white),
        SizedBox(width: 10),
        Text(
          "Quiz",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ],
    );
  }
}