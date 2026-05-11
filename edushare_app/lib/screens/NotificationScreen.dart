import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/NotificationModel.dart';
import '../models/Question.dart';
import '../models/attachment.dart';
import '../providers/NotificationProvider.dart';
import 'Question_Detail.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationModel> notifications;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final notifications = provider.notifications;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];

          return GestureDetector(
            onTap: () async {
              final notification = notifications[index];

              // 1. mark as read
              await FirebaseFirestore.instance
                  .collection("notifications")
                  .doc(notification.id)
                  .update({
                "isSeen": true,
              });

              // 2. load post
              final doc = await FirebaseFirestore.instance
                  .collection("posts")
                  .doc(notification.postId)
                  .get();

              if (!doc.exists) return;

              final data = doc.data()!;

              // 3. load attachments từ collection riêng
              final attachmentsSnap = await FirebaseFirestore.instance
                  .collection("attachments")
                  .where("postId", isEqualTo: notification.postId)
                  .get();

              final attachments = attachmentsSnap.docs.map((e) {
                return Attachment.fromJson(e.data());
              }).toList();

              data["attachments"] = attachments.map((e) => {
                "file_url": e.fileUrl,
                "file_type": e.fileType,
                "file_name": e.fileName,
              }).toList();

              // 4. build question FULL DATA
              final question = Question.fromMap(data, doc.id);

              // 5. open screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuestionDetailScreen(question: question),
                ),
              );
            },

            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                border: Border.all(
                  color: n.isRead
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFF3D9E3D).withOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: n.avatarUrl.isNotEmpty
                        ? NetworkImage(n.avatarUrl)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.userName,
                            style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(n.content,
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  if (!n.isRead)
                    const Icon(Icons.circle, size: 10, color: Colors.green),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}