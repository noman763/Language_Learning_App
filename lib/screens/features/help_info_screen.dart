import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class HelpInfoScreen extends StatelessWidget {
  const HelpInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text(
          'Help & Info',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Frequently Asked Questions"),
            const SizedBox(height: 10),
            _buildFAQTile("How to start learning?", "Select a language from the home screen and choose a tutor or practice module."),
            _buildFAQTile("Is the chatbot free?", "Yes, you can practice with our AI tutors for free anytime."),
            _buildFAQTile("How to contact a tutor?", "Go to the 'Find a Tutor' screen and click the 'Chat' button on their profile."),
            _buildFAQTile("Can I change my native language?", "Yes, you can update your profile settings to change your primary language."),

            const SizedBox(height: 30),
            _buildSectionHeader("Contact Support"),
            const SizedBox(height: 10),
            _buildContactCard(Icons.email_outlined, "Email Us", "support@linguaapp.com"),
            _buildContactCard(Icons.language_outlined, "Visit Website", "www.linguaapp.com"),

            const SizedBox(height: 30),
            _buildSectionHeader("App Information"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  _InfoRow("App Version", "1.0.4 (Build 22)"),
                  Divider(),
                  _InfoRow("Terms of Service", "Read Documents"),
                  Divider(),
                  _InfoRow("Privacy Policy", "Read Documents"),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Center(
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(answer, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentPrimary),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: AppColors.accentPrimary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}