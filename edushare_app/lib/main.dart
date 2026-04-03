import 'package:flutter/material.dart';
import 'features/auth/presentation/screen/login_screen.dart'; // Import
import 'features/auth/presentation/screen/signup_screen.dart';

void main() {
  runApp(const EduShareApp());
}

class EduShareApp extends StatelessWidget {
  const EduShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF6366F1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
      ),
      // Gọi màn hình Login làm màn hình bắt đầu
      home: const LoginScreen(),
    );
  }
}
