import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../models/speaking_model.dart';

class SpeakingController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();

  var isListening = false.obs;
  var isLoading = false.obs;
  var selectedLanguage = "English".obs;
  var targetSentence = "".obs;
  var spokenText = "".obs;
  var feedback = "".obs;
  var score = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    loadRandomSentence();
  }

  void _initSpeech() async {
    await Permission.microphone.request();
    await _speech.initialize(
      onStatus: (status) {
        if ((status == "done" || status == "notListening") && isListening.value) {
          stopListening();
        }
      },
    );
  }

  void loadRandomSentence() {
    final sentences = speakingData[selectedLanguage.value]!.sentences;
    targetSentence.value = sentences[Random().nextInt(sentences.length)];
    spokenText.value = "";
    feedback.value = "";
    score.value = 0;
  }

  void startListening() async {
    spokenText.value = "";
    feedback.value = "";
    score.value = 0;
    isListening.value = true;

    await _speech.listen(
      onResult: (val) => spokenText.value = val.recognizedWords,
      localeId: speakingData[selectedLanguage.value]!.sttLocale,
      pauseFor: const Duration(seconds: 4),
    );
  }

  void stopListening() async {
    await _speech.stop();
    isListening.value = false;
    if (spokenText.value.isNotEmpty) analyzeVoice();
  }

  Future<void> analyzeVoice() async {
    isLoading.value = true;
    String ltCode = speakingData[selectedLanguage.value]!.ltCode;

    String cleanTarget = targetSentence.value.toLowerCase().replaceAll(RegExp(r'[.,!?¿¡،۔]+'), '');
    String cleanSpoken = spokenText.value.toLowerCase().replaceAll(RegExp(r'[.,!?¿¡،۔]+'), '');

    List<String> targetWords;
    List<String> spokenWords;

    if (selectedLanguage.value == "Chinese") {
      targetWords = cleanTarget.split('');
      spokenWords = cleanSpoken.split('');
    } else {
      targetWords = cleanTarget.split(' ');
      spokenWords = cleanSpoken.split(' ');
    }

    int total = targetWords.length;
    int correct = 0;
    for (var word in spokenWords) {
      if (targetWords.contains(word)) {
        correct++;
        targetWords.remove(word);
      }
    }

    double resScore = (correct / (total == 0 ? 1 : total)) * 100;
    score.value = resScore.clamp(0, 100);

    List matches = [];
    if (ltCode != "auto") {
      try {
        final response = await http.post(
          Uri.parse("https://api.languagetool.org/v2/check"),
          body: {"text": spokenText.value, "language": ltCode},
        );
        matches = jsonDecode(response.body)["matches"] ?? [];
      } catch (e) {}
    }

    if (score.value < 40) {
      feedback.value = "Please try speaking a bit louder and clearer. 🎤";
    } else if (score.value >= 99) {
      score.value = 100;
      feedback.value = "Perfect! Moving to the next sentence... 🎉➡️";
      Future.delayed(const Duration(seconds: 2), () => loadRandomSentence());
    } else if (matches.isEmpty) {
      feedback.value = "Good pronunciation, but you missed some words. Keep trying! 👍";
    } else {
      feedback.value = "You made ${matches.length} grammar/word mistake(s). Keep practicing! 💪";
    }

    isLoading.value = false;
  }
}