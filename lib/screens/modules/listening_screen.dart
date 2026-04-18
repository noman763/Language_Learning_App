import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/app_colors.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String _selectedLanguage = 'English';
  bool _isPlaying = false;

  final List<String> _languages = ['English', 'Urdu', 'Spanish', 'French', 'Chinese', 'Italian'];

  // Language Codes for TTS
  final Map<String, String> _langCodes = {
    'English': 'en-US',
    'Urdu': 'ur-PK',
    'Spanish': 'es-ES',
    'French': 'fr-FR',
    'Chinese': 'zh-CN',
    'Italian': 'it-IT',
  };

  // 20 Sentences for each language
  final Map<String, String> _audioText = {
    'English': '''1. Hello, welcome to your daily listening practice.
2. Learning a new language opens a new dimension of the world.
3. Consistency is the key to mastering any skill.
4. Do not be afraid of making mistakes.
5. Mistakes are proof that you are trying.
6. Listening to native speakers helps improve your pronunciation.
7. Try to practice speaking for at least ten minutes every day.
8. Reading books and articles expands your vocabulary.
9. Writing down new words helps you remember them better.
10. Language is the road map of a culture.
11. It tells you where its people come from and where they are going.
12. The more you listen, the more you understand.
13. Always stay curious and keep asking questions.
14. Traveling becomes much more fun when you know the local language.
15. You can make new friends from different parts of the world.
16. Watching movies with subtitles is a great way to learn.
17. Be patient with yourself during this journey.
18. Every expert was once a beginner.
19. Celebrate your small victories along the way.
20. Keep up the great work and never give up!''',

    'Urdu': '''1. ہیلو، آپ کی روزانہ کی سننے کی مشق میں خوش آمدید۔
2. نئی زبان سیکھنا دنیا کا ایک نیا رخ کھولتا ہے۔
3. مستقل مزاجی کسی بھی مہارت میں مہارت حاصل کرنے کی کلید ہے۔
4. غلطیاں کرنے سے نہ گھبرائیں۔
5. غلطیاں اس بات کا ثبوت ہیں کہ آپ کوشش کر رہے ہیں۔
6. مقامی لوگوں کو سننے سے آپ کا تلفظ بہتر ہوتا ہے۔
7. روزانہ کم از کم دس منٹ بولنے کی مشق کرنے کی کوشش کریں۔
8. کتابیں اور مضامین پڑھنے سے آپ کے ذخیرہ الفاظ میں اضافہ ہوتا ہے۔
9. نئے الفاظ لکھنا انہیں بہتر طریقے سے یاد رکھنے میں مدد کرتا ہے۔
10. زبان کسی ثقافت کا نقشہ ہوتی ہے۔
11. یہ بتاتی ہے کہ اس کے لوگ کہاں سے آئے ہیں اور کہاں جا رہے ہیں۔
12. آپ جتنا زیادہ سنیں گے، اتنا ہی زیادہ سمجھیں گے۔
13. ہمیشہ متجسس رہیں اور سوالات پوچھتے رہیں۔
14. جب آپ مقامی زبان جانتے ہوں تو سفر کرنا زیادہ مزے دار ہو جاتا ہے۔
15. آپ دنیا کے مختلف حصوں سے نئے دوست بنا سکتے ہیں۔
16. سب ٹائٹلز کے ساتھ فلمیں دیکھنا سیکھنے کا ایک بہترین طریقہ ہے۔
17. اس سفر کے دوران اپنے ساتھ صابر رہیں۔
18. ہر ماہر کبھی شروعات کرنے والا تھا۔
19. راستے میں اپنی چھوٹی کامیابیوں کا جشن منائیں۔
20. اپنا بہترین کام جاری رکھیں اور کبھی ہمت نہ ہاریں!''',

    'Spanish': '''1. Hola, bienvenido a tu práctica diaria de escucha.
2. Aprender un nuevo idioma abre una nueva dimensión del mundo.
3. La constancia es la clave para dominar cualquier habilidad.
4. No tengas miedo de cometer errores.
5. Los errores son la prueba de que lo estás intentando.
6. Escuchar a hablantes nativos ayuda a mejorar tu pronunciación.
7. Intenta practicar la expresión oral durante al menos diez minutos cada día.
8. Leer libros y artículos amplía tu vocabulario.
9. Escribir las palabras nuevas te ayuda a recordarlas mejor.
10. El idioma es el mapa de ruta de una cultura.
11. Te dice de dónde viene su gente y hacia dónde va.
12. Cuanto más escuches, más entenderás.
13. Mantente siempre curioso y sigue haciendo preguntas.
14. Viajar se vuelve mucho más divertido cuando conoces el idioma local.
15. Puedes hacer nuevos amigos de diferentes partes del mundo.
16. Ver películas con subtítulos es una excelente manera de aprender.
17. Sé paciente contigo mismo durante este viaje.
18. Todo experto fue una vez principiante.
19. Celebra tus pequeñas victorias en el camino.
20. ¡Sigue con el gran trabajo y nunca te rindas!''',

    'French': '''1. Bonjour, bienvenue dans votre pratique d'écoute quotidienne.
2. Apprendre une nouvelle langue ouvre une nouvelle dimension du monde.
3. La constance est la clé pour maîtriser n'importe quelle compétence.
4. N'ayez pas peur de faire des erreurs.
5. Les erreurs sont la preuve que vous essayez.
6. Écouter des locuteurs natifs aide à améliorer votre prononciation.
7. Essayez de pratiquer l'expression orale pendant au moins dix minutes chaque jour.
8. Lire des livres et des articles élargit votre vocabulaire.
9. Écrire de nouveaux mots vous aide à mieux vous en souvenir.
10. La langue est la feuille de route d'une culture.
11. Elle vous dit d'où viennent ses habitants et où ils vont.
12. Plus vous écoutez, plus vous comprenez.
13. Restez toujours curieux et continuez à poser des questions.
14. Voyager devient beaucoup plus amusant lorsque vous connaissez la langue locale.
15. Vous pouvez vous faire de nouveaux amis de différentes parties du monde.
16. Regarder des films avec des sous-titres est un excellent moyen d'apprendre.
17. Soyez patient avec vous-même au cours de ce voyage.
18. Chaque expert a été un jour un débutant.
19. Célébrez vos petites victoires en cours de route.
20. Continuez votre excellent travail et n'abandonnez jamais !''',

    'Chinese': '''1. 你好，欢迎来到你的日常听力练习。
2. 学习一门新语言打开了世界的一个新维度。
3. 坚持是掌握任何技能的关键。
4. 不要害怕犯错。
5. 犯错证明你正在尝试。
6. 听母语人士讲话有助于改善你的发音。
7. 每天尝试练习口语至少十分钟。
8. 阅读书籍和文章可以扩大你的词汇量。
9. 写下新单词有助于你更好地记住它们。
10. 语言是文化的路线图。
11. 它告诉你它的人民来自哪里，将要去哪里。
12. 你听得越多，你理解得就越多。
13. 始终保持好奇心并不断提问。
14. 当你懂当地语言时，旅行会变得更加有趣。
15. 你可以结交来自世界各地的新朋友。
16. 看带字幕的电影是学习的好方法。
17. 在这段旅程中对自己要有耐心。
18. 每个专家都曾经是初学者。
19. 庆祝你沿途的小小胜利。
20. 继续努力，永远不要放弃！''',

    'Italian': '''1. Ciao, benvenuto alla tua pratica di ascolto quotidiana.
2. Imparare una nuova lingua apre una nuova dimensione del mondo.
3. La costanza è la chiave per padroneggiare qualsiasi abilità.
4. Non aver paura di fare errori.
5. Gli errori sono la prova che ci stai provando.
6. Ascoltare i madrelingua aiuta a migliorare la tua pronuncia.
7. Cerca di esercitarti a parlare per almeno dieci minuti ogni giorno.
8. Leggere libri e articoli espande il tuo vocabolario.
9. Scrivere nuove parole ti aiuta a ricordarle meglio.
10. La lingua è la mappa di una cultura.
11. Ti dice da dove viene la sua gente e dove sta andando.
12. Più ascolti, più capisci.
13. Rimani sempre curioso e continua a fare domande.
14. Viaggiare diventa molto più divertente quando conosci la lingua locale.
15. Puoi fare nuove amicizie da diverse parti del mondo.
16. Guardare film con i sottotitoli è un ottimo modo per imparare.
17. Sii paziente con te stesso durante questo viaggio.
18. Ogni esperto è stato un tempo un principiante.
19. Celebra le tue piccole vittorie lungo la strada.
20. Continua l'ottimo lavoro e non arrenderti mai!'''
  };

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    flutterTts.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  Future<void> _speak() async {
    String textToSpeak = _audioText[_selectedLanguage] ?? "Text not available.";
    String langCode = _langCodes[_selectedLanguage] ?? "en-US";

    await flutterTts.setLanguage(langCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4); // Speed thori slow ki hai taake samajh aaye

    setState(() => _isPlaying = true);
    await flutterTts.speak(textToSpeak);
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() => _isPlaying = false);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Listening Practice', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedLanguage,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              items: _languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedLanguage = val!;
                  _stop(); // Stop audio if language changes
                });
              },
            ),
            const SizedBox(height: 30),

            // Animated Visualizer Mock
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: _isPlaying ? AppColors.accentPrimary.withOpacity(0.2) : AppColors.accentPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(Icons.graphic_eq, size: _isPlaying ? 100 : 80, color: AppColors.accentPrimary),
              ),
            ),
            const SizedBox(height: 40),

            // Play/Stop Button
            FloatingActionButton.large(
              backgroundColor: AppColors.accentPrimary,
              onPressed: _isPlaying ? _stop : _speak,
              child: Icon(_isPlaying ? Icons.stop : Icons.play_arrow, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Transcript:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    _audioText[_selectedLanguage] ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      fontFamily: _selectedLanguage == 'Urdu' ? 'Jameel Noori Nastaleeq' : null, // Urdu ke liye font (agar add kiya hai toh)
                    ),
                    textAlign: _selectedLanguage == 'Urdu' ? TextAlign.right : TextAlign.left,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}