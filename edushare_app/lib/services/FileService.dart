import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<String?> downloadAvatar(String url, String userId) async {
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/avatar_$userId.png");

      await file.writeAsBytes(res.bodyBytes);

      return file.path;
    }

    return null;
  }
}