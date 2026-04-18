import 'dart:async';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../../core/app_colors.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';


class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final GoogleTranslator _translator = GoogleTranslator();
  final TextEditingController _inputController = TextEditingController();
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;

  Timer? _debounce;
  String _translatedText = "";
  bool _isTranslating = false;
  bool _isListening = false;

  String _sourceLanguage = "English";
  String _targetLanguage = "Urdu";

  final Map<String, Map<String, String>> _languages = {
    'English': {'trans': 'en', 'stt': 'en_US', 'tts': 'en-US'},
    'Urdu': {'trans': 'ur', 'stt': 'ur_PK', 'tts': 'ur-PK'},
    'Spanish': {'trans': 'es', 'stt': 'es_ES', 'tts': 'es-ES'},
    'French': {'trans': 'fr', 'stt': 'fr_FR', 'tts': 'fr-FR'},
    'Italian': {'trans': 'it', 'stt': 'it_IT', 'tts': 'it-IT'},
    'Chinese': {'trans': 'zh-cn', 'stt': 'zh_CN', 'tts': 'zh-CN'},
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _debounce?.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (text.trim().isEmpty) {
      setState(() {
        _translatedText = "";
        _isTranslating = false;
      });
      return;
    }

    setState(() => _isTranslating = true);

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performTranslation(text);
    });
  }

  Future<void> _performTranslation(String text) async {
    try {
      final translation = await _translator.translate(
        text,
        from: _languages[_sourceLanguage]!['trans']!,
        to: _languages[_targetLanguage]!['trans']!,
      );

      if (mounted) {
        setState(() {
          _translatedText = translation.text;
          _isTranslating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _translatedText = "Translation error. Please check internet.";
          _isTranslating = false;
        });
      }
    }
  }

  void _swapLanguages() {
    setState(() {
      String temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;

      String tempText = _inputController.text;
      _inputController.text = _translatedText;
      _translatedText = tempText;
    });

    if (_inputController.text.isNotEmpty) {
      _performTranslation(_inputController.text);
    }
  }

  void _listen() async {
    if (!_isListening) {
      var status = await Permission.microphone.request();
      if (status.isGranted) {
        bool available = await _speech.initialize();
        if (available) {
          setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) {
              setState(() {
                _inputController.text = val.recognizedWords;
                _onTextChanged(val.recognizedWords);
              });
            },
            localeId: _languages[_sourceLanguage]!['stt']!,
          );
        }
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _speak() async {
    if (_translatedText.isNotEmpty) {
      await _flutterTts.setLanguage(_languages[_targetLanguage]!['tts']!);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak(_translatedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Translate', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accentPrimary.withOpacity(0.2)),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLanguageDropdown(
                        selectedValue: _sourceLanguage,
                        onChanged: (val) {
                          setState(() => _sourceLanguage = val!);
                          _performTranslation(_inputController.text);
                        }
                    ),
                    const Divider(height: 30),
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        onChanged: _onTextChanged,
                        maxLines: null,
                        style: const TextStyle(fontSize: 24, color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: "Type or speak something...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _speak,
                  child: _buildCircularButton(Icons.volume_up, Colors.white, AppColors.accentPrimary),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: _swapLanguages,
                  child: _buildCircularButton(Icons.swap_vert, AppColors.accentPrimary, Colors.white),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: _listen,
                  child: _buildCircularButton(
                      _isListening ? Icons.mic_off : Icons.mic,
                      _isListening ? Colors.redAccent : Colors.white,
                      _isListening ? Colors.white : AppColors.accentPrimary
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.accentPrimary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accentPrimary.withOpacity(0.2)),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLanguageDropdown(
                        selectedValue: _targetLanguage,
                        onChanged: (val) {
                          setState(() => _targetLanguage = val!);
                          _performTranslation(_inputController.text);
                        }
                    ),
                    const Divider(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _isTranslating
                            ? const Center(child: CircularProgressIndicator(color: AppColors.accentPrimary))
                            : Text(
                            _translatedText.isEmpty ? "Translation will appear here" : _translatedText,
                            style: TextStyle(
                                fontSize: _targetLanguage == "Urdu" ? 28 : 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown({required String selectedValue, required ValueChanged<String?> onChanged}) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedValue,
        isDense: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 16),
        items: _languages.keys.map((String lang) {
          return DropdownMenuItem<String>(
            value: lang,
            child: Text(lang),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, Color bgColor, Color iconColor) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)]
        ),
        child: Icon(icon, color: iconColor, size: 28)
    );
  }
}