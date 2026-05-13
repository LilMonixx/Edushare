import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  final AnimationController controller;

  const TypingIndicator({
    super.key,
    required this.controller,
  });

  Widget buildDot(int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double animationValue = (controller.value - index * 0.2);

        if (animationValue < 0) animationValue += 1;

        double scale = 0.8;

        if (animationValue < 0.5) {
          scale = 0.8 + (animationValue * 0.8);
        } else {
          scale = 1.2 - ((animationValue - 0.5) * 0.8);
        }

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 9,
            height: 9,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: const BoxDecoration(
              color: Color(0xFF53F55B),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFF112A14),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Color(0xFF53F55B),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0B0B),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              buildDot(0),
              buildDot(1),
              buildDot(2),
            ],
          ),
        ),
      ],
    );
  }
}