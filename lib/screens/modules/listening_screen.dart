import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  late stt.SpeechToText _speech;
  late FlutterTts _tts;

  bool _isListening = false;
  bool _isInitialized = false;
  bool _isLoading = false;
  bool _isRobotSpeaking = false;

  String _spoken = "";
  String _feedback = "";
  double _score = 0;

  // Real-time highlight variables
  int _currentWordStart = 0;
  int _currentWordEnd = 0;

  String _selectedLanguage = "English";
  late String _targetSentence;

  // Aapki DOC file wale tamam sentences yahan hain
  final Map<String, Map<String, dynamic>> _languageConfig = {
    "English": {
      "sttLocale": "en_US",
      "ltCode": "en-US",
      "ttsLocale": "en-US",
      "sentences": [
        "Learning a new language opens a new dimension of the world.",
        "Technology is evolving faster than we could ever imagine in this era.",
        "I would like to order a cup of coffee and a grilled sandwich, please.",
        "Can you tell me how to get to the nearest train station from here?",
        "Reading books daily improves your vocabulary, focus, and overall mental health.",
        "Success is not final, failure is not fatal, it is the courage to continue that counts.",
        "My favorite season is autumn because the weather is perfectly cool and breezy.",
        "We are planning to travel to the mountains this weekend with our friends.",
        "Artificial intelligence is transforming the way we work, live, and communicate.",
        "Please remember to turn off the lights and lock the door before you leave.",
        "A journey of a thousand miles always begins with a single, determined step.",
        "Health is wealth, so we must exercise and eat properly every single day.",
        "The museum holds ancient artifacts that are over five thousand years old.",
        "Music has the incredible power to heal the soul and calm a stressed mind.",
        "It is never too late to learn a new skill and change your life entirely.",
        "The quick brown fox jumps over the lazy dog near the river bank.",
        "Environmental protection is the most important responsibility of our generation.",
        "Education is the most powerful weapon which you can use to change the world.",
        "Time management is the key to achieving your long-term goals effectively.",
        "Happiness is not something ready made, it comes from your own actions."
      ]
    },
    "Urdu": {
      "sttLocale": "ur_PK",
      "ltCode": "auto",
      "ttsLocale": "ur-PK",
      "sentences": [
        "ایک نئی زبان سیکھنا دنیا کا ایک نیا رخ کھولتا ہے۔",
        "ٹیکنالوجی اس دور میں ہماری سوچ سے بھی زیادہ تیزی سے ترقی کر رہی ہے۔",
        "میں ایک کپ کافی اور ایک سینڈوچ کا آرڈر دینا چاہوں گا۔",
        "کیا آپ مجھے بتا سکتے ہیں کہ یہاں سے قریب ترین ٹرین اسٹیشن کا راستہ کیا ہے؟",
        "روزانہ کتابیں پڑھنے سے آپ کے ذخیرہ الفاظ اور ذہنی صحت میں بہتری آتی ہے۔",
        "کامیابی حتمی نہیں، ناکامی جان لیوا نہیں، بلکہ آگے بڑھنے کا حوصلہ اہمیت رکھتا ہے۔",
        "میرا پسندیدہ موسم خزاں ہے کیونکہ اس میں موسم بہت خوشگوار ہوتا ہے۔",
        "ہم اس اختتام ہفتہ اپنے دوستوں کے ساتھ پہاڑوں کا سفر کرنے کا ارادہ کر رہے ہیں۔",
        "مصنوعی ذہانت ہمارے کام کرنے اور جینے کے انداز کو مکمل طور پر بدل رہی ہے۔",
        "براہ کرم کمرے سے باہر نکلنے سے پہلے بتیاں بجھانا اور دروازہ لاک کرنا یاد رکھیں۔",
        "ہزار میل کا طویل سفر ہمیشہ ایک چھوٹے اور پہلے قدم سے شروع ہوتا ہے۔",
        "تندرستی ہزار نعمت ہے اس لیے ہمیں روزانہ ورزش اور صحت بخش غذا کھانی چاہیے۔",
        "عجائب گھر میں ایسے قدیم آثار موجود ہیں جو پانچ ہزار سال سے بھی زیادہ پرانے ہیں۔",
        "موسیقی میں روح کو سکون دینے اور ذہنی تناؤ کو کم کرنے کی حیرت انگیز طاقت ہے۔",
        "کوئی نیا ہنر سیکھنے اور اپنی زندگی کو بدلنے میں کبھی دیر نہیں ہوتی۔",
        "ماحولیاتی تحفظ ہماری موجودہ نسل کی سب سے اہم اور بڑی ذمہ داری ہے۔",
        "تعلیم وہ سب سے طاقتور ہتھیار ہے جسے استعمال کرکے آپ دنیا بدل سکتے ہیں۔",
        "وقت کی پابندی اور تنظیم آپ کے طویل مدتی اہداف حاصل کرنے کی کنجی ہے۔",
        "خوشی کوئی بنی بنائی چیز نہیں ہے، بلکہ یہ آپ کے اپنے اعمال سے پیدا ہوتی ہے۔",
        "محنت اور لگن سے انسان دنیا کا مشکل ترین کام بھی آسانی سے سرانجام دے سکتا ہے۔"
      ]
    },
    "Spanish": {
      "sttLocale": "es_ES",
      "ltCode": "es",
      "ttsLocale": "es-ES",
      "sentences": [
        "Aprender un nuevo idioma abre una nueva dimensión del mundo.",
        "La tecnología está evolucionando más rápido de lo que imaginamos.",
        "Me gustaría pedir una taza de café y un sándwich, por favor.",
        "¿Puedes decirme cómo llegar a la estación de tren más cercana?",
        "Leer libros a diario mejora tu vocabulario y salud mental.",
        "El éxito no es definitivo, el fracaso no es fatal.",
        "La salud es riqueza, así que debemos hacer ejercicio.",
        "La música tiene el increíble poder de sanar el alma.",
        "La educación es el arma más poderosa para cambiar el mundo.",
        "La felicidad no es algo hecho, proviene de tus propias acciones."
      ]
    },
    "French": {
      "sttLocale": "fr_FR",
      "ltCode": "fr",
      "ttsLocale": "fr-FR",
      "sentences": [
        "Apprendre une nouvelle langue ouvre une nouvelle dimension.",
        "La technologie évolue plus vite que nous ne pourrions l'imaginer.",
        "Je voudrais commander une tasse de café, s'il vous plaît.",
        "Le succès n'est pas final, l'échec n'est pas fatal.",
        "La santé est la richesse, nous devons faire de l'exercice.",
        "La musique a le pouvoir incroyable de guérir l'âme.",
        "L'éducation est l'arme la plus puissante au monde.",
        "Le bonheur n'est pas quelque chose de tout fait.",
        "Un voyage de mille kilomètres commence par un seul pas.",
        "Avec un travail acharné, on peut tout accomplir."
      ]
    },
    "Italian": {
      "sttLocale": "it_IT",
      "ltCode": "it",
      "ttsLocale": "it-IT",
      "sentences": [
        "Imparare una nuova lingua apre una nuova dimensione.",
        "La tecnologia si sta evolvendo più velocemente possibile.",
        "Vorrei ordinare una tazza di caffè, per favore.",
        "Il successo non è definitivo, il fallimento non è fatale.",
        "La salute è ricchezza, dobbiamo fare esercizio ogni giorno.",
        "La musica ha l'incredibile potere di guarire l'anima.",
        "L'istruzione è l'arma più potente per cambiare il mondo.",
        "La felicità non è qualcosa di pronto, deriva dalle tue azioni.",
        "Un viaggio di mille miglia inizia con un solo passo.",
        "Con il duro lavoro si può ottenere qualsiasi cosa."
      ]
    },
    "Chinese": {
      "sttLocale": "zh_CN",
      "ltCode": "zh",
      "ttsLocale": "zh-CN",
      "sentences": [
        "学习一门新语言能打开世界的新维度。",
        "在这个时代，技术的发展速度超乎我们的想象。",
        "请给我来一杯咖啡和一个三明治。",
        "你能告诉我从这里到最近的火车站怎么走吗？",
        "每天读书能提高你的词汇量和心理健康。",
        "成功不是终点，失败也并非致命。",
        "健康就是财富，所以我们必须每天锻炼。",
        "音乐拥有一种不可思议的力量，能治愈灵魂。",
        "教育是你可以用来改变世界的最强大的武器。",
        "幸福来自你自己的行动。"
      ]
    }
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initTts();
    _loadRandomSentence();
    _initSpeech();
  }

  void _initTts() {
    _tts = FlutterTts();
    _tts.setProgressHandler((String text, int start, int end, String word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });
    _tts.setCompletionHandler(() {
      setState(() {
        _isRobotSpeaking = false;
        _currentWordStart = 0;
        _currentWordEnd = 0;
      });
    });
  }

  Future<void> _robotSpeak() async {
    String locale = _languageConfig[_selectedLanguage]!["ttsLocale"];
    await _tts.setLanguage(locale);
    await _tts.setSpeechRate(0.4);
    setState(() => _isRobotSpeaking = true);
    await _tts.speak(_targetSentence);
  }

  void _loadRandomSentence() {
    final sentences = _languageConfig[_selectedLanguage]!["sentences"] as List<String>;
    final random = Random();
    if (mounted) {
      setState(() {
        _targetSentence = sentences[random.nextInt(sentences.length)];
        _spoken = "";
        _feedback = "";
        _score = 0;
        _currentWordStart = 0;
        _currentWordEnd = 0;
      });
      Future.delayed(const Duration(milliseconds: 600), () => _robotSpeak());
    }
  }

  void _initSpeech() async {
    await Permission.microphone.request();
    _isInitialized = await _speech.initialize();
    if (mounted) setState(() {});
  }

  void _startListening() async {
    if (!_isInitialized) return;
    setState(() {
      _isListening = true;
      _spoken = "";
      _feedback = "";
    });
    String localeId = _languageConfig[_selectedLanguage]!["sttLocale"];
    await _speech.listen(
      onResult: (val) {
        if (mounted) setState(() => _spoken = val.recognizedWords);
      },
      localeId: localeId,
    );
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
    if (_spoken.isNotEmpty) _analyze();
  }

  Future<void> _analyze() async {
    setState(() => _isLoading = true);
    String cleanTarget = _targetSentence.toLowerCase().replaceAll(RegExp(r'[.,!?¿¡،۔]+'), '');
    String cleanSpoken = _spoken.toLowerCase().replaceAll(RegExp(r'[.,!?¿¡،۔]+'), '');

    List<String> targetWords = _selectedLanguage == "Chinese" ? cleanTarget.split('') : cleanTarget.split(' ');
    List<String> spokenWords = _selectedLanguage == "Chinese" ? cleanSpoken.split('') : cleanSpoken.split(' ');

    int correct = 0;
    for (var word in spokenWords) {
      if (targetWords.contains(word)) {
        correct++;
        targetWords.remove(word);
      }
    }

    double score = (correct / (_selectedLanguage == "Chinese" ? (correct + targetWords.length) : cleanTarget.split(' ').length)) * 100;

    setState(() {
      _score = score.clamp(0, 100);
      _feedback = _score >= 90 ? "Excellent! 🎉" : "Keep practicing! 💪";
      _isLoading = false;
    });
    if (_score >= 99) Future.delayed(const Duration(seconds: 2), () => _loadRandomSentence());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        title: const Text("Listening Practice", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            items: _languageConfig.keys.map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
            onChanged: (val) {
              if (val != null) setState(() { _selectedLanguage = val; _loadRandomSentence(); });
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_isRobotSpeaking ? "Robot Speaking..." : "Listen carefully", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.volume_up, color: Colors.teal), onPressed: _robotSpeak)
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(text: _targetSentence.substring(0, _currentWordStart), style: TextStyle(fontSize: _selectedLanguage == "Urdu" ? 26 : 22, color: Colors.black)),
                        TextSpan(
                          text: _targetSentence.substring(_currentWordStart, _currentWordEnd),
                          style: TextStyle(fontSize: _selectedLanguage == "Urdu" ? 28 : 24, fontWeight: FontWeight.bold, color: Colors.white, backgroundColor: Colors.teal),
                        ),
                        TextSpan(text: _targetSentence.substring(_currentWordEnd), style: TextStyle(fontSize: _selectedLanguage == "Urdu" ? 26 : 22, color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            GestureDetector(
              onLongPress: _startListening,
              onLongPressUp: _stopListening,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: _isListening ? Colors.red : Colors.teal,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white, size: 40),
              ),
            ),
            const SizedBox(height: 15),
            Text(_isListening ? "Listening..." : "Hold Mic to Repeat", style: const TextStyle(fontWeight: FontWeight.bold)),

            if (_feedback.isNotEmpty) ...[
              const SizedBox(height: 30),
              Text("Score: ${_score.toInt()}%", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(_feedback, style: const TextStyle(color: Colors.teal, fontSize: 18)),
              const SizedBox(height: 10),
              Text("You said: \"$_spoken\"", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
            ],

            const SizedBox(height: 50),
            ElevatedButton.icon(onPressed: _loadRandomSentence, icon: const Icon(Icons.skip_next), label: const Text("Next Sentence")),
          ],
        ),
      ),
    );
  }
}