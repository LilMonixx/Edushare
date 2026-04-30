class Question {
  final String id;
  final String name;
  final String time;
  final String content;
  final String tag;
  final bool isHot;
  final int answers;
  final int likes;

  Question({
    required this.id,
    required this.name,
    required this.time,
    required this.content,
    required this.tag,
    required this.isHot,
    required this.answers,
    required this.likes,
  });
}