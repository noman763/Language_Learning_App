import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  // Updated names to Muslim names
  final List<Map<String, dynamic>> users = const [
    {'name': 'Ali', 'score': 3, 'icon': Icons.person},
    {'name': 'Zain', 'score': 1, 'icon': Icons.face},
    {'name': 'Muhammad', 'score': 1, 'icon': Icons.sports_soccer},
    {'name': 'Bilal', 'score': 0, 'icon': Icons.person_outline},
    {'name': 'Hassan', 'score': 0, 'icon': Icons.star},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
          title: const Text('Leaderboard', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          // Top 3 users ko highlight karne ke liye logic
          bool isTop3 = index < 3;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isTop3 ? AppColors.accentPrimary.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: isTop3 ? Border.all(color: AppColors.accentPrimary.withOpacity(0.5)) : null,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              children: [
                Text('${index + 1}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isTop3 ? AppColors.accentSecondary : Colors.grey)),
                const SizedBox(width: 16),
                CircleAvatar(backgroundColor: AppColors.background, child: Icon(user['icon'], color: AppColors.accentPrimary)),
                const SizedBox(width: 16),
                Expanded(child: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontSize: 16))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.accentSecondary.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                  child: Text('${user['score']} XP', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentSecondary, fontSize: 14)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}