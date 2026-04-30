import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';



class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late TextEditingController _controller;
  bool canPost = false;


  XFile? cameraFile;
  List<XFile> images = [];
  List<XFile> files = [];

  final List<String> subjects = [
    "Math",
    "English",
    "Physics",
    "Chemistry",
    "Biology",
    "History",
    "Geography",
    "Literature",
    "Computer Science",
    "Economics",
    "Art",
    "Music",
    "Philosophy",
    "Psychology",
    "Sociology",
    "Political Science",
    "Law",
    "Statistics",
    "Engineering",
    "Business"
  ];

  String selectedSubject = "Math";

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();

    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;

      if (hasText != canPost) {
        setState(() {
          canPost = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> takePhoto() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.camera);

    if (img != null) {
      setState(() {
        images.add(img);
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        images.add(img);
      });
    }
  }


  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // 🔥 QUAN TRỌNG
    );

    if (result != null) {
      setState(() {
        files.addAll(result.files.map((e) => XFile(e.path!)));
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF00FF88);
    final user = context.watch<AuthProvider>().user;
    //final uid = user?.uid;
    final postProvider = context.watch<PostProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: Colors.white),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Create Post",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  /// POST BUTTON
                  GestureDetector(
                    onTap: (canPost && !postProvider.loading)
                        ? () async {
                      final uid = user?.uid;
                      if (uid == null) return;

                      final success = await postProvider.createPost(
                        content: _controller.text.trim(),
                        subject: selectedSubject,
                      );

                      if (success && context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: (canPost && !postProvider.loading)
                            ? green
                            : Colors.white12,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: postProvider.loading
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white, // cho nó visible trên nền tối
                        ),
                      )
                          : Text(
                        "Post",
                        style: TextStyle(
                          color: (canPost && !postProvider.loading)
                              ? Colors.black
                              : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const Divider(color: Colors.white12, height: 1),

            /// BODY
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// USER INFO
                    Row(
                      children: [
                        /// AVATAR
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: green,
                          backgroundImage: (user?.photoURL != null &&
                              user!.photoURL!.isNotEmpty)
                              ? NetworkImage(user.photoURL!)
                              : null,
                          child: (user?.photoURL == null || user!.photoURL!.isEmpty)
                              ? Text(
                            (user?.displayName != null &&
                                user!.displayName!.isNotEmpty)
                                ? user.displayName![0].toUpperCase()
                                : "?",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : null,
                        ),

                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// NAME
                            Text(
                              user?.displayName ?? "User",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 6),

                            GestureDetector(
                              onTap: () async {
                                final value = await showModalBottomSheet<String>(
                                  context: context,
                                  backgroundColor: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  builder: (_) {
                                    return ListView(
                                      padding: const EdgeInsets.all(16),
                                      children: subjects.map((s) {
                                        final isSelected = s == selectedSubject;

                                        return ListTile(
                                          title: Text(
                                            s,
                                            style: TextStyle(
                                              color: isSelected ? green : Colors.white,
                                              fontWeight:
                                              isSelected ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                          trailing: isSelected
                                              ? Icon(Icons.check, color: green)
                                              : null,
                                          onTap: () {
                                            Navigator.pop(context, s);
                                          },
                                        );
                                      }).toList(),
                                    );
                                  },
                                );

                                if (value != null) {
                                  setState(() {
                                    selectedSubject = value;
                                  });
                                }
                              },

                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.circle, size: 8, color: green),
                                    const SizedBox(width: 6),

                                    /// TEXT (giữ UI cũ)
                                    Text(
                                      selectedSubject,
                                      style: const TextStyle(color: Colors.white),
                                    ),

                                    const SizedBox(width: 4),

                                    const Icon(Icons.keyboard_arrow_down,
                                        size: 16, color: Colors.white54),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    if (images.isNotEmpty || files.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [

                            /// IMAGES
                            ...images.map((img) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: FileImage(File(img.path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),


                                  Positioned(
                                    right: -8,
                                    top: -8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          images.remove(img);
                                        });
                                      },
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),

                            /// FILES
                            ...files.map((f) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.insert_drive_file, color: Colors.white),
                                    const SizedBox(width: 6),

                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        f.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),

                                    const SizedBox(width: 6),

                                    /// ❌ REMOVE BUTTON FIX
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          files.remove(f);
                                        });
                                      },
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                    /// TEXT FIELD (BIG)
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        expands: true,
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          hintText: "What do you need help with?",
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 20,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const Divider(color: Colors.white12),

                    const SizedBox(height: 10),

                    const Text(
                      "Add to your post",
                      style: TextStyle(color: Colors.white54),
                    ),

                    const SizedBox(height: 12),

                    /// ACTION BUTTONS
                    Row(
                      children: [
                        _buildActionButton(Icons.camera_alt, "Camera", green, takePhoto),
                        const SizedBox(width: 10),
                        _buildActionButton(Icons.image, "Photo", green, pickImage),
                        const SizedBox(width: 10),
                        _buildActionButton(Icons.insert_drive_file, "File", green, pickFile),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// BUTTON REUSE
  static Widget _buildActionButton(
      IconData icon,
      String text,
      Color color,
      VoidCallback onTap,
      ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}