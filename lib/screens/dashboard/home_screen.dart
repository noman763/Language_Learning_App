import 'package:flutter/material.dart';
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal)),
            Text('Dashboard', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: 0.5)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 8, bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.orange.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: const Icon(Icons.flag, color: Colors.white, size: 22),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stylish Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.accentPrimary, AppColors.accentPrimary.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: AppColors.accentPrimary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ready for today\'s lesson?', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Let\'s get back to\nyour practice.', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              const Text('Explore Modules', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 20),

              // Grid View for Modules
              GridView.count(
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReadingScreen()))
                  ),
                  HoverableModuleCard(
                      title: 'Writing Eval',
                      icon: Icons.edit_note_rounded,
                      color: Colors.blueAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WritingEvaluationScreen()))
                  ),
                  HoverableModuleCard(
                      title: 'Speaking',
                      icon: Icons.mic_rounded,
                      color: Colors.pinkAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpeakingScreen()))
                  ),
                  HoverableModuleCard(
                      title: 'Listening',
                      icon: Icons.headphones_rounded,
                      color: Colors.teal,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ListeningScreen()))
                  ),
                  HoverableModuleCard(
                      title: 'Vocabulary Quiz',
                      icon: Icons.quiz_rounded,
                      color: Colors.orangeAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen()))
                  ),
                  HoverableModuleCard(
                      title: 'Find Tutor',
                      icon: Icons.person_search_rounded,
                      color: Colors.redAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InstructorScreen()))
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


class HoverableModuleCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const HoverableModuleCard({super.key, required this.title, required this.icon, required this.color, required this.onTap});

  @override
  State<HoverableModuleCard> createState() => _HoverableModuleCardState();
}

class _HoverableModuleCardState extends State<HoverableModuleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) {
          setState(() => _isHovered = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          decoration: BoxDecoration(
            color: _isHovered ? widget.color : Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _isHovered ? 0.5 : 0.1),
                blurRadius: _isHovered ? 25 : 10,
                offset: Offset(0, _isHovered ? 12 : 5),
              )
            ],
            border: Border.all(color: _isHovered ? widget.color : Colors.transparent, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _isHovered ? Colors.white : widget.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  boxShadow: _isHovered ? const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))] : [],
                ),
                child: Icon(
                  widget.icon,
                  size: _isHovered ? 42 : 36,
                  color: _isHovered ? widget.color : widget.color,
                ),
              ),
              const SizedBox(height: 20),

              // Title Text
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: _isHovered ? Colors.white : AppColors.textPrimary,
                  fontFamily: 'Roboto',
                ),
                child: Text(widget.title, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}