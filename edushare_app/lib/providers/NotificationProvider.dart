import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/NotificationModel.dart';
// snapshot
class NotificationProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<NotificationModel> notifications = [];

  StreamSubscription? _sub;

  void listenNotifications(String userId) {
    _sub?.cancel();

    _sub = _firestore
        .collection("notifications")
        .where("receiverId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((snapshot) {
      notifications = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.id, doc.data());
      }).toList();

      notifyListeners();
    });
  }

  int get unreadCount =>
      notifications.where((e) => e.isRead == false).length;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}