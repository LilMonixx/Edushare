import 'package:flutter/material.dart';
import '../models/DocFile.dart';
import 'Quiz_loading.dart';

class QuizSetupScreen extends StatefulWidget {
  final DocFile doc;

  const QuizSetupScreen({super.key, required this.doc});

  @override
  State<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  int selectedQuestions = 10;
  String difficulty = "Medium";

  /// Question types
  List<String> questionTypes = [
    "Multiple Choice",
    "True/False",
    "Fill in the Blank",
  ];

  Set<String> selectedTypes = {"Multiple Choice"};

  late TextEditingController titleController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.doc.title);
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF4CD964);

    return Stack(
      children: [Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child:
                        const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "AI Quiz Generator",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Create quiz from your documents",
                            style:
                            TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 20),

                  /// FILE CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: green),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.upload, color: green),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.doc.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              Text(widget.doc.size,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white54)),
                            ],
                          ),
                        ),
                        const Icon(Icons.check_circle, color: green),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child:
                          const Icon(Icons.close, color: Colors.white54),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// QUIZ TITLE
                  const Text("Quiz Title"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                      const InputDecoration(border: InputBorder.none),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// NUMBER OF QUESTIONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Number of Questions"),
                      Text("$selectedQuestions",
                          style: const TextStyle(color: green)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [5, 10, 15, 20, 25].map((e) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedQuestions = e;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectedQuestions == e
                                ? green
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            "$e",
                            style: TextStyle(
                              color: selectedQuestions == e
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  /// DIFFICULTY
                  const Text("Difficulty Level"),
                  const SizedBox(height: 10),

                  Row(
                    children: ["Easy", "Medium", "Hard"].map((e) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              difficulty = e;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                              difficulty == e ? green : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Text(
                              e,
                              style: TextStyle(
                                color: difficulty == e
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  /// QUESTION TYPES
                  const Text("Question Types"),
                  const SizedBox(height: 10),

                  Column(
                    children: questionTypes.map((type) {
                      final isSelected = selectedTypes.contains(type);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedTypes.remove(type);
                            } else {
                              selectedTypes.add(type);
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111111),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: isSelected ? green : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border:
                                  Border.all(color: Colors.white38),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check,
                                    size: 16, color: Colors.black)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Text(type),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        setState(() => isLoading = true);

                        /// gọi API thật ở đây
                        await Future.delayed(const Duration(seconds: 3));

                        setState(() => isLoading = false);
                      },
                      child: const Text(
                        "✨ Generate Quiz with AI",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
        if (isLoading) const AILoading(),
      ],
    );
  }
}