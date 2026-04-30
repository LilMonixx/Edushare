import 'package:flutter/material.dart';
import '../models/Question.dart';
import '../models/Answer.dart';
import '../widgets/answer_card.dart';

class QuestionDetailScreen extends StatelessWidget {
  final Question question;

  QuestionDetailScreen({
    super.key,
    required this.question,
  });

  final List<Answer> answers = [
    Answer(
      author: "Dr. Sarah Math",
      avatar: "D",
      time: "1 hour ago",
      content:
      "Great question! When the discriminant (b² - 4ac) is negative, you get complex roots.\n\n1. Identify a=1, b=2, c=5\n2. Calculate discriminant: 2² - 4(1)(5) = -16\n3. Apply formula...",
      isExpert: true,
      isAccepted: true,
    ),
    Answer(
      author: "John Doe",
      avatar: "J",
      time: "2 hours ago",
      content: "You can solve it using imaginary numbers...",
    ),
    Answer(
      author: "Alice",
      avatar: "A",
      time: "3 hours ago",
      content: "Use quadratic formula with i (√-1)...",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    /// Sort accepted lên đầu
    answers.sort((a, b) {
      if (a.isAccepted == b.isAccepted) return 0;
      return a.isAccepted ? -1 : 1;
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Column(
          children: [
            /// MAIN SCROLL
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    /// HEADER
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: _iconBtn(Icons.arrow_back),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              "Question",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        _iconBtn(Icons.more_horiz),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// USER INFO
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFF1C1C1E),
                          child: Text(
                            question.name.substring(0, 1),
                          ),
                        ),
                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.name,
                              style:
                              const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Student",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),

                        const SizedBox(width: 8),

                        /// TAG
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                            const Color(0xFF1ED760).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            question.tag,
                            style: const TextStyle(
                              color: Color(0xFF1ED760),
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const Spacer(),

                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              question.time,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// TITLE
                    Text(
                      question.content,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// DESCRIPTION (tạm giữ demo)
                    const Text(
                      "Detailed explanation or additional context can be displayed here.",
                      style: TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// ACTION BAR
                    Row(
                      children: [
                        const Icon(Icons.favorite_border,
                            color: Colors.grey),
                        const SizedBox(width: 6),
                        Text("${question.likes}",
                            style:
                            const TextStyle(color: Colors.grey)),

                        const SizedBox(width: 20),

                        const Icon(Icons.chat_bubble_outline,
                            color: Colors.grey),
                        const SizedBox(width: 6),
                        Text("${answers.length} Answers",
                            style:
                            const TextStyle(color: Colors.grey)),

                        const Spacer(),

                        const Icon(Icons.share, color: Colors.grey),
                        const SizedBox(width: 16),
                        const Icon(Icons.bookmark_border,
                            color: Colors.grey),
                      ],
                    ),

                    const Divider(
                        height: 30, color: Color(0xFF1C1C1E)),

                    /// ANSWERS TITLE
                    Text(
                      "${answers.length} Answers",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 16),

                    /// ANSWERS LIST
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: answers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AnswerCard(answer: answers[index]),
                        );
                      },
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            /// INPUT BOX
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF111111),
                border: Border(
                  top: BorderSide(color: Color(0xFF1C1C1E)),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF1C1C1E),
                    child: Text("U"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 14),
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius:
                        BorderRadius.circular(22),
                      ),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Write an answer...",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// ICON BUTTON
  Widget _iconBtn(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20),
    );
  }
}