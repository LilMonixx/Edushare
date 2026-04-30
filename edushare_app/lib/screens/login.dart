import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/CustomChip.dart';
import 'SplashScreen.dart';



class StudyShareScreen extends StatelessWidget {
  const StudyShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF4ADE80);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Icon box
              Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: green,
                      size: 50,
                    ),
                  ),

                  // small badge
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Title
              const Text(
                "StudyShare",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                "Share documents, solve\nproblems, and learn together",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // Buttons
              _buildButton(
                icon: Icons.menu_book_outlined,
                text: "Share Documents",
                color: green,
              ),
              const SizedBox(height: 14),

              _buildButton(
                icon: Icons.group_outlined,
                text: "Study Groups",
                color: green,
              ),
              const SizedBox(height: 14),

              _buildButton(
                icon: Icons.chat_bubble_outline,
                text: "Get Help",
                color: green,
              ),

              const SizedBox(height: 30),

              // Chips
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: const [
                  CustomChip(label: "Math"),
                  CustomChip(label: "English"),
                  CustomChip(label: "Science"),
                  CustomChip(label: "History"),
                  CustomChip(label: "Coding"),
                ],
              ),

              const SizedBox(height: 40),

// Google Butto
              GestureDetector(
                onTap: () async {
                  final auth = context.read<AuthProvider>();
                  await auth.loginWithGoogle();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/google_logo.png",
                        height: 32,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Continue with Google",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

// Terms text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                    children: [
                      const TextSpan(text: "By continuing, you agree to our ", style:
                      TextStyle(
                          fontSize: 18

                      )),
                      TextSpan(
                        text: "Terms of Service",
                        style: const TextStyle(
                          color: Color(0xFF4ADE80),
                          decoration: TextDecoration.underline,
                          fontSize: 18
                        ),
                      ),
                      const TextSpan(text: " and ",
                        style: const TextStyle(
                            fontSize: 18
                        ),),
                      TextSpan(
                        text: "Privacy Policy",
                        style: const TextStyle(
                          color: Color(0xFF4ADE80),
                          decoration: TextDecoration.underline,
                            fontSize: 18
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }



}

