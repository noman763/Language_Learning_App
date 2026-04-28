import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../controllers/quiz_controller.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizController controller = Get.put(QuizController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Language Quiz',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        centerTitle: true,
      ),
      body: Obx(() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildCurrentView(controller),
        ),
      )),
    );
  }

  Widget _buildCurrentView(QuizController controller) {
    switch (controller.currentStep.value) {
      case 0: return _buildLanguageSelection(controller);
      case 1: return _buildDifficultySelection(controller);
      case 2: return _buildQuizView(controller);
      case 3: return _buildResultView(controller);
      default: return _buildLanguageSelection(controller);
    }
  }

  Widget _buildLanguageSelection(QuizController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Select Language Pair',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        const Text('Choose the language you want to practice today.',
            style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: controller.languages.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text(controller.languages[index],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.accentPrimary, size: 20),
                  onTap: () {
                    controller.selectedLanguage.value = controller.languages[index];
                    controller.currentStep.value = 1;
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySelection(QuizController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Selected: ${controller.selectedLanguage.value}',
            style: const TextStyle(fontSize: 18, color: AppColors.accentPrimary, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 30),
        const Text('Choose Difficulty Level',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            textAlign: TextAlign.center),
        const SizedBox(height: 40),
        ...controller.difficulties.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () => controller.startQuiz(entry.key, entry.value),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${entry.key} Mode  ',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  Text('(${entry.value} MCQs)', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => controller.currentStep.value = 0,
          child: const Text('Back to Languages', style: TextStyle(color: Colors.grey, fontSize: 16)),
        )
      ],
    );
  }

  Widget _buildQuizView(QuizController controller) {
    final questionData = controller.quizData[controller.currentQuestionIndex.value];
    final List<String> options = List<String>.from(questionData['options']);
    final int correctIndex = questionData['correctIndex'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Question ${controller.currentQuestionIndex.value + 1} of ${controller.totalQuestions.value}',
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: AppColors.accentSecondary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
              child: Text('Score: ${controller.score.value}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.accentSecondary)),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]),
          child: Center(
              child: Text(questionData['question'],
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  textAlign: TextAlign.center)),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              Color buttonColor = Colors.white;
              Color textColor = AppColors.textPrimary;

              if (controller.isAnswered.value) {
                if (index == correctIndex) {
                  buttonColor = Colors.green;
                  textColor = Colors.white;
                } else if (index == controller.selectedOption.value) {
                  buttonColor = Colors.redAccent;
                  textColor = Colors.white;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () => controller.checkAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: controller.isAnswered.value ? 0 : 2,
                  ),
                  child: Text(options[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),
        ),
        if (controller.isAnswered.value)
          ElevatedButton(
            onPressed: () => controller.nextQuestion(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              controller.currentQuestionIndex.value == controller.totalQuestions.value - 1
                  ? 'Finish Quiz'
                  : 'Next Question',
              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildResultView(QuizController controller) {
    double percentage = (controller.score.value / controller.totalQuestions.value) * 100;
    String feedbackMessage =
    percentage >= 80 ? 'Excellent Work! 🎉' : (percentage >= 50 ? 'Good Effort! 👍' : 'Keep Practicing! 💪');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
        const SizedBox(height: 20),
        const Text('Quiz Completed!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Text(feedbackMessage, style: const TextStyle(fontSize: 20, color: Colors.grey), textAlign: TextAlign.center),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]),
          child: Column(
            children: [
              const Text('Your Score', style: TextStyle(fontSize: 20, color: Colors.grey)),
              const SizedBox(height: 10),
              Text('${controller.score.value} / ${controller.totalQuestions.value}',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.accentPrimary)),
            ],
          ),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () => controller.resetQuiz(),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          child: const Text('Play Again',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}