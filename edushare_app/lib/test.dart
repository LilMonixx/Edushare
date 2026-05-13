import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestAIChatScreen(),
    );
  }
}

class TestAIChatScreen extends StatefulWidget {
  const TestAIChatScreen({super.key});

  @override
  State<TestAIChatScreen> createState() => _TestAIChatScreenState();
}

class _TestAIChatScreenState extends State<TestAIChatScreen> {
  final TextEditingController controller = TextEditingController();
  String response = "";
  bool loading = false;

  Future<void> sendMessage() async {
    setState(() {
      loading = true;
      response = "";
    });

    try {
      final res = await http.post(
        Uri.parse("http://10.0.2.2:5678/webhook/ai-chat"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "message": controller.text,
        }),
      );

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      String body = res.body.trim();

      if (body.isEmpty) {
        setState(() {
          response = "Empty response from server";
          loading = false;
        });
        return;
      }

      if (body.startsWith("=")) {
        body = body.substring(1);
      }

      try {
        final data = jsonDecode(body);

        if (data is Map && data["message"] != null) {
          response = data["message"];
        } else {
          response = body;
        }
      } catch (_) {
        // Không phải JSON → dùng text luôn
        response = body;
      }

    } catch (e) {
      response = "Error: $e";
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("AI Chat Test"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Enter message...",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : sendMessage,
              child: Text(loading ? "Loading..." : "Send"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  response,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}