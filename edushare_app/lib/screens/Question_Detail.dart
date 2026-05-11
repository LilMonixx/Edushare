import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Question.dart';
import '../providers/AnswerProvider.dart';
import '../providers/LikeProvider.dart';
import '../utils/open_attachment.dart';
import '../widgets/answer_card.dart';
import '../widgets/pdf_thumnail.dart';

class QuestionDetailScreen extends StatefulWidget {
  final Question question;

  const QuestionDetailScreen({
    super.key,
    required this.question,
  });

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {

  final TextEditingController _answerController = TextEditingController();




  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnswerProvider>().loadAnswers(widget.question.id);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LikeProvider>().init(widget.question.id);
    });
  }

  String _formatTime(DateTime? time) {
    if (time == null) return "just now";

    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    } else {
      return "${time.day}/${time.month}/${time.year}";
    }
  }
  void _shareQuestion() {
    final text = widget.question.content;

    print("Share: $text");

    // TODO: dùng share_plus nếu muốn share thật
  }

  @override
  Widget build(BuildContext context) {
    final answerProvider = context.watch<AnswerProvider>();
    final answers = answerProvider.answers;
    final loading = answerProvider.loading;
    final likeProvider = context.watch<LikeProvider>();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Column(
          children: [
            /// ================= MAIN =================
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
                          onTap: () => Navigator.pop(context),
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

                    /// QUESTION USER INFO (FROM DATABASE)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFF1C1C1E),
                          backgroundImage: widget.question.userAvatar != null
                              ? NetworkImage(widget.question.userAvatar!)
                              : null,
                          child: widget.question.userAvatar == null
                              ? Text(
                            widget.question.userName.isNotEmpty
                                ? widget.question.userName[0].toUpperCase()
                                : "?",
                          )
                              : null,
                        ),

                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.question.userName,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Student",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),

                        const Spacer(),

                        Text(
                          _formatTime(widget.question.createdAt),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        )
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// QUESTION CONTENT (FROM DB)
                    Text(
                      widget.question.content,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (widget.question.attachments.isNotEmpty)
                      SizedBox(
                        height: widget.question.attachments.any(
                              (e) => e.fileType == "document",
                        )
                            ? 220
                            : 110,

                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.question.attachments.length,

                          itemBuilder: (context, index) {

                            final att = widget.question.attachments[index];

                            /// ================= IMAGE =================
                            if (att.fileType == "image") {

                              return GestureDetector(
                                onTap: () {

                                  print("CLICK IMAGE");

                                  openAttachment(
                                    context: context,
                                    fileType: att.fileType,
                                    fileUrl: att.fileUrl,
                                    fileName: att.fileName,
                                  );
                                },

                                child: Container(
                                  width: 180,
                                  margin: const EdgeInsets.only(right: 12),

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),

                                    child: Image.network(
                                      att.fileUrl,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            }

                            /// ================= VIDEO =================
                            if (att.fileType == "video") {

                              return GestureDetector(
                                onTap: () {

                                  print("CLICK VIDEO");

                                  openAttachment(
                                    context: context,
                                    fileType: att.fileType,
                                    fileUrl: att.fileUrl,
                                    fileName: att.fileName,
                                  );
                                },

                                child: Container(
                                  width: 180,
                                  margin: const EdgeInsets.only(right: 12),

                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(18),
                                  ),

                                  child: const Center(
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              );
                            }

                            /// ================= DOCUMENT =================
                            return GestureDetector(
                              onTap: () {

                                print("CLICK DOCUMENT");

                                openAttachment(
                                  context: context,
                                  fileType: att.fileType,
                                  fileUrl: att.fileUrl,
                                  fileName: att.fileName,
                                );
                              },

                              child: Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 12),

                                decoration: BoxDecoration(
                                  color: const Color(0xFF111827),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.white10),
                                ),

                                clipBehavior: Clip.antiAlias,

                                child: Column(
                                  children: [

                                    Expanded(
                                      child: PdfThumbnail(
                                        url: att.fileUrl,
                                      ),
                                    ),

                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      color: Colors.black87,

                                      child: Text(
                                        att.fileName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,

                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 12),

                    /// SUBJECT TAG (USE YOUR TAG WIDGET)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1ED760).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.question.subject,
                        style: const TextStyle(
                          color: Color(0xFF1ED760),
                          fontSize: 12,
                        ),
                      ),
                    ),

                    SizedBox(height: 40,),

                    /// ACTION BAR (LIKE + SHARE)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212), // nền nhẹ tách biệt
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.08),
                            width: 1,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          /// LIKE
                          GestureDetector(
                            onTap: () {
                              context.read<LikeProvider>().toggleLike(widget.question.id);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: likeProvider.isLiked
                                    ? Colors.red.withOpacity(0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    transitionBuilder: (child, anim) {
                                      return ScaleTransition(
                                        scale: Tween(begin: 0.7, end: 1.2).animate(
                                          CurvedAnimation(
                                            parent: anim,
                                            curve: Curves.elasticOut,
                                          ),
                                        ),
                                        child: child,
                                      );
                                    },
                                    child: Icon(
                                      likeProvider.isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      key: ValueKey(likeProvider.isLiked),
                                      color: likeProvider.isLiked
                                          ? Colors.red
                                          : Colors.white70,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "${likeProvider.likeCount}",
                                    style: TextStyle(
                                      color: likeProvider.isLiked
                                          ? Colors.red
                                          : Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// SHARE
                          GestureDetector(
                            onTap: _shareQuestion,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.share_outlined,
                                color: Colors.white70,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Divider(color: Color(0xFF1C1C1E)),

                    const SizedBox(height: 12),

                    /// ANSWER TITLE
                    Text(
                      "${answers.length} Answers",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// LOADING
                    if (loading)
                      const Center(child: CircularProgressIndicator())

                    /// EMPTY
                    else if (answers.isEmpty)
                      const Text(
                        "No answers yet",
                        style: TextStyle(color: Colors.grey),
                      )

                    /// LIST ANSWERS FROM DB
                    else
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

            /// ================= INPUT =================
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
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF1C1C1E),
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? Text(
                      user?.displayName?.isNotEmpty == true
                          ? user!.displayName![0].toUpperCase()
                          : "?",
                    )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _answerController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Write an answer...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green),
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      final answerProvider = context.read<AnswerProvider>();

                      final content = _answerController.text.trim();
                      if (content.isEmpty || user == null) return;

                      await answerProvider.createAnswer(
                        postId: widget.question.id,
                        content: content,
                        userId: user.uid,
                        userName: user.displayName ?? "User",
                        userAvatar: user.photoURL,
                      );

                      _answerController.clear();
                    },
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

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