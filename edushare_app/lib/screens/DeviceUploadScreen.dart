import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'QuizScreen.dart';

class DeviceUploadScreen extends StatefulWidget {
  const DeviceUploadScreen({super.key});

  @override
  State<DeviceUploadScreen> createState() => _DeviceUploadScreenState();
}

class _DeviceUploadScreenState extends State<DeviceUploadScreen> {
  File? selectedFile;
  String fileName = '';
  double fileSizeMB = 0;

  final TextEditingController titleController =
  TextEditingController();

  int selectedQuestionCount = 10;
  String selectedDifficulty = "Medium";

  final List<int> questionCounts = [5, 10, 15, 20, 25];
  final List<String> difficulties = ["Easy", "Medium", "Hard"];
  /// ADD THESE VARIABLES

  List<String> selectedQuestionTypes = [
    "Multiple Choice",
  ];

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
        fileSizeMB = (file.size / (1024 * 1024));
        titleController.text =
            file.name.split('.').first;
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(.08),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "AI Quiz Generator",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Create quiz from your\ndocuments",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff0D2A10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.auto_awesome,
                        color: Color(0xff4CD137),
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Document Source",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// FILE PICKER
                    if (selectedFile == null)
                      GestureDetector(
                        onTap: pickFile,
                        child: Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                            BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white24,
                              width: 1.2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.upload_rounded,
                                  color: Colors.white70,
                                  size: 36,
                                ),
                              ),

                              const SizedBox(height: 26),

                              const Text(
                                "Tap to upload",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                "PDF, DOCX, TXT, PPTX",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    /// SELECTED FILE CARD
                    if (selectedFile != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(24),
                          border: Border.all(
                            color:
                            const Color(0xff4CD137),
                          ),
                          color: Colors.black,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                    18),
                                color:
                                const Color(0xff112C13),
                              ),
                              child: const Icon(
                                Icons.upload_rounded,
                                color:
                                Color(0xff4CD137),
                                size: 32,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    fileName,
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                    style:
                                    const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight
                                          .w700,
                                      color:
                                      Colors.white,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 4),

                                  Text(
                                    "${fileSizeMB.toStringAsFixed(2)} MB",
                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white54,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                Color(0xff4CD137),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(width: 14),

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFile = null;
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),

                    /// SETTINGS
                    if (selectedFile != null) ...[
                      const SizedBox(height: 30),

                      const Text(
                        "Quiz Title",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                          BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white10,
                          ),
                        ),
                        child: TextField(
                          controller: titleController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration:
                          const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Number of Questions",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            "$selectedQuestionCount",
                            style: const TextStyle(
                              color:
                              Color(0xff4CD137),
                              fontSize: 20,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: questionCounts
                            .map(
                              (e) => Expanded(
                            child: Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                right: 10,
                              ),
                              child:
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedQuestionCount =
                                        e;
                                  });
                                },
                                child: Container(
                                  height: 58,
                                  decoration:
                                  BoxDecoration(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        16),
                                    color:
                                    selectedQuestionCount ==
                                        e
                                        ? const Color(
                                        0xff4CD137)
                                        : Colors
                                        .black,
                                    border:
                                    Border.all(
                                      color: Colors
                                          .white10,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$e",
                                      style:
                                      TextStyle(
                                        color: selectedQuestionCount ==
                                            e
                                            ? Colors
                                            .black
                                            : Colors
                                            .white,
                                        fontWeight:
                                        FontWeight
                                            .w700,
                                        fontSize:
                                        18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),

                      const SizedBox(height: 34),

                      const Text(
                        "Difficulty Level",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: difficulties
                            .map(
                              (e) => Expanded(
                            child: Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                right: 14,
                              ),
                              child:
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDifficulty =
                                        e;
                                  });
                                },
                                child: Container(
                                  height: 60,
                                  decoration:
                                  BoxDecoration(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        18),
                                    color:
                                    selectedDifficulty ==
                                        e
                                        ? const Color(
                                        0xff4CD137)
                                        : Colors
                                        .black,
                                    border:
                                    Border.all(
                                      color: Colors
                                          .white10,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      e,
                                      style:
                                      TextStyle(
                                        color: selectedDifficulty ==
                                            e
                                            ? Colors
                                            .black
                                            : Colors
                                            .white,
                                        fontWeight:
                                        FontWeight
                                            .w700,
                                        fontSize:
                                        18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),

                      /// ADD THIS BELOW THE DIFFICULTY SECTION

                      const SizedBox(height: 34),

                      const Text(
                        "Question Types",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Column(
                        children: questionTypes.map((type) {
                          final isSelected =
                          selectedQuestionTypes.contains(type);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedQuestionTypes.remove(type);
                                  } else {
                                    selectedQuestionTypes.add(type);
                                  }
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white10,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                      const Duration(milliseconds: 200),
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        color: isSelected
                                            ? const Color(0xff4CD137)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xff4CD137)
                                              : Colors.white38,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                        Icons.check,
                                        size: 18,
                                        color: Colors.black,
                                      )
                                          : null,
                                    ),

                                    const SizedBox(width: 16),

                                    Text(
                                      type,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 26),

                      /// GENERATE BUTTON
                      /// CHANGE YOUR GENERATE BUTTON

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const QuizGeneratingScreen(),
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
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.auto_awesome,
                                color: Colors.black,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Generate Quiz with AI",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
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