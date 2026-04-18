import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_colors.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentStep = 0;
  String _selectedLanguage = '';
  String _selectedDifficulty = '';
  int _totalQuestions = 0;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _selectedOption = -1;
  bool _isAnswered = false;

  final List<String> _languages = [
    'English to Urdu', 'Urdu to English',
    'English to Spanish', 'Spanish to English',
    'English to French', 'French to English',
    'English to Chinese', 'Chinese to English',
    'English to Italian', 'Italian to English'
  ];

  final Map<String, int> _difficulties = {
    'Basic': 15,
    'Medium': 30,
    'Hard': 50,
  };

  List<Map<String, dynamic>> _quizData = [];

  final Map<String, List<Map<String, dynamic>>> _questionBank = {
    'English to Urdu': [
      {'question': 'What is the translation of "Water"?', 'options': ['Pani', 'Aag', 'Hawa', 'Mitti'], 'correctIndex': 0},
      {'question': 'What is the translation of "Book"?', 'options': ['Kalam', 'Kitab', 'Basta', 'Mez'], 'correctIndex': 1},
      {'question': 'What is the translation of "House"?', 'options': ['Dukan', 'Daftar', 'Ghar', 'Bazar'], 'correctIndex': 2},
      {'question': 'What is the translation of "Sun"?', 'options': ['Chand', 'Sitara', 'Aasman', 'Suraj'], 'correctIndex': 3},
      {'question': 'What is the translation of "Friend"?', 'options': ['Dost', 'Dushman', 'Bhai', 'Parosi'], 'correctIndex': 0},
    ],
    'Urdu to English': [
      {'question': 'What is the translation of "Kitab"?', 'options': ['Pen', 'Book', 'Bag', 'Table'], 'correctIndex': 1},
      {'question': 'What is the translation of "Pani"?', 'options': ['Water', 'Fire', 'Air', 'Earth'], 'correctIndex': 0},
      {'question': 'What is the translation of "Ghar"?', 'options': ['Shop', 'Office', 'House', 'Market'], 'correctIndex': 2},
      {'question': 'What is the translation of "Dost"?', 'options': ['Enemy', 'Brother', 'Neighbor', 'Friend'], 'correctIndex': 3},
      {'question': 'What is the translation of "Suraj"?', 'options': ['Sun', 'Moon', 'Star', 'Sky'], 'correctIndex': 0},
    ],
    'English to Spanish': [
      {'question': 'What is the translation of "Hello"?', 'options': ['Adiós', 'Hola', 'Gracias', 'Por favor'], 'correctIndex': 1},
      {'question': 'What is the translation of "Cat"?', 'options': ['Gato', 'Perro', 'Pájaro', 'Pez'], 'correctIndex': 0},
      {'question': 'What is the translation of "Water"?', 'options': ['Fuego', 'Tierra', 'Agua', 'Aire'], 'correctIndex': 2},
      {'question': 'What is the translation of "Thank you"?', 'options': ['Hola', 'De nada', 'Adiós', 'Gracias'], 'correctIndex': 3},
      {'question': 'What is the translation of "Good morning"?', 'options': ['Buenos días', 'Buenas tardes', 'Buenas noches', 'Hola'], 'correctIndex': 0},
    ],
    'Spanish to English': [
      {'question': 'What is the translation of "Hola"?', 'options': ['Goodbye', 'Hello', 'Thank you', 'Please'], 'correctIndex': 1},
      {'question': 'What is the translation of "Perro"?', 'options': ['Cat', 'Dog', 'Bird', 'Fish'], 'correctIndex': 1},
      {'question': 'What is the translation of "Agua"?', 'options': ['Fire', 'Earth', 'Water', 'Air'], 'correctIndex': 2},
      {'question': 'What is the translation of "Gracias"?', 'options': ['Hello', 'You\'re welcome', 'Goodbye', 'Thank you'], 'correctIndex': 3},
      {'question': 'What is the translation of "Adiós"?', 'options': ['Goodbye', 'Hello', 'Good morning', 'Please'], 'correctIndex': 0},
    ],
    'English to French': [
      {'question': 'What is the translation of "Hello"?', 'options': ['Au revoir', 'Bonjour', 'Merci', 'Oui'], 'correctIndex': 1},
      {'question': 'What is the translation of "Thank you"?', 'options': ['Merci', 'S\'il vous plaît', 'Non', 'Pardon'], 'correctIndex': 0},
      {'question': 'What is the translation of "Water"?', 'options': ['Feu', 'Terre', 'Eau', 'Air'], 'correctIndex': 2},
      {'question': 'What is the translation of "Night"?', 'options': ['Jour', 'Matin', 'Soir', 'Nuit'], 'correctIndex': 3},
      {'question': 'What is the translation of "Yes"?', 'options': ['Oui', 'Non', 'Peut-être', 'Jamais'], 'correctIndex': 0},
    ],
    'French to English': [
      {'question': 'What is the translation of "Bonjour"?', 'options': ['Goodbye', 'Hello', 'Thank you', 'Yes'], 'correctIndex': 1},
      {'question': 'What is the translation of "Merci"?', 'options': ['Thank you', 'Please', 'No', 'Sorry'], 'correctIndex': 0},
      {'question': 'What is the translation of "Eau"?', 'options': ['Fire', 'Earth', 'Water', 'Air'], 'correctIndex': 2},
      {'question': 'What is the translation of "Nuit"?', 'options': ['Day', 'Morning', 'Evening', 'Night'], 'correctIndex': 3},
      {'question': 'What is the translation of "Oui"?', 'options': ['Yes', 'No', 'Maybe', 'Never'], 'correctIndex': 0},
    ],
    'English to Chinese': [
      {'question': 'What is the translation of "One"?', 'options': ['Er', 'Yi', 'San', 'Si'], 'correctIndex': 1},
      {'question': 'What is the translation of "Good"?', 'options': ['Hao', 'Huai', 'Da', 'Xiao'], 'correctIndex': 0},
      {'question': 'What is the translation of "Water"?', 'options': ['Huo', 'Tu', 'Shui', 'Feng'], 'correctIndex': 2},
      {'question': 'What is the translation of "Person"?', 'options': ['Gou', 'Mao', 'Niao', 'Ren'], 'correctIndex': 3},
      {'question': 'What is the translation of "Hello"?', 'options': ['Ni hao', 'Zai jian', 'Xie xie', 'Dui bu qi'], 'correctIndex': 0},
    ],
    'Chinese to English': [
      {'question': 'What is the translation of "Yi"?', 'options': ['Two', 'One', 'Three', 'Four'], 'correctIndex': 1},
      {'question': 'What is the translation of "Hao"?', 'options': ['Good', 'Bad', 'Big', 'Small'], 'correctIndex': 0},
      {'question': 'What is the translation of "Shui"?', 'options': ['Fire', 'Earth', 'Water', 'Wind'], 'correctIndex': 2},
      {'question': 'What is the translation of "Ren"?', 'options': ['Dog', 'Cat', 'Bird', 'Person'], 'correctIndex': 3},
      {'question': 'What is the translation of "Ni hao"?', 'options': ['Hello', 'Goodbye', 'Thank you', 'Sorry'], 'correctIndex': 0},
    ],
    'English to Italian': [
      {'question': 'What is the translation of "Thank you"?', 'options': ['Prego', 'Grazie', 'Ciao', 'Scusa'], 'correctIndex': 1},
      {'question': 'What is the translation of "Food"?', 'options': ['Cibo', 'Acqua', 'Vino', 'Pane'], 'correctIndex': 0},
      {'question': 'What is the translation of "Friend"?', 'options': ['Nemico', 'Fratello', 'Amico', 'Padre'], 'correctIndex': 2},
      {'question': 'What is the translation of "Good morning"?', 'options': ['Buonasera', 'Buonanotte', 'Arrivederci', 'Buongiorno'], 'correctIndex': 3},
      {'question': 'What is the translation of "Yes"?', 'options': ['Sì', 'No', 'Forse', 'Mai'], 'correctIndex': 0},
    ],
    'Italian to English': [
      {'question': 'What is the translation of "Grazie"?', 'options': ['You\'re welcome', 'Thank you', 'Hello', 'Sorry'], 'correctIndex': 1},
      {'question': 'What is the translation of "Cibo"?', 'options': ['Food', 'Water', 'Wine', 'Bread'], 'correctIndex': 0},
      {'question': 'What is the translation of "Amico"?', 'options': ['Enemy', 'Brother', 'Friend', 'Father'], 'correctIndex': 2},
      {'question': 'What is the translation of "Buongiorno"?', 'options': ['Good evening', 'Good night', 'Goodbye', 'Good morning'], 'correctIndex': 3},
      {'question': 'What is the translation of "Sì"?', 'options': ['Yes', 'No', 'Maybe', 'Never'], 'correctIndex': 0},
    ],
  };

  void _startQuiz(String difficulty, int totalQs) {
    setState(() {
      _selectedDifficulty = difficulty;
      _totalQuestions = totalQs;
      _currentStep = 2;
      _currentQuestionIndex = 0;
      _score = 0;
      _isAnswered = false;
      _selectedOption = -1;

      List<Map<String, dynamic>> availableQuestions = _questionBank[_selectedLanguage] ?? [];

      if (availableQuestions.isEmpty) {
        availableQuestions = [
          {'question': 'Default Question (No data found)', 'options': ['A', 'B', 'C', 'D'], 'correctIndex': 0}
        ];
      }

      _quizData = [];
      Random random = Random();

      for (int i = 0; i < totalQs; i++) {
        var randomQ = availableQuestions[random.nextInt(availableQuestions.length)];
        _quizData.add(randomQ);
      }
    });
  }

  void _checkAnswer(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedOption = index;
      _isAnswered = true;
      if (index == _quizData[_currentQuestionIndex]['correctIndex']) {
        _score++;
      }
    });
  }

  Future<void> _saveScoreToFirebase() async {
    if (_score > 0) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'score': FieldValue.increment(_score),
          });
        } catch (e) {
          debugPrint("Error saving score: $e");
        }
      }
    }
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _totalQuestions - 1) {
        _currentQuestionIndex++;
        _isAnswered = false;
        _selectedOption = -1;
      } else {
        _currentStep = 3;
        _saveScoreToFirebase();
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentStep = 0;
      _selectedLanguage = '';
      _selectedDifficulty = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Language Quiz', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildCurrentView(),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentStep) {
      case 0: return _buildLanguageSelection();
      case 1: return _buildDifficultySelection();
      case 2: return _buildQuizView();
      case 3: return _buildResultView();
      default: return _buildLanguageSelection();
    }
  }

  Widget _buildLanguageSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Select Language Pair', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        const Text('Choose the language you want to practice today.', style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text(_languages[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.accentPrimary, size: 20),
                  onTap: () {
                    setState(() {
                      _selectedLanguage = _languages[index];
                      _currentStep = 1;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Selected: $_selectedLanguage', style: const TextStyle(fontSize: 18, color: AppColors.accentPrimary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 30),
        const Text('Choose Difficulty Level', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.center),
        const SizedBox(height: 40),
        ..._difficulties.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () => _startQuiz(entry.key, entry.value),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${entry.key} Mode  ', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  Text('(${entry.value} MCQs)', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => setState(() => _currentStep = 0),
          child: const Text('Back to Languages', style: TextStyle(color: Colors.grey, fontSize: 16)),
        )
      ],
    );
  }

  Widget _buildQuizView() {
    final questionData = _quizData[_currentQuestionIndex];
    final List<String> options = questionData['options'];
    final int correctIndex = questionData['correctIndex'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Question ${_currentQuestionIndex + 1} of $_totalQuestions', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.accentSecondary.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
              child: Text('Score: $_score', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.accentSecondary)),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]),
          child: Center(child: Text(questionData['question'], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.center)),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              Color buttonColor = Colors.white;
              Color textColor = AppColors.textPrimary;

              if (_isAnswered) {
                if (index == correctIndex) {
                  buttonColor = Colors.green;
                  textColor = Colors.white;
                } else if (index == _selectedOption) {
                  buttonColor = Colors.redAccent;
                  textColor = Colors.white;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: _isAnswered ? 0 : 2,
                  ),
                  child: Text(options[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),
        ),
        if (_isAnswered)
          ElevatedButton(
            onPressed: _nextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              _currentQuestionIndex == _totalQuestions - 1 ? 'Finish Quiz' : 'Next Question',
              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildResultView() {
    double percentage = (_score / _totalQuestions) * 100;
    String feedbackMessage = percentage >= 80 ? 'Excellent Work! 🎉' : (percentage >= 50 ? 'Good Effort! 👍' : 'Keep Practicing! 💪');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
        const SizedBox(height: 20),
        const Text('Quiz Completed!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Text(feedbackMessage, style: const TextStyle(fontSize: 20, color: Colors.grey), textAlign: TextAlign.center),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]),
          child: Column(
            children: [
              const Text('Your Score', style: TextStyle(fontSize: 20, color: Colors.grey)),
              const SizedBox(height: 10),
              Text('$_score / $_totalQuestions', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.accentPrimary)),
            ],
          ),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: _resetQuiz,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentPrimary, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          child: const Text('Play Again', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}