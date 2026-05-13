import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../providers/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
class StudyAIScreen extends StatefulWidget {
  const StudyAIScreen({super.key});

  @override
  State<StudyAIScreen> createState() => _StudyAIScreenState();
}

class _StudyAIScreenState extends State<StudyAIScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void sendMessage(ChatProvider provider) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    provider.sendMessage(text).then((_) {
      _scrollToBottom();
    });

    _scrollToBottom();
  }
  void _addWelcomeMessage() {
    final chatProvider = Provider.of<ChatProvider>(
      context,
      listen: false,
    );


    if (chatProvider.messages.isNotEmpty) return;

    final user = FirebaseAuth.instance.currentUser;

    final name = user?.displayName ??
        user?.email?.split('@')[0] ??
        "there";

    Future.delayed(const Duration(milliseconds: 300), () {
      chatProvider.addMessage(
        "Hello $name 👋, what can I help you?",
        type: MessageType.ai,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Column(
          children: [
            _topBar(),

            // ================= CHAT LIST =================
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                itemCount: chatProvider.messages.length,
                itemBuilder: (context, index) {
                  final msg = chatProvider.messages[index];

                  if (msg.type.toString().contains("system")) {
                    return _systemMessage(msg.text);
                  }

                  if (msg.type.toString().contains("user")) {
                    return _userBubble(msg.text, msg.time);
                  }

                  return _aiBubble(msg.text, msg.time);
                },
              ),
            ),

            if (chatProvider.loading)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "AI đang trả lời...",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),

            _inputBar(chatProvider),
          ],
        ),
      ),
    );
  }


  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [

          const Icon(Icons.smart_toy, color: Colors.white),
          const SizedBox(width: 10),

          const Text(
            "Study AI",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= USER BUBBLE =================
  Widget _userBubble(String text, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF57D64D),
          borderRadius: BorderRadius.circular(14).copyWith(
            bottomRight: const Radius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // ================= AI BUBBLE =================
  Widget _aiBubble(String text, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(14).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SYSTEM =================
  Widget _systemMessage(String text) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ================= INPUT =================
  Widget _inputBar(ChatProvider provider) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: MediaQuery.of(context).padding.bottom + 50,
        top: 6,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0E0E10),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Nhập tin nhắn...",
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          GestureDetector(
            onTap: () => sendMessage(provider),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF57D64D),
              child: Icon(Icons.send, size: 18, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}