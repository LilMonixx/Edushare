import 'package:flutter/material.dart';

class QuizProgress extends StatelessWidget {
  final int total;
  final List<int> selectedAnswers;
  final Color primary;

  const QuizProgress({
    super.key,
    required this.total,
    required this.selectedAnswers,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final done = selectedAnswers[i] != -1;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            height: 6,
            decoration: BoxDecoration(
              color: done ? primary : Colors.white10,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        );
      }),
    );
  }
}