import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CreatePostScreen(),
    );
  }
}

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF00FF88);

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
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Post",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
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
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: green,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              "J",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "John Doe",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 6),

                            /// SUBJECT CHIP
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.circle,
                                      size: 8, color: green),
                                  SizedBox(width: 6),
                                  Text("Math"),
                                  SizedBox(width: 4),
                                  Icon(Icons.keyboard_arrow_down,
                                      size: 16, color: Colors.white54),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// TEXT FIELD (BIG)
                    const Expanded(
                      child: TextField(
                        maxLines: null,
                        expands: true,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
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
                        _buildActionButton(Icons.camera_alt, "Camera", green),
                        const SizedBox(width: 10),
                        _buildActionButton(Icons.image, "Photo", green),
                        const SizedBox(width: 10),
                        _buildActionButton(Icons.insert_drive_file, "File", green),
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
      IconData icon, String text, Color color) {
    return Expanded(
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
    );
  }
}