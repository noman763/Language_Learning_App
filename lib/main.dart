import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'screens/auths/intro_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Learning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.accentPrimary,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accentPrimary),
      ),
      home: const IntroScreen(),
    );
  }
}