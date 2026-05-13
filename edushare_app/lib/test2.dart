import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
      home: QuizTestPage(),
    );
  }
}

class QuizTestPage extends StatefulWidget {
  const QuizTestPage({super.key});

  @override
  State<QuizTestPage> createState() => _QuizTestPageState();
}

class _QuizTestPageState extends State<QuizTestPage> {
  File? pdfFile;
  bool loading = false;
  List<dynamic> questions = [];

  // 👉 đổi thành webhook n8n của bạn
  final String webhookUrl = "http://10.0.2.2:5678/webhook/ai-quiz";

  // ===================== PICK PDF =====================
  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        pdfFile = File(result.files.single.path!);
      });
    }
  }
  Future<void> uploadPdf() async {
    if (pdfFile == null) return;

    setState(() => loading = true);

    try {
      var request = http.MultipartRequest('POST', Uri.parse(webhookUrl));

      request.files.add(
        await http.MultipartFile.fromPath('file', pdfFile!.path),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("RAW RESPONSE: $responseBody");

      final data = jsonDecode(responseBody);

      setState(() {
        questions = (data["data"] ?? []) as List<dynamic>;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print("ERROR: $e");
    }
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Quiz Generator"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PICK FILE
            ElevatedButton.icon(
              onPressed: pickPdf,
              icon: const Icon(Icons.upload_file),
              label: const Text("Chọn PDF"),
            ),

            const SizedBox(height: 10),

            // UPLOAD
            ElevatedButton.icon(
              onPressed: loading ? null : uploadPdf,
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Generate Quiz"),
            ),

            const SizedBox(height: 20),

            if (pdfFile != null)
              Text(
                "File: ${pdfFile!.path.split('/').last}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 10),

            if (loading) const CircularProgressIndicator(),

            const SizedBox(height: 10),

            // ===================== QUIZ LIST =====================
            Expanded(
              child: questions.isEmpty
                  ? const Center(child: Text("Chưa có câu hỏi"))
                  : ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Q${index + 1}: ${q["question"] ?? ""}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // OPTIONS (SAFE)
                          Text("A. ${_getOption(q, 0)}"),
                          Text("B. ${_getOption(q, 1)}"),
                          Text("C. ${_getOption(q, 2)}"),
                          Text("D. ${_getOption(q, 3)}"),

                          const SizedBox(height: 10),

                          Text(
                            "Answer: ${q["answer"] ?? ""}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== SAFE OPTION HANDLER =====================
  String _getOption(dynamic q, int index) {
    try {
      final options = q["options"];

      if (options is List && options.length > index) {
        return options[index].toString();
      }

      return "";
    } catch (e) {
      return "";
    }
  }
}