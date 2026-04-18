import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'chat_screen.dart';

class InstructorScreen extends StatelessWidget {
  const InstructorScreen({super.key});

  final List<Map<String, dynamic>> tutors = const [
    {'name': 'Ahmed', 'languages': 'Urdu & English', 'rating': '4.9', 'reviews': '120'},
    {'name': 'Fatima', 'languages': 'Spanish & English', 'rating': '4.8', 'reviews': '85'},
    {'name': 'Omar', 'languages': 'Urdu Native', 'rating': '5.0', 'reviews': '200'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
          title: const Text('Find a Tutor', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary)
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tutors.length,
        itemBuilder: (context, index) {
          final tutor = tutors[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))]
            ),
            child: Row(
              children: [
                const CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.background,
                    child: Icon(Icons.person, size: 40, color: Colors.grey)
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tutor['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(tutor['languages'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('${tutor['rating']} (${tutor['reviews']} reviews)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
                  ),
                  child: const Text('Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}