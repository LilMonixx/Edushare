import 'package:flutter/material.dart';
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

    /// DEMO WAIT
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const QuizScreen(),
        ),
      );
    });
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

/// ===============================================
/// QUIZ SCREEN
/// ===============================================

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() =>
      _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  int selectedAnswer = -1;

  final List<String> answers = [
    "x",
    "2x",
    "2x²",
    "x²",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: Column(
            children: [
              /// HEADER
              Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 22,
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Physics Formulas Q...",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                            FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: const [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.white54,
                            ),

                            SizedBox(width: 6),

                            Text(
                              "12:45",
                              style: TextStyle(
                                color:
                                Colors.white54,
                                fontSize: 16,
                              ),
                            ),

                            SizedBox(width: 10),

                            Text(
                              "·",
                              style: TextStyle(
                                color:
                                Colors.white54,
                              ),
                            ),

                            SizedBox(width: 10),

                            Text(
                              "0/5 answered",
                              style: TextStyle(
                                color:
                                Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.flag_outlined,
                    color: Colors.white70,
                    size: 28,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// PROGRESS BAR
              Row(
                children: List.generate(
                  5,
                      (index) => Expanded(
                    child: Container(
                      margin:
                      const EdgeInsets.only(
                        right: 6,
                      ),
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                            100),
                        color: index <=
                            currentQuestion
                            ? const Color(
                            0xff4CD137)
                            : Colors.white10,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// QUESTION NUMBER
              Row(
                children: List.generate(
                  5,
                      (index) {
                    final isActive =
                        currentQuestion == index;

                    return Padding(
                      padding:
                      const EdgeInsets.only(
                        right: 14,
                      ),
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? const Color(
                              0xff4CD137)
                              : Colors.white10,
                        ),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: isActive
                                  ? Colors.black
                                  : Colors.white54,
                              fontWeight:
                              FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              /// QUESTION CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white10,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                        const Color(0xff133317),
                        borderRadius:
                        BorderRadius.circular(
                            100),
                      ),
                      child: const Text(
                        "Question 1",
                        style: TextStyle(
                          color:
                          Color(0xff4CD137),
                          fontWeight:
                          FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "What is the derivative of\nx² with respect to x?",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                        FontWeight.w700,
                        fontSize: 22,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ANSWERS
              Expanded(
                child: ListView.builder(
                  itemCount: answers.length,
                  itemBuilder: (context, index) {
                    final isSelected =
                        selectedAnswer == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAnswer = index;
                        });
                      },
                      child: Container(
                        margin:
                        const EdgeInsets.only(
                          bottom: 18,
                        ),
                        padding:
                        const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              26),
                          border: Border.all(
                            color: isSelected
                                ? const Color(
                                0xff4CD137)
                                : Colors.white10,
                            width: 1.4,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration:
                              BoxDecoration(
                                shape:
                                BoxShape.circle,
                                color: isSelected
                                    ? const Color(
                                    0xff4CD137)
                                    : Colors.white10,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(
                                    65 + index,
                                  ),
                                  style:
                                  TextStyle(
                                    color:
                                    isSelected
                                        ? Colors
                                        .black
                                        : Colors
                                        .white54,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                                width: 22),

                            Text(
                              answers[index],
                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                                fontSize: 28,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}