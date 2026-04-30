import '../Database/db_helper.dart';
import '../models/Question.dart';

class QuestionRepository {
  final DBHelper db;

  QuestionRepository(this.db);

  Future<List<Question>> getQuestions(bool isOnline) async {
    // ================= ONLINE (FAKE / SAU NÀY API) =================
    if (isOnline) {
      return [
        Question(
          id: "q1",
          name: "Alex T.",
          time: "2h ago",
          content: "How do I solve quadratic equations?",
          tag: "Math",
          isHot: true,
          answers: 12,
          likes: 34,
        ),
        Question(
          id: "q2",
          name: "Lisa P.",
          time: "4h ago",
          content: "Explain metaphor vs simile",
          tag: "English",
          isHot: false,
          answers: 8,
          likes: 16,
        ),
      ];
    }

    // ================= OFFLINE SQLITE =================
    final posts = await db.getPosts();

    return posts.map((p) {
      return Question(
        id: p['PostID'],
        name: "You",
        time: p['CreatedAt'] ?? "",
        content: p['Content'] ?? "",
        tag: p['Subject'] ?? "Post",
        isHot: false,
        answers: 0,
        likes: 0,
      );
    }).toList();
  }
}