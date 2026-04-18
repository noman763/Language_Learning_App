import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class SpeakingScreen extends StatefulWidget {
  const SpeakingScreen({super.key});

  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> {
  late stt.SpeechToText _speech;

  bool _isListening = false;
  bool _isInitialized = false;
  bool _isLoading = false;

  String _spoken = "";
  String _feedback = "";
  double _score = 0;

  // Selected Language Setup
  String _selectedLanguage = "English";
  late String _targetSentence;

  // 6 Languages with ~300 Words each (20+ Sentences)
  final Map<String, Map<String, dynamic>> _languageConfig = {
    "English": {
      "sttLocale": "en_US",
      "ltCode": "en-US",
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
      "ltCode": "auto", // LanguageTool has limited Urdu, so we rely on Exact STT Match
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
      "sentences": [
        "Aprender un nuevo idioma abre una nueva dimensión del mundo.",
        "La tecnología está evolucionando más rápido de lo que imaginamos en esta era.",
        "Me gustaría pedir una taza de café y un sándwich, por favor.",
        "¿Puedes decirme cómo llegar a la estación de tren más cercana desde aquí?",
        "Leer libros a diario mejora tu vocabulario, concentración y salud mental.",
        "El éxito no es definitivo, el fracaso no es fatal, es el coraje lo que cuenta.",
        "Mi estación favorita es el otoño porque el clima es perfectamente fresco.",
        "Estamos planeando viajar a las montañas este fin de semana con amigos.",
        "La inteligencia artificial está transformando nuestra forma de trabajar y vivir.",
        "Por favor, recuerda apagar las luces y cerrar la puerta antes de salir.",
        "Un viaje de mil millas siempre comienza con un solo paso decidido.",
        "La salud es riqueza, así que debemos hacer ejercicio y comer bien cada día.",
        "El museo alberga artefactos antiguos que tienen más de cinco mil años.",
        "La música tiene el increíble poder de sanar el alma y calmar la mente.",
        "Nunca es demasiado tarde para aprender una nueva habilidad y cambiar tu vida.",
        "La protección del medio ambiente es la mayor responsabilidad de nuestra generación.",
        "La educación es el arma más poderosa que puedes usar para cambiar el mundo.",
        "La gestión del tiempo es la clave para alcanzar tus objetivos a largo plazo.",
        "La felicidad no es algo hecho, proviene de tus propias acciones y decisiones.",
        "Con trabajo duro y dedicación, una persona puede lograr cualquier cosa."
      ]
    },
    "French": {
      "sttLocale": "fr_FR",
      "ltCode": "fr",
      "sentences": [
        "Apprendre une nouvelle langue ouvre une nouvelle dimension du monde.",
        "La technologie évolue plus vite que nous ne pourrions l'imaginer à cette époque.",
        "Je voudrais commander une tasse de café et un sandwich, s'il vous plaît.",
        "Pouvez-vous me dire comment me rendre à la gare la plus proche d'ici?",
        "Lire des livres tous les jours améliore votre vocabulaire et votre santé mentale.",
        "Le succès n'est pas final, l'échec n'est pas fatal, c'est le courage qui compte.",
        "Ma saison préférée est l'automne car le temps est parfaitement frais.",
        "Nous prévoyons de voyager à la montagne ce week-end avec nos amis.",
        "L'intelligence artificielle transforme notre façon de travailler et de vivre.",
        "N'oubliez pas d'éteindre les lumières et de fermer la porte avant de partir.",
        "Un voyage de mille kilomètres commence toujours par un seul pas déterminé.",
        "La santé est la richesse, nous devons donc faire de l'exercice chaque jour.",
        "Le musée abrite des objets anciens qui ont plus de cinq mille ans.",
        "La musique a le pouvoir incroyable de guérir l'âme et d'apaiser l'esprit.",
        "Il n'est jamais trop tard pour apprendre une compétence et changer de vie.",
        "La protection de l'environnement est la plus grande responsabilité de notre temps.",
        "L'éducation est l'arme la plus puissante que vous puissiez utiliser.",
        "La gestion du temps est la clé pour atteindre vos objectifs à long terme.",
        "Le bonheur n'est pas quelque chose de tout fait, il vient de vos actions.",
        "Avec un travail acharné, une personne peut accomplir tout ce qu'elle veut."
      ]
    },
    "Italian": {
      "sttLocale": "it_IT",
      "ltCode": "it",
      "sentences": [
        "Imparare una nuova lingua apre una nuova dimensione del mondo.",
        "La tecnologia si sta evolvendo più velocemente di quanto potessimo immaginare.",
        "Vorrei ordinare una tazza di caffè e un panino, per favore.",
        "Puoi dirmi come arrivare alla stazione ferroviaria più vicina da qui?",
        "Leggere libri ogni giorno migliora il vocabolario, la concentrazione e la mente.",
        "Il successo non è definitivo, il fallimento non è fatale, conta il coraggio.",
        "La mia stagione preferita è l'autunno perché il clima è perfettamente fresco.",
        "Stiamo progettando di viaggiare in montagna questo fine settimana con gli amici.",
        "L'intelligenza artificiale sta trasformando il nostro modo di lavorare e vivere.",
        "Ricordati di spegnere le luci e chiudere la porta prima di uscire.",
        "Un viaggio di mille miglia inizia sempre con un solo passo determinato.",
        "La salute è ricchezza, quindi dobbiamo fare esercizio e mangiare bene.",
        "Il museo ospita antichi manufatti che hanno più di cinquemila anni.",
        "La musica ha l'incredibile potere di guarire l'anima e calmare la mente.",
        "Non è mai troppo tardi per imparare una nuova abilità e cambiare vita.",
        "La tutela dell'ambiente è la responsabilità più importante della nostra generazione.",
        "L'istruzione è l'arma più potente che puoi usare per cambiare il mondo.",
        "La gestione del tempo è la chiave per raggiungere i tuoi obiettivi a lungo termine.",
        "La felicità non è qualcosa di pronto, deriva dalle tue stesse azioni.",
        "Con il duro lavoro e la dedizione, una persona può ottenere qualsiasi cosa."
      ]
    },
    "Chinese": {
      "sttLocale": "zh_CN",
      "ltCode": "zh",
      "sentences": [
        "学习一门新语言能打开世界的新维度。",
        "在这个时代，技术的发展速度超乎我们的想象。",
        "请给我来一杯咖啡和一个三明治。",
        "你能告诉我从这里到最近的火车站怎么走吗？",
        "每天读书能提高你的词汇量、注意力和整体心理健康。",
        "成功不是终点，失败也并非致命，继续前进的勇气才最重要。",
        "我最喜欢的季节是秋天，因为天气非常凉爽宜人。",
        "我们计划这个周末和朋友们一起去山区旅行。",
        "人工智能正在改变我们的工作、生活和交流方式。",
        "离开房间前，请记得关灯并锁好门。",
        "千里之行，始于足下。",
        "健康就是财富，所以我们必须每天锻炼并保持良好饮食。",
        "这家博物馆收藏着有五千多年历史的古代文物。",
        "音乐拥有一种不可思议的力量，能治愈灵魂，平静心灵。",
        "学习一项新技能并彻底改变你的生活，永远都不晚。",
        "环境保护是我们这一代人最重要、最紧迫的责任。",
        "教育是你可以用来改变世界的最强大的武器。",
        "时间管理是有效实现长期目标的关键。",
        "幸福不是现成的东西，它来自你自己的行动。",
        "只要努力和专注，一个人可以成就任何事情。"
      ]
    }
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadRandomSentence();
    _initSpeech();
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
      });
    }
  }

  void _initSpeech() async {
    await Permission.microphone.request();
    _isInitialized = await _speech.initialize(
      onStatus: (status) {
        if (status == "done" || status == "notListening") {
          if (mounted && _isListening) {
            _stopListening();
          }
        }
      },
    );
    if (mounted) setState(() {});
  }

  void _startListening() async {
    if (!_isInitialized) return;

    setState(() {
      _isListening = true;
      _spoken = "";
      _feedback = "";
      _score = 0;
    });

    String localeId = _languageConfig[_selectedLanguage]!["sttLocale"];

    await _speech.listen(
      onResult: (val) {
        if (mounted) {
          setState(() {
            _spoken = val.recognizedWords;
          });
        }
      },
      localeId: localeId,
      pauseFor: const Duration(seconds: 4),
    );
  }

  void _stopListening() async {
    await _speech.stop();
    if (mounted) {
      setState(() => _isListening = false);
      if (_spoken.isNotEmpty) {
        _analyze();
      }
    }
  }

  Future<void> _analyze() async {
    setState(() => _isLoading = true);
    String ltCode = _languageConfig[_selectedLanguage]!["ltCode"];
    List matches = [];

    // =====================================
    // 1. STT SCORE CALCULATION (Accurate logic for all languages)
    // =====================================
    String cleanTarget = _targetSentence.toLowerCase().replaceAll(RegExp(r'[.,!?¿¡،۔]+'), '');
    String cleanSpoken = _spoken.toLowerCase().replaceAll(RegExp(r'[.,!?¿¡،۔]+'), '');

    List<String> targetWords;
    List<String> spokenWords;

    // Chinese needs character-by-character split, others need space split
    if (_selectedLanguage == "Chinese") {
      targetWords = cleanTarget.split('');
      spokenWords = cleanSpoken.split('');
    } else {
      targetWords = cleanTarget.split(' ');
      spokenWords = cleanSpoken.split(' ');
    }

    targetWords.removeWhere((w) => w.trim().isEmpty);
    spokenWords.removeWhere((w) => w.trim().isEmpty);

    int correctWords = 0;
    for (String word in spokenWords) {
      if (targetWords.contains(word)) {
        correctWords++;
        targetWords.remove(word); // Prevent double counting
      }
    }

    double score = (correctWords / (cleanTarget.isEmpty ? 1 : cleanTarget.split(RegExp(r'\s+')).length)) * 100;
    if (_selectedLanguage == "Chinese") {
      score = (correctWords / (targetWords.length + correctWords)) * 100;
    }
    score = score.clamp(0, 100);

    // =====================================
    // 2. LANGUAGE TOOL API (Grammar Check)
    // =====================================
    if (ltCode != "auto") {
      try {
        final response = await http.post(
          Uri.parse("https://api.languagetool.org/v2/check"),
          body: {"text": _spoken, "language": ltCode},
        );
        final data = jsonDecode(response.body);
        matches = data["matches"] ?? [];
      } catch (e) {
        // Ignore API error, rely on STT match
      }
    }

    // =====================================
    // 3. FEEDBACK & AUTO-NEXT LOGIC
    // =====================================
    String feedback;
    if (score < 40) {
      feedback = "Please try speaking a bit louder and clearer. 🎤";
    } else if (score >= 99) {
      score = 100; // Perfect exact match
      feedback = "Perfect! Moving to the next sentence... 🎉➡️";

      // AUTO-NEXT LOGIC (Change sentence after 2 seconds)
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _loadRandomSentence();
      });

    } else if (matches.isEmpty) {
      feedback = "Good pronunciation, but you missed some words. Keep trying! 👍";
    } else {
      feedback = "You made ${matches.length} grammar/word mistake(s). Keep practicing! 💪";
    }

    if (mounted) {
      setState(() {
        _score = score;
        _feedback = feedback;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        title: const Text("Speaking Practice", style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                icon: const Icon(Icons.language, color: Colors.teal),
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                items: _languageConfig.keys.map((String lang) {
                  return DropdownMenuItem<String>(
                    value: lang,
                    child: Text(lang),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                      _loadRandomSentence();
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 10))
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Read aloud", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                        InkWell(
                          onTap: _loadRandomSentence,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.teal.shade50, shape: BoxShape.circle),
                            child: const Icon(Icons.skip_next, color: Colors.teal, size: 20),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _targetSentence,
                      textAlign: TextAlign.center,
                      // Changed font for Urdu so it looks good if it's selected
                      style: TextStyle(
                          fontSize: _selectedLanguage == "Urdu" ? 26 : 22,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Colors.black87
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              Listener(
                onPointerDown: (_) => _startListening(),
                onPointerUp: (_) => _stopListening(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(_isListening ? 45 : 35),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isListening ? Colors.redAccent : Colors.teal).withValues(alpha: 0.4),
                        blurRadius: _isListening ? 30 : 15,
                        spreadRadius: 5,
                        offset: const Offset(0, 8),
                      )
                    ],
                    gradient: LinearGradient(
                      colors: _isListening
                          ? [Colors.redAccent, Colors.deepOrange]
                          : [Colors.teal, Colors.green],
                    ),
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 45),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                _isListening ? "Listening... Release when done" : "Hold to Speak",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _isListening ? Colors.redAccent : Colors.grey.shade600),
              ),

              const SizedBox(height: 30),

              if (_isLoading)
                const Column(
                  children: [
                    CircularProgressIndicator(color: Colors.teal),
                    SizedBox(height: 10),
                    Text("Analyzing pronunciation...", style: TextStyle(color: Colors.grey)),
                  ],
                ),

              if (!_isLoading && _feedback.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _score == 100 ? Colors.green : (_score > 60 ? Colors.orange.shade300 : Colors.red.shade300),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Score:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54)),
                          Text(
                            "${_score.toInt()}%",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: _score == 100 ? Colors.green : (_score > 60 ? Colors.orange : Colors.red),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      const Text("You said:", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 5),
                      Text(
                        '"${_spoken.isEmpty ? "..." : _spoken}"',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: _selectedLanguage == "Urdu" ? 20 : 16,
                            color: Colors.black87
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _score == 100 ? Colors.green.shade50 : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(_score == 100 ? Icons.check_circle : Icons.info, color: _score == 100 ? Colors.green : Colors.orange),
                            const SizedBox(width: 10),
                            Expanded(child: Text(_feedback, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500))),
                          ],
                        ),
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}