import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'chat_screen.dart';

class InstructorScreen extends StatefulWidget {
  const InstructorScreen({super.key});

  @override
  State<InstructorScreen> createState() => _InstructorScreenState();
}

class _InstructorScreenState extends State<InstructorScreen> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> tutors = const [
    {'name': 'Ahmed', 'languages': 'Urdu & English', 'rating': '4.9', 'reviews': '120', 'isOnline': true, 'price': '\$15/hr', 'flag': '🇵🇰', 'categories': ['Urdu', 'English']},
    {'name': 'Sarah', 'languages': 'French & English', 'rating': '4.7', 'reviews': '95', 'isOnline': true, 'price': '\$22/hr', 'flag': '🇫🇷', 'categories': ['French', 'English']},
    {'name': 'Fatima', 'languages': 'Spanish & English', 'rating': '4.8', 'reviews': '85', 'isOnline': false, 'price': '\$20/hr', 'flag': '🇪🇸', 'categories': ['Spanish', 'English']},
    {'name': 'Marco', 'languages': 'Italian Native', 'rating': '4.9', 'reviews': '110', 'isOnline': true, 'price': '\$18/hr', 'flag': '🇮🇹', 'categories': ['Italian']},
    {'name': 'Wei Chen', 'languages': 'Chinese & English', 'rating': '5.0', 'reviews': '150', 'isOnline': true, 'price': '\$25/hr', 'flag': '🇨🇳', 'categories': ['Chinese', 'English']},
    {'name': 'John', 'languages': 'English Native', 'rating': '4.6', 'reviews': '210', 'isOnline': false, 'price': '\$30/hr', 'flag': '🇺🇸', 'categories': ['English']},
  ];

  List<Map<String, dynamic>> get filteredTutors {
    if (selectedFilter == 'All') return tutors;
    return tutors.where((tutor) {
      final List<String> categories = tutor['categories'];
      return categories.contains(selectedFilter);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text(
          'Find a Tutor',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 22),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          _buildFilterList(),
          Expanded(
            child: filteredTutors.isEmpty
                ? const Center(child: Text("No tutors found for this language"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: filteredTutors.length,
              itemBuilder: (context, index) => _buildTutorCard(context, filteredTutors[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterList() {
    final filters = ['All', 'English', 'Urdu', 'French', 'Spanish', 'Italian', 'Chinese'];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          bool isSelected = selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentPrimary : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: isSelected ? AppColors.accentPrimary : Colors.grey.shade300),
                boxShadow: isSelected ? [BoxShadow(color: AppColors.accentPrimary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTutorCard(BuildContext context, Map<String, dynamic> tutor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade100,
                  child: Text(tutor['flag'], style: const TextStyle(fontSize: 25)),
                ),
                if (tutor['isOnline'])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutor['name'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Text(
                    tutor['languages'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      Text(
                        ' ${tutor['rating']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Text('(${tutor['reviews']})', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tutor['price'],
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentPrimary, fontSize: 15),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        tutorName: tutor['name'],
                        tutorFlag: tutor['flag'],
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(60, 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Chat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}