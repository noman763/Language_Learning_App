import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/listening_controller.dart';
import '../../models/listening_model.dart';

class ListeningScreen extends StatelessWidget {
  ListeningScreen({super.key});

  final ListeningController controller = Get.put(ListeningController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        title: const Text("Listening Practice", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(() => DropdownButton<String>(
            value: controller.selectedLanguage.value,
            underline: const SizedBox(),
            items: listeningData.keys.map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
            onChanged: (val) {
              if (val != null) {
                controller.selectedLanguage.value = val;
                controller.loadRandomSentence();
              }
            },
          )),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(controller.isRobotSpeaking.value ? "Robot Speaking..." : "Listen carefully", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                      IconButton(icon: const Icon(Icons.volume_up, color: Colors.teal), onPressed: controller.robotSpeak)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    String text = controller.targetSentence.value;
                    int start = controller.currentWordStart.value;
                    int end = controller.currentWordEnd.value;
                    bool isUrdu = controller.selectedLanguage.value == "Urdu";
                    if (start > text.length || end > text.length) { start = 0; end = 0; }
                    return RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(text: text.substring(0, start), style: TextStyle(fontSize: isUrdu ? 28 : 22, color: Colors.black, height: 1.5)),
                          TextSpan(text: text.substring(start, end), style: TextStyle(fontSize: isUrdu ? 30 : 24, fontWeight: FontWeight.bold, color: Colors.white, backgroundColor: Colors.teal)),
                          TextSpan(text: text.substring(end), style: TextStyle(fontSize: isUrdu ? 28 : 22, color: Colors.black, height: 1.5)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 60),
            GestureDetector(
              onLongPress: controller.startListening,
              onLongPressUp: controller.stopListening,
              child: Obx(() => CircleAvatar(
                radius: 45,
                backgroundColor: controller.isListening.value ? Colors.red : Colors.teal,
                child: Icon(controller.isListening.value ? Icons.mic : Icons.mic_none, color: Colors.white, size: 40),
              )),
            ),
            const SizedBox(height: 15),
            Obx(() => Text(controller.isListening.value ? "Listening..." : "Hold Mic to Repeat", style: const TextStyle(fontWeight: FontWeight.bold))),
            Obx(() => controller.feedback.value.isNotEmpty ? Column(
              children: [
                const SizedBox(height: 40),
                Text("Score: ${controller.score.value.toInt()}%", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                Text(controller.feedback.value, style: const TextStyle(color: Colors.teal, fontSize: 20)),
                const SizedBox(height: 15),
                Text("You said: \"${controller.spokenText.value}\"", textAlign: TextAlign.center, style: const TextStyle(fontStyle: FontStyle.italic)),
              ],
            ) : const SizedBox(height: 150)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: controller.loadRandomSentence,
              icon: const Icon(Icons.skip_next),
              label: const Text("Next Sentence"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            ),
          ],
        ),
      ),
    );
  }
}