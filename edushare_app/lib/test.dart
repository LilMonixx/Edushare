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
      home: VisionTestPage(),
    );
  }
}

class VisionTestPage extends StatefulWidget {
  const VisionTestPage({super.key});

  @override
  State<VisionTestPage> createState() => _VisionTestPageState();
}

class _VisionTestPageState extends State<VisionTestPage> {
  String result = "Chưa test";

  final String apiKey = "AIzaSyBLY0n0-Y0hase5T02B8smtVpc9di2rZcM";

  Future<void> testOCR() async {
    setState(() {
      result = "Đang xử lý...";
    });

    final url = Uri.parse(
      "https://vision.googleapis.com/v1/images:annotate?key=$apiKey",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "requests": [
          {
            "image": {
              "source": {
                "imageUri":
                "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Document.jpg/640px-Document.jpg"
              }
            },
            "features": [
              {"type": "TEXT_DETECTION"}
            ]
          }
        ]
      }),
    );

    final data = jsonDecode(response.body);

    try {
      final text = data["responses"][0]["fullTextAnnotation"]["text"];

      setState(() {
        result = text ?? "Không nhận được text";
      });
    } catch (e) {
      setState(() {
        result = "Lỗi: ${response.body}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vision API Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: testOCR,
              child: const Text("Test OCR"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  result,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}