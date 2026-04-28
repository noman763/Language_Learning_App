import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/listening_model.dart';

class ListeningController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  var isListening = false.obs;
  var isRobotSpeaking = false.obs;
  var isLoading = false.obs;
  var selectedLanguage = "English".obs;
  var targetSentence = "".obs;
  var spokenText = "".obs;
  var feedback = "".obs;
  var score = 0.0.obs;
  var currentWordStart = 0.obs;
  var currentWordEnd = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeechAndTts();
  }

  void _initSpeechAndTts() async {
    await Permission.microphone.request();
    await _speech.initialize();

    _tts.setProgressHandler((String text, int start, int end, String word) {
      currentWordStart.value = start;
      currentWordEnd.value = end;
    });

    _tts.setCompletionHandler(() {
      isRobotSpeaking.value = false;
      currentWordStart.value = 0;
      currentWordEnd.value = 0;
    });

    loadRandomSentence();
  }

  void loadRandomSentence() {
    final data = listeningData[selectedLanguage.value];
    if (data == null) return;

    final random = Random();
    targetSentence.value = data.sentences[random.nextInt(data.sentences.length)];

    spokenText.value = "";
    feedback.value = "";
    score.value = 0;
    currentWordStart.value = 0;
    currentWordEnd.value = 0;

    Future.delayed(const Duration(milliseconds: 600), () => robotSpeak());
  }

  Future<void> robotSpeak() async {
    final data = listeningData[selectedLanguage.value]!;
    await _tts.setLanguage(data.ttsLocale);
    await _tts.setSpeechRate(0.4);
    isRobotSpeaking.value = true;
    await _tts.speak(targetSentence.value);
  }

  void startListening() async {
    if (isRobotSpeaking.value) await _tts.stop();
    spokenText.value = "";
    isListening.value = true;
    String locale = listeningData[selectedLanguage.value]!.sttLocale;
    await _speech.listen(
      onResult: (val) => spokenText.value = val.recognizedWords,
      localeId: locale,
    );
  }

  void stopListening() async {
    await _speech.stop();
    isListening.value = false;
    if (spokenText.value.isNotEmpty) analyzeVoice();
  }

  void analyzeVoice() {
    isLoading.value = true;
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

    int totalToMatch = targetWords.length;
    int correct = 0;

    for (var word in spokenWords) {
      if (targetWords.contains(word)) {
        correct++;
        targetWords.remove(word);
      }
    }

    double resScore = (correct / totalToMatch) * 100;
    score.value = resScore.clamp(0, 100);
    feedback.value = score.value >= 90 ? "Excellent! 🎉" : score.value >= 60 ? "Good Job! 👍" : "Keep practicing! 💪";
    isLoading.value = false;

    if (score.value >= 99) {
      Future.delayed(const Duration(seconds: 2), () => loadRandomSentence());
    }
  }

  @override
  void onClose() {
    _speech.stop();
    _tts.stop();
    super.onClose();
  }
}