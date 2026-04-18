import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_colors.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('score', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Data load karne mein masla hai"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentPrimary),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Abhi koi players nahi hain"));
          }

          final userDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              // Firebase ke document se data nikalna
              final userData = userDocs[index].data() as Map<String, dynamic>;

              // Aapki Firestore fields ke mutabiq names
              final String name = userData['name'] ?? 'Guest User';
              final int score = userData['score'] ?? 0;

              bool isTop3 = index < 3;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isTop3
                      ? AppColors.accentPrimary.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: isTop3
                      ? Border.all(color: AppColors.accentPrimary.withOpacity(0.5))
                      : null,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4)
                  ],
                ),
                child: Row(
                  children: [
                    // Rank Number
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isTop3 ? AppColors.accentSecondary : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Profile Icon
                    CircleAvatar(
                      backgroundColor: AppColors.background,
                      child: Icon(
                        isTop3 ? Icons.emoji_events : Icons.person,
                        color: isTop3 ? Colors.orange : AppColors.accentPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // User Name
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    // Score Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentSecondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$score XP',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}