import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:language_learning_app/controllers/speaking_controller.dart';
import 'package:language_learning_app/models/speaking_model.dart';

class SpeakingScreen extends StatelessWidget {
  const SpeakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SpeakingController controller = Get.put(SpeakingController());

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        title: const Text("Speaking Practice",
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300)
            ),
            child: DropdownButtonHideUnderline(
              child: Obx(() => DropdownButton<String>(
                value: controller.selectedLanguage.value,
                icon: const Icon(Icons.language, color: Colors.teal, size: 20),
                items: speakingData.keys.map((lang) =>
                    DropdownMenuItem(value: lang, child: Text(lang))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    controller.selectedLanguage.value = val;
                    controller.loadRandomSentence();
                  }
                },
              )),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Target Sentence Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10)
                      )
                    ]
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Read aloud",
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                        IconButton(
                            icon: const Icon(Icons.skip_next, color: Colors.teal),
                            onPressed: controller.loadRandomSentence
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(() => Text(
                      controller.targetSentence.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: controller.selectedLanguage.value == "Urdu" ? 28 : 22,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Colors.black87
                      ),
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              GestureDetector(
                onLongPress: controller.startListening,
                onLongPressUp: controller.stopListening,
                child: Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(controller.isListening.value ? 45 : 35),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: controller.isListening.value
                            ? [Colors.redAccent, Colors.deepOrange]
                            : [Colors.teal, Colors.green]
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: (controller.isListening.value ? Colors.redAccent : Colors.teal).withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 5
                      )
                    ],
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 45),
                )),
              ),

              const SizedBox(height: 24),

              Obx(() => Text(
                  controller.isListening.value ? "Listening... Release to stop" : "Hold Mic to Speak",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: controller.isListening.value ? Colors.redAccent : Colors.grey.shade600
                  )
              )),

              const SizedBox(height: 30),

              // Loading Spinner
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.teal)
                  : const SizedBox()),

              // Feedback Result Card
              Obx(() => (!controller.isLoading.value && controller.feedback.value.isNotEmpty)
                  ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: controller.score.value >= 80 ? Colors.green : Colors.orange,
                        width: 2
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Score:", style: TextStyle(fontSize: 18, color: Colors.black54)),
                        Text("${controller.score.value.toInt()}%",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: controller.score.value >= 80 ? Colors.green : Colors.orange
                            )
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    const Text("You said:", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 5),
                    Text(
                        '"${controller.spokenText.value}"',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: controller.selectedLanguage.value == "Urdu" ? 20 : 16,
                            color: Colors.black87
                        )
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: controller.score.value >= 80 ? Colors.green.shade50 : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: [
                          Icon(
                              controller.score.value >= 80 ? Icons.check_circle : Icons.info,
                              color: controller.score.value >= 80 ? Colors.green : Colors.orange
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(
                                  controller.feedback.value,
                                  style: const TextStyle(fontWeight: FontWeight.w500)
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
                  : const SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}