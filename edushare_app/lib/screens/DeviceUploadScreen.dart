import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/QuizProvider.dart';

import 'QuizLoading.dart';
import 'Quiz_test_screen.dart';

class DeviceUploadScreen extends StatefulWidget {
  //const DeviceUploadScreen({super.key});

  final File? initialFile;

  const DeviceUploadScreen({
    super.key,
    this.initialFile,
  });


  @override
  State<DeviceUploadScreen> createState() => _DeviceUploadScreenState();
}

class _DeviceUploadScreenState extends State<DeviceUploadScreen> {

  @override
  void initState() {
    super.initState();

    if (widget.initialFile != null) {

      selectedFile = widget.initialFile;

      fileName =
          widget.initialFile!.path.split('/').last;

      fileSizeMB =
          widget.initialFile!.lengthSync() /
              (1024 * 1024);

      titleController.text =
          fileName.split('.').first;
    }
  }

  File? selectedFile;
  String fileName = '';
  double fileSizeMB = 0;

  final TextEditingController titleController = TextEditingController();

  int selectedQuestionCount = 10;
  String selectedDifficulty = "Medium";

  final List<int> questionCounts = [5, 10, 15, 20, 25];
  final List<String> difficulties = ["Easy", "Medium", "Hard"];

  List<String> selectedQuestionTypes = ["Multiple Choice"];

  final List<String> questionTypes = [
    "Multiple Choice",
    "True/False",
    "Fill in the Blank",
  ];

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt', 'pptx'],
    );

    if (result != null) {
      final file = result.files.first;
      setState(() {
        selectedFile = File(file.path!);
        fileName = file.name;
        fileSizeMB = file.size / (1024 * 1024);
        titleController.text = file.name.split('.').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [

            /// HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(.08))),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("AI Quiz Generator",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                        SizedBox(height: 4),
                        Text("Create quiz from your\ndocuments",
                            style: TextStyle(fontSize: 16, color: Colors.white54, height: 1.4)),
                      ],
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff0D2A10)),
                    child: const Center(
                      child: Icon(Icons.auto_awesome, color: Color(0xff4CD137), size: 28),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text("Select Document Source",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 14),

                    /// PICK FILE
                    if (selectedFile == null)
                      GestureDetector(
                        onTap: pickFile,
                        child: Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.upload_rounded, color: Colors.white70, size: 36),
                              SizedBox(height: 26),
                              Text("Tap to upload",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                              SizedBox(height: 8),
                              Text("PDF, DOCX, TXT, PPTX",
                                  style: TextStyle(fontSize: 16, color: Colors.white54)),
                            ],
                          ),
                        ),
                      ),

                    /// FILE CARD
                    if (selectedFile != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xff4CD137)),
                          color: Colors.black,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: const Color(0xff112C13),
                              ),
                              child: const Icon(Icons.upload_rounded, color: Color(0xff4CD137), size: 32),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(fileName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text("${fileSizeMB.toStringAsFixed(2)} MB",
                                      style: const TextStyle(color: Colors.white54, fontSize: 15)),
                                ],
                              ),
                            ),
                            const Icon(Icons.check, color: Color(0xff4CD137)),
                            const SizedBox(width: 14),
                            GestureDetector(
                              onTap: () => setState(() => selectedFile = null),
                              child: const Icon(Icons.close, color: Colors.white54),
                            )
                          ],
                        ),
                      ),

                    if (selectedFile != null) ...[

                      const SizedBox(height: 30),

                      const Text("Quiz Title",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),

                      TextField(
                        controller: titleController,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Number of Questions",
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                          Text("$selectedQuestionCount",
                              style: const TextStyle(color: Color(0xff4CD137), fontSize: 20, fontWeight: FontWeight.w700)),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: questionCounts.map((e) {
                          final isAllowed = e == 5;
                          final isSelected = selectedQuestionCount == e;

                          return Expanded(
                            child: GestureDetector(
                              onTap: isAllowed ? () => setState(() => selectedQuestionCount = e) : null,
                              child: Opacity(
                                opacity: isAllowed ? 1 : 0.3,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  height: 58,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: isSelected ? const Color(0xff4CD137) : Colors.black,
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Center(
                                    child: Text("$e",
                                        style: TextStyle(
                                            color: isSelected ? Colors.black : Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 34),

                      const Text("Difficulty Level",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),

                      const SizedBox(height: 18),

                      Row(
                        children: difficulties.map((e) {
                          final isSelected = selectedDifficulty == e;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedDifficulty = e),
                              child: Container(
                                margin: const EdgeInsets.only(right: 14),
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: isSelected ? const Color(0xff4CD137) : Colors.black,
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Center(
                                  child: Text(e,
                                      style: TextStyle(
                                          color: isSelected ? Colors.black : Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18)),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 34),

                      const Text("Question Types",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),

                      const SizedBox(height: 18),

                      Column(
                        children: questionTypes.map((type) {
                          final isAllowed = type == "Multiple Choice";
                          final isSelected = selectedQuestionTypes.contains(type);

                          return GestureDetector(
                            onTap: isAllowed ? () => setState(() => selectedQuestionTypes = [type]) : null,
                            child: Opacity(
                              opacity: isAllowed ? 1 : 0.3,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.black,
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: isSelected ? const Color(0xff4CD137) : Colors.transparent,
                                        border: Border.all(color: isSelected ? const Color(0xff4CD137) : Colors.white38),
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check, size: 18, color: Colors.black)
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(type,
                                        style: TextStyle(
                                            color: isAllowed ? Colors.white : Colors.white38,
                                            fontSize: 18)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 26),

                      /// GENERATE BUTTON
                      GestureDetector(
                        onTap: () async {
                          if (selectedFile == null) return;

                          final quizProvider = context.read<QuizProvider>();

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const QuizGeneratingScreen()),
                          );

                          await quizProvider.generateQuiz(
                            file: selectedFile!,
                            title: titleController.text,
                            count: selectedQuestionCount,
                            difficulty: selectedDifficulty,
                            types: selectedQuestionTypes,
                          );

                          if (!mounted) return;

                          Navigator.pop(context);

                          if (quizProvider.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(quizProvider.error!)),
                            );
                            return;
                          }

                          if (quizProvider.quizData.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("No quiz generated")),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(data: quizProvider.quizData),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: const Color(0xff4CD137),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.auto_awesome, color: Colors.black),
                              SizedBox(width: 12),
                              Text("Generate Quiz with AI",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20)),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}