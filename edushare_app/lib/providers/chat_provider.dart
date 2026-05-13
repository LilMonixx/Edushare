import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../repository/ai_repository.dart';


class ChatProvider extends ChangeNotifier {
  final AiRepository _repo = AiRepository();

  final List<ChatMessage> _messages = [];
  bool _loading = false;

  List<ChatMessage> get messages => _messages;
  bool get loading => _loading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // add user message
    _messages.add(ChatMessage(
      text: text,
      time: "Now",
      type: MessageType.user,
    ));

    _loading = true;
    notifyListeners();

    try {
      final aiText = await _repo.sendMessage(text);

      _messages.add(ChatMessage(
        text: aiText,
        time: "Now",
        type: MessageType.ai,
      ));
    } catch (e) {
      _messages.add(ChatMessage(
        text: "Error: $e",
        time: "Now",
        type: MessageType.ai,
      ));
    }

    _loading = false;
    notifyListeners();
  }

  void addMessage(String text, {required MessageType type}) {
    _messages.add(ChatMessage(
      text: text,
      time: "Now",
      type: type,
    ));

    notifyListeners();
  }
}