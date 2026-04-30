class Answer {
  final String answerId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String postId;
  final String? parentAnswerId;
  final String content;
  final DateTime? createdAt;

  Answer({
    required this.answerId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.postId,
    this.parentAnswerId,
    required this.content,
    this.createdAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerId: json['answerId'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      postId: json['postId'],
      parentAnswerId: json['parentAnswerId'],
      content: json['content'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}