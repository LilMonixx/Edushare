import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/User.dart';

class UserProvider extends ChangeNotifier {
  final DBHelper _db = DBHelper();

  UserModel? localUser;

  // 🔥 load từ SQLite
  Future<void> loadLocalUser(String userId) async {
    final data = await _db.getUser(userId);

    if (data != null) {
      localUser = UserModel.fromMap(data);
      notifyListeners();
    }
  }
}