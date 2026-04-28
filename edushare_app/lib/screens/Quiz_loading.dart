import 'package:flutter/material.dart';

class AILoading extends StatefulWidget {
  const AILoading({super.key});

  @override
  State<AILoading> createState() => _AILoadingState();
}

class _AILoadingState extends State<AILoading>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF4CD964);
    const greenSoft = Color(0xFF7DFF9B);

    return Material(
      color: Colors.black.withOpacity(0.92),
      child: Center(
        child: SingleChildScrollView( // 👈 tránh overflow
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔥 LOADING CIRCLE
              AnimatedBuilder(
                animation: controller,
                builder: (_, __) {
                  return Transform.rotate(
                    angle: controller.value * 6.28,
                    child: SizedBox(
                      width: 110,
                      height: 110,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          /// vòng ngoài
                          CircularProgressIndicator(
                            strokeWidth: 3,
                            value: controller.value,
                            color: green,
                          ),

                          /// vòng trong
                          Transform.rotate(
                            angle: -controller.value * 6.28,
                            child: SizedBox(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                value: controller.value,
                                color: greenSoft.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              /// 🔥 TITLE
              const Text(
                "Generating Quiz...",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: greenSoft,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),

              const SizedBox(height: 10),

              /// 🔥 SUBTEXT
              const Text(
                "Analyzing your document",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: green,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}