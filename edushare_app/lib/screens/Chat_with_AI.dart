import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatWithAIScreen extends StatefulWidget {
  const ChatWithAIScreen({super.key});

  @override
  State<ChatWithAIScreen> createState() => _ChatWithAIScreenState();
}

class _ChatWithAIScreenState extends State<ChatWithAIScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  // Đổi IP này theo máy ông nhé
  final String _apiUrl = "http://192.168.4.8/chat";

  @override
  void initState() {
    super.initState();
    _messages.add({
      "role": "bot",
      "message":
          "Chào Đạt! Tôi là EduShare AI. Hôm nay tôi có thể hỗ trợ gì cho việc học của bạn?",
      "time": DateTime.now(),
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF0B0F19,
      ), // Khớp màu nền HomeScreen của ông
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "EduShare AI",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  _buildMessageBubble(_messages[index]),
            ),
          ),
          if (_isTyping) _buildTypingIndicator(),
          _buildInputSection(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    bool isUser = msg['role'] == "user";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAIAvatar(),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                // Nếu là User: dùng màu Green giống nút FAB trên Home
                // Nếu là AI: dùng màu xám đen mờ (Glassmorphism)
                color: isUser
                    ? const Color(0xFF22C55E)
                    : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 18),
                ),
              ),
              child: MarkdownBody(
                data: msg['message'],
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    color: isUser
                        ? Colors.black
                        : Colors.white.withOpacity(0.9),
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFF22C55E),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.auto_awesome, size: 18, color: Colors.black),
    );
  }

  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.only(left: 58, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF22C55E),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
      decoration: BoxDecoration(
        color: const Color(0xFF161B28), // Màu hơi sáng hơn nền một chút
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Hỏi EduShare AI...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: const Color(0xFF0B0F19),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _handleSendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Giữ nguyên hàm _handleSendMessage từ các lượt trước...
  Future<void> _handleSendMessage() async {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    setState(() {
      _messages.add({"role": "user", "message": text, "time": DateTime.now()});
      _isTyping = true;
    });
    _scrollToBottom();
    // (Phần gọi API ông giữ nguyên code cũ nhé)

    try {
      // ----- Cấu hình request -----
      final uri = Uri.parse(
        'http://192.168.4.8:8000/chat',
      ); // Đảm bảo endpoint đúng
      final requestBody = jsonEncode({
        'prompt': text,
      }); // Đocystructure tùy API của bạn

      debugPrint('🟢 Request URL: $uri');
      debugPrint('🟢 Request body: $requestBody');

      // ----- Gọi HTTP với timeout -----
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              // Thêm token nếu bạn đã có (ví dụ từ Firebase)
              // 'Authorization': 'Bearer $firebaseToken',
            },
            body: requestBody,
          )
          .timeout(const Duration(seconds: 10)); // <-- Timeout 10 giây

      // ----- Log phản hồi -----
      debugPrint('🟢 Response status: ${response.statusCode}');
      debugPrint('🟢 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Giả sử API trả về { "reply": "..." }
        final reply = data['reply'] ?? 'Không có phản hồi';
        setState(() {
          _messages.add({
            "role": "bot",
            "message": reply,
            "time": DateTime.now(),
          });
          _isTyping = false;
        });
      } else {
        throw Exception('API lỗi ${response.statusCode}: ${response.body}');
      }
    } on http.ClientException catch (e) {
      debugPrint('🔴 Lỗi kết nối HTTP: $e');
      setState(() {
        _messages.add({
          "role": "bot",
          "message":
              "Không thể kết nối tới server. Vui lòng kiểm tra mạng và thử lại.",
          "time": DateTime.now(),
        });
        _isTyping = false;
      });
    } on FormatException catch (e) {
      debugPrint('🔴 Lỗi định dạng JSON: $e');
      setState(() {
        _messages.add({
          "role": "bot",
          "message": "Phản hồi từ server không hợp lệ.",
          "time": DateTime.now(),
        });
        _isTyping = false;
      });
    } catch (e) {
      debugPrint('🔴 Lỗi không xác định: $e');
      setState(() {
        _messages.add({
          "role": "bot",
          "message": "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.",
          "time": DateTime.now(),
        });
        _isTyping = false;
      });
    } finally {
      _scrollToBottom();
    }
  }
}
