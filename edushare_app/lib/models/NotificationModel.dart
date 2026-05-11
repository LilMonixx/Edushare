class NotificationModel {
  final String id;
  final String userName;
  final String avatarUrl;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final String postId;

  NotificationModel({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.content,
    required this.createdAt,
    required this.isRead,
    required this.postId,
  });

  factory NotificationModel.fromMap(String id, Map<String, dynamic> data) {
    return NotificationModel(
      id: id,
      userName: data["userName"] ?? "",
      avatarUrl: data["avatarUrl"] ?? "",
      content: data["content"] ?? "",
      createdAt: data["createdAt"]?.toDate() ?? DateTime.now(),
      isRead: data["isSeen"] ?? false,
      postId: data["postId"] ?? "",
    );
  }
}