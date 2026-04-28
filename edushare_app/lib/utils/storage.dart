import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const _s = FlutterSecureStorage();

  static Future<void> saveUid(String v) =>
      _s.write(key: "uid", value: v);

  static Future<void> saveName(String v) =>
      _s.write(key: "name", value: v);

  static Future<void> saveEmail(String v) =>
      _s.write(key: "email", value: v);

  static Future<void> saveAccessToken(String v) =>
      _s.write(key: "access_token", value: v);

  static Future<void> saveRefreshToken(String v) =>
      _s.write(key: "refresh_token", value: v);

  static Future<String?> getUid() =>
      _s.read(key: "uid");

  static Future<String?> getAccessToken() =>
      _s.read(key: "access_token");

  static Future<String?> getRefreshToken() =>
      _s.read(key: "refresh_token");

  static Future<void> clearAll() =>
      _s.deleteAll();
}