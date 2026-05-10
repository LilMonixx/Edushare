import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/File_model.dart';



class AttachmentService {

  static final _db = FirebaseFirestore.instance;

  static Future<List<AttachmentModel>> getUserAttachments(
      String userId,
      ) async {

    final postSnap = await _db
        .collection("posts")
        .where("userId", isEqualTo: userId)
        .get();

    List<String> postIds = postSnap.docs
        .map((e) => e.id)
        .toList();

    if (postIds.isEmpty) return [];

    final attachmentSnap = await _db
        .collection("attachments")
        .where("postId", whereIn: postIds)
        .get();

    return attachmentSnap.docs.map((e) {

      return AttachmentModel.fromMap({
        ...e.data(),
        "attachmentId": e.id,
      });

    }).toList();
  }
}