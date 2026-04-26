import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/grammar_error_model.dart';

class WritingController extends GetxController {
  var selectedLanguage = 'English'.obs;
  var isLoading = false.obs;
  var hasEvaluated = false.obs;
  var score = 100.obs;
  var issues = <GrammarIssue>[].obs;

  final List<String> languages = ['English', 'Urdu', 'Spanish', 'French', 'Chinese', 'Italian'];

  final Map<String, String> languageCodes = {
    'English': 'en-US', 'Urdu': 'auto', 'Spanish': 'es',
    'French': 'fr', 'Chinese': 'zh-CN', 'Italian': 'it'
  };

  void updateLanguage(String lang) {
    selectedLanguage.value = lang;
    hasEvaluated.value = false;
    issues.clear();
  }

  Future<void> evaluateText(String text) async {
    if (text.trim().isEmpty) return;
    try {
      isLoading(true);
      hasEvaluated(false);
      issues.clear();

      var response = await http.post(
        Uri.parse('https://api.languagetool.org/v2/check'),
        body: {'text': text, 'language': languageCodes[selectedLanguage.value] ?? 'en-US'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List matches = data['matches'] ?? [];

        // Data mapping
        issues.value = matches.map((m) => GrammarIssue.fromJson(m)).toList();
        score.value = (100 - (issues.length * 5)).clamp(0, 100);
        hasEvaluated(true);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}