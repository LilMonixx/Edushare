import 'package:edushare_app/providers/AuthGate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'Database/db_helper.dart';
import 'providers/auth_provider.dart';
import 'providers/question_provider.dart';
import 'repository/question_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const EduShareApp());
}

class EduShareApp extends StatelessWidget {
  const EduShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 🔥 AUTH
        ChangeNotifierProvider(
          create: (_) {
            final auth = AuthProvider();
            auth.init(); // ✅ đúng
            return auth;
          },
        ),

        // 🔥 QUESTIONS (giữ nếu mày còn dùng)
        ChangeNotifierProvider(
          create: (_) => QuestionProvider(
            QuestionRepository(DBHelper()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'EduShare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: const AuthGate(), // ✅ chỉ dùng cái này
      ),
    );
  }
}