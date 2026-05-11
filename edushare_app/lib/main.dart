import 'package:edushare_app/providers/AnswerProvider.dart';
import 'package:edushare_app/providers/AuthGate.dart';
import 'package:edushare_app/providers/LikeProvider.dart';
import 'package:edushare_app/providers/NotificationProvider.dart';
import 'package:edushare_app/providers/post_provider.dart';
import 'package:edushare_app/providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';


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
        /// 🔥 AUTH
        ChangeNotifierProvider(
          create: (_) {
            final auth = AuthProvider();
            auth.init();
            return auth;
          },
        ),

        ChangeNotifierProvider(
          create: (_) => QuestionProvider(),
        ),

        /// 🔥 POSTS
        ChangeNotifierProvider(
          create: (_) => PostProvider(),
        ),

        /// 🔥 ANSWERS (QUAN TRỌNG)
        ChangeNotifierProvider(
          create: (_) => AnswerProvider(),
        ),

        ChangeNotifierProvider(create: (_) => LikeProvider()),

        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'EduShare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: const AuthGate(),
      ),
    );
  }
}