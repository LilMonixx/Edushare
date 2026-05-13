enum MessageType {
  ai,
  user,
  typing,
}

class ChatMessage {
  final String text;
  final String time;
  final MessageType type;

  ChatMessage({
    required this.text,
    required this.time,
    required this.type,
  });
}