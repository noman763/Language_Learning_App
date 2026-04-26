import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../controllers/writing_controller.dart';

class WritingEvaluationScreen extends StatelessWidget {
  WritingEvaluationScreen({super.key});

  final WritingController controller = Get.put(WritingController());
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Writing Evaluation',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Select Target Language:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 10),

              // Language Dropdown (Obx ke sath taake change foran dikhe)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
                child: DropdownButtonHideUnderline(
                  child: Obx(() => DropdownButton<String>(
                    value: controller.selectedLanguage.value,
                    isExpanded: true,
                    icon: const Icon(Icons.language, color: AppColors.accentPrimary),
                    items: controller.languages.map((String lang) {
                      return DropdownMenuItem<String>(
                        value: lang,
                        child: Text(lang, style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      controller.updateLanguage(newValue!);
                    },
                  )),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Write your text here:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]),
                child: TextField(
                  controller: _textController,
                  maxLines: 7,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    // Obx use kiya hint text change karne ke liye
                    hintText: "Type something...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Button aur Loading State (Obx ke sath)
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator(color: AppColors.accentPrimary))
                  : ElevatedButton(
                onPressed: () => controller.evaluateText(_textController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                ),
                child: const Text('Analyze Text', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              )),

              const SizedBox(height: 30),

              // Results Section (Obx ke sath)
              Obx(() => controller.hasEvaluated.value
                  ? _buildResultsSection()
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    bool isPerfect = controller.issues.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Evaluation Report', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 15),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isPerfect ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isPerfect ? Colors.green : Colors.orange),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Score', style: TextStyle(fontSize: 16, color: isPerfect ? Colors.green[700] : Colors.orange[800])),
                  Text(isPerfect ? 'Perfect! 🎉' : 'Needs Improvement', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isPerfect ? Colors.green : Colors.orange[800])),
                ],
              ),
              Text('${controller.score.value}/100', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: isPerfect ? Colors.green : Colors.orange[800])),
            ],
          ),
        ),

        const SizedBox(height: 20),

        if (!isPerfect) ...[
          const Text('Suggestions & Corrections:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ...controller.issues.map((issue) {
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.redAccent.withOpacity(0.3)), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 8),
                      Text(issue.type, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Mistake: ${issue.message}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                  const SizedBox(height: 5),
                  Text('Suggestion: ${issue.suggestion}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            );
          }).toList()
        ] else ...[
          const Center(
            child: Text("No grammar or spelling mistakes found. Great job!", style: TextStyle(color: Colors.grey, fontSize: 16, fontStyle: FontStyle.italic)),
          )
        ],
      ],
    );
  }
}