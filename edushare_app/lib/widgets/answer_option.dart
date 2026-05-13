import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {

  final String text;

  final String label;

  final bool selected;

  final bool isCorrect;

  final bool showResult;

  final VoidCallback onTap;

  final Color primary;

  const AnswerOption({
    super.key,
    required this.text,
    required this.label,
    required this.selected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {

    Color border = Colors.white10;

    Color bgColor = Colors.transparent;

    if (showResult) {

      if (isCorrect) {

        border = Colors.green;

        bgColor = Colors.green.withOpacity(0.15);

      } else if (selected && !isCorrect) {

        border = Colors.red;

        bgColor = Colors.red.withOpacity(0.15);
      }

    } else if (selected) {

      border = primary;
    }

    return GestureDetector(

      onTap: showResult ? null : onTap,

      child: Container(

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: border),

          color: bgColor,
        ),

        child: Row(

          children: [

            Container(

              width: 42,
              height: 42,

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                color: selected
                    ? primary
                    : Colors.white10,
              ),

              child: Center(

                child: Text(

                  label,

                  style: TextStyle(

                    color: selected
                        ? Colors.black
                        : Colors.white,

                    fontWeight: FontWeight.w700,

                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(

              child: Text(

                text,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.4,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}