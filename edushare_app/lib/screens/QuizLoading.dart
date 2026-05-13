import 'package:flutter/material.dart';

import 'Quiz_test_screen.dart';
class QuizGeneratingScreen extends StatefulWidget {
  const QuizGeneratingScreen({super.key});

  @override
  State<QuizGeneratingScreen> createState() =>
      _QuizGeneratingScreenState();
}

class _QuizGeneratingScreenState
    extends State<QuizGeneratingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;


  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: controller,
              child: SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                          const Color(0xff103A18),
                          width: 6,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 120,
                      height: 120,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 6,
                        valueColor:
                        const AlwaysStoppedAnimation(
                          Color(0xff4CD137),
                        ),
                        backgroundColor:
                        Colors.transparent,
                      ),
                    ),

                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 46),

            const Text(
              "Generating Quiz",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "AI is analyzing your document and\ncreating questions...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 20,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


