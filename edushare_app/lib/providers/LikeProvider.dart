import 'package:flutter/material.dart';

import '../repository/likeRepository.dart';


class LikeProvider extends ChangeNotifier {
  final LikeRepository _repo = LikeRepository();

  bool isLiked = false;
  int likeCount = 0;
  bool loading = false;

  Future<void> init(String postId) async {
    loading = true;
    notifyListeners();

    likeCount = await _repo.getLikeCount(postId);
    isLiked = await _repo.checkLiked(postId);

    loading = false;
    notifyListeners();
  }

  Future<void> toggleLike(String postId) async {
    final res = await _repo.toggleLike(postId);

    isLiked = res["liked"];
    likeCount += isLiked ? 1 : -1;

    notifyListeners();
  }
}