import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/app_colors.dart';

class WritingEvaluationScreen extends StatefulWidget {
  const WritingEvaluationScreen({super.key});

  @override
  State<WritingEvaluationScreen> createState() => _WritingEvaluationScreenState();
}

class _WritingEvaluationScreenState extends State<WritingEvaluationScreen> {
  final TextEditingController _textController = TextEditingController();

  String _selectedLanguage = 'English';
  bool _isLoading = false;
  bool _hasEvaluated = false;
  int _score = 100;

  List<Map<String, String>> _issues = [];

  final List<String> _languages = [
    'English', 'Urdu', 'Spanish', 'French', 'Chinese', 'Italian'
  ];

  // LanguageTool ke liye Language Codes
  final Map<String, String> _languageCodes = {
    'English': 'en-US',
    'Urdu': 'auto',
    'Spanish': 'es',
    'French': 'fr',
    'Chinese': 'zh-CN',
    'Italian': 'it'
  };

  // Asal LanguageTool API Call
  Future<void> evaluateText() async {
    String text = _textController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something first!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _hasEvaluated = false;
      _issues.clear();
      _score = 100;
    });

    try {
      String langCode = _languageCodes[_selectedLanguage] ?? 'en-US';

      // API par data bhejna (POST Request)
      var response = await http.post(
        Uri.parse('https://api.languagetool.org/v2/check'),
        body: {
          'text': text,
          'language': langCode,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List matches = data['matches'] ?? [];

        List<Map<String, String>> foundIssues = [];

        // API ki response se errors aur suggestions nikalna
        for (var match in matches) {
          String suggestion = '';
          if (match['replacements'] != null && match['replacements'].isNotEmpty) {
            // Pehli suggestion nikal rahe hain
            suggestion = match['replacements'][0]['value'];
          }

          foundIssues.add({
            'type': (match['rule']['issueType'] ?? 'Grammar').toString().toUpperCase(),
            'error': match['message'] ?? 'Unknown error found.',
            'suggestion': suggestion.isNotEmpty ? suggestion : 'No automatic suggestion available.',
          });
        }

        setState(() {
          _issues = foundIssues;
          // Har ghalti par 5 marks katen ge (0 se neechay nahi jayega)
          _score = (100 - (foundIssues.length * 5)).clamp(0, 100);
          _isLoading = false;
          _hasEvaluated = true;
        });

      } else {
        _showError('Server Error: ${response.statusCode}. Please try again.');
      }
    } catch (e) {
      _showError('Network Error: Please check your internet connection.');
    }
  }

  void _showError(String message) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Writing Evaluation', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
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
              const Text('Select Target Language:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    isExpanded: true,
                    icon: const Icon(Icons.language, color: AppColors.accentPrimary),
                    items: _languages.map((String lang) {
                      return DropdownMenuItem<String>(
                        value: lang,
                        child: Text(lang, style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                        _hasEvaluated = false;
                      });
                    },
                  ),
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
                    hintText: "Type something in $_selectedLanguage...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.accentPrimary))
                  : ElevatedButton(
                onPressed: evaluateText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                ),
                child: const Text('Analyze Text', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 30),

              if (_hasEvaluated) _buildResultsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    bool isPerfect = _issues.isEmpty;

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
              Text('$_score/100', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: isPerfect ? Colors.green : Colors.orange[800])),
            ],
          ),
        ),

        const SizedBox(height: 20),

        if (!isPerfect) ...[
          const Text('Suggestions & Corrections:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ..._issues.map((issue) {
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
                      Text(issue['type']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Mistake: ${issue['error']}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                  const SizedBox(height: 5),
                  Text('Suggestion: ${issue['suggestion']}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15)),
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