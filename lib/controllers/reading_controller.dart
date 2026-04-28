import 'package:get/get.dart';
import '../models/reading_model.dart';

class ReadingController extends GetxController {
  var selectedLanguage = 'English'.obs;
  var currentPassageIndex = 0.obs;

  final List<String> languages = [
    'English', 'Urdu', 'Spanish', 'French', 'Chinese', 'Italian'
  ];

  ReadingPassage get currentPassage {
    var passages = readingData[selectedLanguage.value] ?? [];
    if (passages.isEmpty) {
      return ReadingPassage(text: 'No data available.', translation: '');
    }
    return passages[currentPassageIndex.value];
  }

  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    currentPassageIndex.value = 0; // Reset index when language changes
  }
}