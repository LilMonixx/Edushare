import 'package:flutter/material.dart';

import '../widgets/answer_option.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_header.dart';
import '../widgets/quiz_progress_bar.dart';

class QuizScreen extends StatefulWidget {
  final dynamic data;

  const QuizScreen({
    super.key,
    this.data,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  int currentQuestion = 0;

  bool showResult = false;
  bool isChecked = false;

  late List<dynamic> questions;
  late List<int> selectedAnswers;

  static const primary = Color(0xff4CD137);
  static const bg = Colors.black;

  @override
  void initState() {
    super.initState();

    questions =
    (widget.data is List)
        ? widget.data
        : [];

    selectedAnswers =
        List.filled(questions.length, -1);
  }

  Map<String, dynamic> get q =>
      questions[currentQuestion];

  int get score =>
      selectedAnswers
          .asMap()
          .entries
          .where(
            (e) =>
        e.value ==
            questions[e.key]["correct"],
      )
          .length;

  void selectAnswer(int index) {

    if (isChecked) return;

    setState(() {
      selectedAnswers[currentQuestion] =
          index;
    });
  }

  void nextQuestion() {

    if (selectedAnswers[currentQuestion] ==
        -1) {
      _showError(
        "Please select an answer first",
      );
      return;
    }

    if (currentQuestion <
        questions.length - 1) {

      setState(() {
        currentQuestion++;
      });
    }
  }

  void prevQuestion() {

    if (currentQuestion > 0) {

      setState(() {
        currentQuestion--;
      });
    }
  }

  void checkOrFinish() {

    if (selectedAnswers[currentQuestion] ==
        -1) {

      _showError("Select an answer first");

      return;
    }

    if (currentQuestion ==
        questions.length - 1) {

      setState(() {
        showResult = true;
        isChecked = true;
      });

      return;
    }

    nextQuestion();
  }

  void resetQuiz() {

    setState(() {

      showResult = false;

      isChecked = false;

      selectedAnswers =
          List.filled(
            questions.length,
            -1,
          );

      currentQuestion = 0;
    });
  }

  void exitQuiz() {

    showDialog(
      context: context,

      builder: (_) => AlertDialog(

        backgroundColor:
        Colors.grey[900],

        title: const Text(
          "Exit Quiz?",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        content: const Text(
          "Your progress will be lost.",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),

        actions: [

          TextButton(
            onPressed: () =>
                Navigator.pop(context),

            child: const Text("Cancel"),
          ),

          TextButton(
            onPressed: () {

              Navigator.pop(context);

              Navigator.pop(context);
            },

            child: const Text(
              "Exit",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String msg) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (questions.isEmpty) {

      return const Scaffold(
        backgroundColor: Colors.black,

        body: Center(
          child: Text(
            "No Questions",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Scaffold(

      backgroundColor: bg,

      body: SafeArea(

        child: Padding(

          padding:
          const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),

          child: Column(

            children: [

              Row(
                children: [

                  GestureDetector(

                    onTap: exitQuiz,

                    child: Container(

                      width: 48,
                      height: 48,

                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius:
                        BorderRadius.circular(14),
                      ),

                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: QuizHeader(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              QuizProgress(
                total: questions.length,
                selectedAnswers:
                selectedAnswers,
                primary: primary,
              ),

              const SizedBox(height: 20),

              buildQuestionTabs(),

              const SizedBox(height: 24),

              questioncard(
                index: currentQuestion,
                question: q["question"],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: _buildAnswers(),
              ),

              const SizedBox(height: 10),

              _buildBottom(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestionTabs() {

    return SizedBox(

      height: 58,

      child: ListView.separated(

        scrollDirection: Axis.horizontal,

        itemCount: questions.length,

        separatorBuilder: (_, __) =>
        const SizedBox(width: 12),

        itemBuilder: (context, index) {

          final isCurrent =
              currentQuestion == index;

          final answered =
              selectedAnswers[index] != -1;

          final isCorrect =
              selectedAnswers[index] ==
                  questions[index]["correct"];

          Color bgColor =
          const Color(0xff111111);

          Color textColor =
              Colors.white70;

          if (isCurrent) {

            bgColor = primary;

            textColor = Colors.black;
          }

          if (showResult && answered) {

            bgColor =
            isCorrect
                ? Colors.green
                : Colors.red;

            textColor = Colors.white;

            if (isCurrent) {
              bgColor =
              isCorrect
                  ? Colors.green
                  : Colors.red;
            }
          }

          return GestureDetector(

            onTap: () {

              if (!showResult) {

                if (index <=
                    currentQuestion) {

                  setState(() {
                    currentQuestion =
                        index;
                  });
                }

                return;
              }

              setState(() {
                currentQuestion = index;
              });
            },

            child: AnimatedContainer(

              duration:
              const Duration(
                milliseconds: 200,
              ),

              width: 52,
              height: 52,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
              ),

              child: Center(

                child: Text(

                  "${index + 1}",

                  style: TextStyle(
                    color: textColor,
                    fontWeight:
                    FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnswers() {

    final answers = q["answers"];

    if (answers is! List) {

      return const Center(
        child: Text(
          "Invalid question format",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    const labels = ["A", "B", "C", "D", "E", "F"];

    return ListView.separated(

      itemCount: answers.length,

      separatorBuilder: (_, __) =>
      const SizedBox(height: 12),

      itemBuilder: (context, index) {

        return AnswerOption(

          label: labels[index],

          text: answers[index].toString(),

          selected:
          selectedAnswers[currentQuestion] ==
              index,

          isCorrect:
          index == q["correct"],

          showResult: isChecked,

          primary: primary,

          onTap: () =>
              selectAnswer(index),
        );
      },
    );
  }

  Widget _buildBottom() {

    if (showResult) {

      return Column(

        children: [

          Text(

            "Result: $score / ${questions.length}",

            style: const TextStyle(
              color: primary,
              fontSize: 24,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(

            children: [

              Expanded(

                child: ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.grey[900],

                    foregroundColor:
                    Colors.white,

                    padding:
                    const EdgeInsets
                        .symmetric(
                      vertical: 16,
                    ),
                  ),

                  onPressed: resetQuiz,

                  child:
                  const Text("Restart"),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(

                child: ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    primary,

                    foregroundColor:
                    Colors.black,

                    padding:
                    const EdgeInsets
                        .symmetric(
                      vertical: 16,
                    ),
                  ),

                  onPressed: () =>
                      Navigator.pop(
                        context,
                      ),

                  child:
                  const Text("Finish"),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(

      children: [

        Expanded(

          child: ElevatedButton(

            style:
            ElevatedButton.styleFrom(

              backgroundColor:
              Colors.grey[900],

              foregroundColor:
              Colors.white,

              padding:
              const EdgeInsets
                  .symmetric(
                vertical: 16,
              ),
            ),

            onPressed:
            currentQuestion == 0
                ? null
                : prevQuestion,

            child: const Text("Back"),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(

          child: ElevatedButton(

            style:
            ElevatedButton.styleFrom(

              backgroundColor: primary,

              foregroundColor:
              Colors.black,

              padding:
              const EdgeInsets
                  .symmetric(
                vertical: 16,
              ),
            ),

            onPressed: checkOrFinish,

            child: Text(

              currentQuestion ==
                  questions.length -
                      1
                  ? "Check"
                  : "Next",

              style: const TextStyle(
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}