import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:language_learning_app/core/app_colors.dart';
import 'package:language_learning_app/controllers/reading_controller.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReadingController controller = Get.put(ReadingController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reading Practice',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Select Language:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 10),

              // Language Chips
              Obx(() => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.languages.map((lang) => ChoiceChip(
                  label: Text(lang),
                  selected: controller.selectedLanguage.value == lang,
                  onSelected: (bool selected) {
                    if (selected) controller.changeLanguage(lang);
                  },
                  selectedColor: AppColors.accentPrimary,
                  labelStyle: TextStyle(
                    color: controller.selectedLanguage.value == lang ? Colors.white : AppColors.textPrimary,
                  ),
                )).toList(),
              )),

              const SizedBox(height: 20),

              // Main Content Area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                    ],
                  ),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Obx(() => Row(
                        children: [
                          const Icon(Icons.menu_book, color: AppColors.accentPrimary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                "${controller.selectedLanguage.value} Passage",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)
                            ),
                          ),
                        ],
                      )),
                      const Divider(height: 30, thickness: 1),

                      // Passage Text
                      Obx(() => Text(
                        controller.currentPassage.text,
                        textAlign: controller.selectedLanguage.value == "Urdu" ? TextAlign.right : TextAlign.left,
                        style: TextStyle(
                            fontSize: controller.selectedLanguage.value == "Urdu" ? 18 : 16,
                            height: 1.8,
                            color: AppColors.textPrimary
                        ),
                      )),

                      const SizedBox(height: 30),

                      // Translation / Summary Box
                      Obx(() => Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.accentSecondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.accentSecondary.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.g_translate, color: AppColors.accentSecondary, size: 20),
                                SizedBox(width: 8),
                                Text('Summary / Translation',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentSecondary)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              controller.currentPassage.translation,
                              textAlign: controller.selectedLanguage.value == "Urdu" ? TextAlign.right : TextAlign.left,
                              style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}