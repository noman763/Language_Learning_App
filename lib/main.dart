import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'screens/auths/intro_screen.dart';
import 'screens/dashboard/main_navigation.dart';
import 'firebase_options.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. ValueListenableBuilder use kiya taake theme switch hote hi app update ho
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Language Learning App',
          debugShowCheckedModeBanner: false,

          // Light Theme configuration
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.background,
            primaryColor: AppColors.accentPrimary,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accentPrimary),
          ),

          // 3. Dark Theme configuration add ki
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
            primaryColor: AppColors.accentPrimary,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accentPrimary,
              surface: Color(0xFF1E1E1E),
            ),
          ),

          themeMode: currentMode, // Current mode (light ya dark)

          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasData) {
                return const MainNavigation();
              }
              return const IntroScreen();
            },
          ),
        );
      },
    );
  }
}