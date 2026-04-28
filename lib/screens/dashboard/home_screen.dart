import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../modules/quiz_screen.dart';
import '../modules/writing_evaluation_screen.dart';
import '../features/instructor_screen.dart';
import '../modules/reading_screen.dart';
import '../modules/speaking_screen.dart';
import '../modules/listening_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back', style: TextStyle(color: Colors.grey, fontSize: 14)),
            Text('Dashboard',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 24
                )
            ),
          ],
        ),
        actions: [
          _buildTopFlag(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroBanner(),
              const SizedBox(height: 35),
              const Text(
                  'Explore Modules',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)
              ),
              const SizedBox(height: 20),
              _buildModulesGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopFlag() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.flag, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accentPrimary, AppColors.accentPrimary.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ready for today\'s lesson?', style: TextStyle(color: Colors.white70, fontSize: 16)),
          SizedBox(height: 8),
          Text('Let\'s get back to\nyour practice.',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)
          ),
        ],
      ),
    );
  }

  Widget _buildModulesGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 0.85,
      children: [
        HoverableModuleCard(
          title: 'Reading Practice',
          icon: Icons.menu_book_rounded,
          color: Colors.green,
          onTap: () => Get.to(() => const ReadingScreen()),
        ),
        HoverableModuleCard(
          title: 'Writing Eval',
          icon: Icons.edit_note_rounded,
          color: Colors.blueAccent,
          onTap: () => Get.to(() => WritingEvaluationScreen()),
        ),
        HoverableModuleCard(
          title: 'Speaking',
          icon: Icons.mic_rounded,
          color: Colors.pinkAccent,
          onTap: () => Get.to(() => SpeakingScreen()),
        ),
        HoverableModuleCard(
          title: 'Listening',
          icon: Icons.headphones_rounded,
          color: Colors.teal,
          onTap: () => Get.to(() => ListeningScreen()),
        ),
        HoverableModuleCard(
          title: 'Vocabulary Quiz',
          icon: Icons.quiz_rounded,
          color: Colors.orangeAccent,
          onTap: () => Get.to(() => const QuizScreen()),
        ),
        HoverableModuleCard(
          title: 'Find Tutor',
          icon: Icons.person_search_rounded,
          color: Colors.redAccent,
          onTap: () => Get.to(() => const InstructorScreen()),
        ),
      ],
    );
  }
}

// --- Professional InkWell Based Card ---
class HoverableModuleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const HoverableModuleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        splashColor: color.withValues(alpha: 0.3),
        highlightColor: color.withValues(alpha: 0.1),
        hoverColor: color.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                    icon,
                    size: 32,
                    color: color
                ),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}