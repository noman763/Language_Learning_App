import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => ReadingScreenState();
}

class ReadingScreenState extends State<ReadingScreen> {
  String selectedLanguage = 'English';
  final int currentPassageIndex = 0;

  final List<String> languages = [
    'English', 'Urdu', 'Spanish', 'French', 'Chinese', 'Italian'
  ];

  // 500+ Words Advanced Article Data for Each Language
  final Map<String, List<Map<String, String>>> readingMaterials = {
    'English': [
      {
        'text': '''Language is the invisible thread that connects humanity across vast continents, oceans, and centuries of history. It is far more than a mere system of words, grammatical rules, and syntax; it is the very essence of human expression, culture, and identity. When we embark on the journey of learning a new language, we are not just acquiring a new skill to add to our resumes; we are unlocking a new dimension of the world and ourselves. The process of language learning requires patience, dedication, and a willingness to make mistakes, but the rewards it offers are truly immeasurable and life-changing.

From a cognitive perspective, the benefits of bilingualism or multilingualism are profound and well-documented by scientific research. Learning a new language is like a rigorous workout for the brain. It strengthens neural pathways, improves memory retention, and enhances critical thinking and problem-solving abilities. Studies have consistently shown that people who speak more than one language tend to have better focus, are more adept at multitasking, and can switch between tasks with greater ease. 

Furthermore, engaging with a foreign language can build a cognitive reserve that helps protect the brain against age-related decline, delaying the onset of conditions such as dementia and Alzheimer's disease. The mental agility gained from navigating different linguistic structures is a lifelong asset. Beyond the intellectual advantages, mastering a new language offers unparalleled opportunities for cultural immersion and deep human connection. Language and culture are inextricably linked; you cannot truly understand one without the other. 

When you learn to speak to someone in their native tongue, you are not just translating words; you are translating concepts, humor, traditions, and worldviews. Nelson Mandela famously said, "If you talk to a man in a language he understands, that goes to his head. If you talk to him in his language, that goes to his heart." This profound statement encapsulates the emotional and empathetic power of language. It breaks down barriers of prejudice and xenophobia, fostering global citizenship and mutual respect.

In today's highly globalized economy, the practical benefits of language proficiency cannot be overstated. Multinational companies and international organizations constantly seek individuals who can navigate cross-cultural communications seamlessly. Being bilingual can open doors to exciting career opportunities, international travel, and collaborations that would otherwise remain inaccessible. 

Ultimately, learning a language is a journey of personal growth and self-discovery. It forces us to step outside our comfort zones, challenges our preconceived notions, and broadens our worldview. It teaches us humility and empathy by allowing us to see the world through the eyes of another culture. Let us celebrate the diversity of human speech and commit to the beautiful, endless journey of language learning.''',
        'translation': 'Language connects humanity and is the essence of culture and identity. Learning a new language boosts brain power, improves memory, and delays aging of the brain. It opens doors to new cultures, better jobs, and personal growth.'
      }
    ],
    'Urdu': [
      {
        'text': '''زبان وہ غیر مرئی دھاگہ ہے جو انسانیت کو وسیع بر اعظموں، سمندروں اور صدیوں کی تاریخ کے پار جوڑتا ہے۔ یہ محض الفاظ، گرامر کے اصولوں اور نحو کے نظام سے کہیں زیادہ ہے؛ یہ انسانی اظہار، ثقافت اور شناخت کا اصل جوہر ہے۔ جب ہم کوئی نئی زبان سیکھنے کے سفر کا آغاز کرتے ہیں، تو ہم صرف اپنے ریزیومے میں شامل کرنے کے لیے کوئی نیا ہنر حاصل نہیں کر رہے ہوتے؛ ہم دنیا اور اپنی ذات کی ایک نئی جہت کو کھول رہے ہوتے ہیں۔ زبان سیکھنے کے عمل میں صبر، لگن اور غلطیاں کرنے کی آمادگی درکار ہوتی ہے، لیکن اس سے ملنے والے انعامات واقعی بے حساب اور زندگی بدل دینے والے ہوتے ہیں۔

علمی نقطہ نظر سے دو یا دو سے زیادہ زبانیں بولنے کے فوائد بہت گہرے ہیں اور سائنسی تحقیق سے بھی ثابت ہیں۔ نئی زبان سیکھنا دماغ کے لیے ایک سخت ورزش کی طرح ہے۔ یہ اعصابی راستوں کو مضبوط کرتا ہے، یادداشت کو بہتر بناتا ہے اور تنقیدی سوچ اور مسائل حل کرنے کی صلاحیتوں کو بڑھاتا ہے۔ مطالعات سے مسلسل ظاہر ہوا ہے کہ جو لوگ ایک سے زیادہ زبانیں بولتے ہیں وہ بہتر توجہ مرکوز کر سکتے ہیں، ملٹی ٹاسکنگ میں زیادہ ماہر ہوتے ہیں اور مختلف کاموں کے درمیان آسانی سے سوئچ کر سکتے ہیں۔

مزید برآں، غیر ملکی زبان کے ساتھ مشغول ہونا ایک علمی ذخیرہ بنا سکتا ہے جو دماغ کو عمر سے متعلق زوال سے بچانے میں مدد کرتا ہے، جیسے ڈیمنشیا اور الزائمر جیسی بیماریوں کے آغاز کو موخر کرتا ہے۔ مختلف لسانی ڈھانچوں کو سمجھنے سے حاصل ہونے والی ذہنی چستی زندگی بھر کا اثاثہ ہے۔ فکری فوائد سے ہٹ کر، نئی زبان پر عبور حاصل کرنا ثقافتی غرق اور گہرے انسانی رابطے کے بے مثال مواقع فراہم کرتا ہے۔ زبان اور ثقافت کا آپس میں گہرا تعلق ہے؛ آپ ایک کے بغیر دوسرے کو حقیقی معنوں میں نہیں سمجھ سکتے۔

جب آپ کسی سے ان کی مادری زبان میں بات کرنا سیکھتے ہیں، تو آپ صرف الفاظ کا ترجمہ نہیں کر رہے ہوتے؛ آپ تصورات، مزاح، روایات اور دنیا کے نظریات کا ترجمہ کر رہے ہوتے ہیں۔ نیلسن منڈیلا نے مشہور طور پر کہا تھا، "اگر آپ کسی آدمی سے ایسی زبان میں بات کرتے ہیں جسے وہ سمجھتا ہے، تو وہ اس کے دماغ تک جاتی ہے۔ اگر آپ اس سے اس کی اپنی زبان میں بات کرتے ہیں، تو وہ اس کے دل تک جاتی ہے۔" یہ گہرا بیان زبان کی جذباتی اور ہمدردانہ طاقت کو سمیٹتا ہے۔

آج کی انتہائی عالمگیر معیشت میں زبان کی مہارت کے عملی فوائد کو نظر انداز نہیں کیا جا سکتا۔ ملٹی نیشنل کمپنیاں اور بین الاقوامی تنظیمیں مسلسل ایسے افراد کی تلاش میں رہتی ہیں جو ثقافتی رابطوں کو آسانی سے نیویگیٹ کر سکیں۔ دو لسانی ہونا کیریئر کے دلچسپ مواقع، بین الاقوامی سفر اور باہمی تعاون کے دروازے کھول سکتا ہے۔ بالآخر، زبان سیکھنا ذاتی ترقی اور خود کی دریافت کا سفر ہے۔ یہ ہمیں اپنے کمفرٹ زون سے باہر نکلنے پر مجبور کرتا ہے اور ہمارے عالمی نظریہ کو وسیع کرتا ہے۔''',
        'translation': 'زبان انسانیت کو جوڑتی ہے اور ثقافت کا نچوڑ ہے۔ نئی زبان سیکھنے سے دماغ تیز ہوتا ہے، یادداشت بہتر ہوتی ہے اور بڑھاپے کی بیماریاں دور رہتی ہیں۔ یہ نئی ثقافتوں، بہتر ملازمتوں اور ذاتی ترقی کے دروازے کھولتی ہے۔'
      }
    ],
    'Spanish': [
      {
        'text': '''El lenguaje es el hilo invisible que conecta a la humanidad a través de vastos continentes, océanos y siglos de historia. Es mucho más que un mero sistema de palabras, reglas gramaticales y sintaxis; es la esencia misma de la expresión humana, la cultura y la identidad. Cuando nos embarcamos en el viaje de aprender un nuevo idioma, no solo estamos adquiriendo una nueva habilidad para agregar a nuestros currículos; estamos desbloqueando una nueva dimensión del mundo y de nosotros mismos. El proceso de aprendizaje de idiomas requiere paciencia, dedicación y disposición para cometer errores, pero las recompensas que ofrece son verdaderamente inconmensurables y transformadoras.

Desde una perspectiva cognitiva, los beneficios del bilingüismo o multilingüismo son profundos y están bien documentados por la investigación científica. Aprender un nuevo idioma es como un entrenamiento riguroso para el cerebro. Fortalece las vías neuronales, mejora la retención de la memoria y mejora el pensamiento crítico y las habilidades de resolución de problemas. Los estudios han demostrado constantemente que las personas que hablan más de un idioma tienden a tener un mejor enfoque, son más expertas en la multitarea y pueden cambiar entre tareas con mayor facilidad.

Además, interactuar con un idioma extranjero puede construir una reserva cognitiva que ayuda a proteger el cerebro contra el deterioro relacionado con la edad, retrasando la aparición de afecciones como la demencia y la enfermedad de Alzheimer. La agilidad mental obtenida al navegar por diferentes estructuras lingüísticas es un activo para toda la vida. Más allá de las ventajas intelectuales, dominar un nuevo idioma ofrece oportunidades incomparables para la inmersión cultural y la conexión humana profunda. El lenguaje y la cultura están inextricablemente unidos; no puedes entender verdaderamente uno sin el otro.

Cuando aprendes a hablar con alguien en su lengua materna, no solo estás traduciendo palabras; estás traduciendo conceptos, humor, tradiciones y visiones del mundo. Nelson Mandela dijo la famosa frase: "Si le hablas a un hombre en un idioma que entiende, eso va a su cabeza. Si le hablas en su idioma, eso va a su corazón". Esta profunda afirmación resume el poder emocional y empático del lenguaje. Rompe las barreras de los prejuicios y la xenofobia, fomentando la ciudadanía global y el respeto mutuo.

En la economía altamente globalizada de hoy, los beneficios prácticos del dominio del idioma no pueden exagerarse. Las empresas multinacionales y las organizaciones internacionales buscan constantemente personas que puedan navegar las comunicaciones interculturales sin problemas. En última instancia, aprender un idioma es un viaje de crecimiento personal y autodescubrimiento. Nos obliga a salir de nuestras zonas de confort y amplía nuestra visión del mundo.''',
        'translation': 'El lenguaje conecta a la humanidad y es la esencia de la cultura. Aprender un nuevo idioma estimula el poder del cerebro, mejora la memoria y retrasa el envejecimiento cerebral. Abre puertas a nuevas culturas, mejores trabajos y crecimiento personal.'
      }
    ],
    'French': [
      {
        'text': '''La langue est le fil invisible qui relie l'humanité à travers de vastes continents, des océans et des siècles d'histoire. C'est bien plus qu'un simple système de mots, de règles grammaticales et de syntaxe; c'est l'essence même de l'expression humaine, de la culture et de l'identité. Lorsque nous nous engageons dans l'apprentissage d'une nouvelle langue, nous n'acquérons pas seulement une nouvelle compétence à ajouter à nos CV; nous débloquons une nouvelle dimension du monde et de nous-mêmes. Le processus d'apprentissage des langues exige de la patience, du dévouement et une volonté de faire des erreurs, mais les récompenses qu'il offre sont incommensurables.

D'un point de vue cognitif, les avantages du bilinguisme ou du multilinguisme sont profonds et bien documentés par la recherche scientifique. Apprendre une nouvelle langue est comme un entraînement rigoureux pour le cerveau. Il renforce les voies neuronales, améliore la rétention de la mémoire et améliore la pensée critique et les capacités de résolution de problèmes. Des études ont constamment montré que les personnes qui parlent plus d'une langue ont tendance à avoir une meilleure concentration, sont plus aptes au multitâche et peuvent passer d'une tâche à l'autre avec une plus grande facilité.

De plus, s'engager avec une langue étrangère peut constituer une réserve cognitive qui aide à protéger le cerveau contre le déclin lié à l'âge, retardant l'apparition d'affections telles que la démence et la maladie d'Alzheimer. L'agilité mentale acquise en naviguant dans différentes structures linguistiques est un atout pour la vie. Au-delà des avantages intellectuels, la maîtrise d'une nouvelle langue offre des opportunités inégalées d'immersion culturelle et de connexion humaine profonde. La langue et la culture sont inextricablement liées.

Lorsque vous apprenez à parler à quelqu'un dans sa langue maternelle, vous ne traduisez pas seulement des mots; vous traduisez des concepts, de l'humour, des traditions et des visions du monde. Nelson Mandela a dit une phrase célèbre: "Si vous parlez à un homme dans une langue qu'il comprend, cela va à sa tête. Si vous lui parlez dans sa langue, cela va à son cœur." Cette déclaration profonde résume le pouvoir émotionnel et empathique du langage. Il fait tomber les barrières des préjugés et de la xénophobie, favorisant la citoyenneté mondiale et le respect mutuel.

Dans l'économie hautement mondialisée d'aujourd'hui, les avantages pratiques de la maîtrise de la langue ne peuvent être surestimés. Apprendre une langue est un voyage de croissance personnelle et de découverte de soi. Cela nous oblige à sortir de nos zones de confort, remet en question nos idées préconçues et élargit notre vision du monde.''',
        'translation': 'Le langage relie l\'humanité et est l\'essence de la culture. Apprendre une nouvelle langue stimule la puissance cérébrale, améliore la mémoire et retarde le vieillissement cérébral. Il ouvre les portes à de nouvelles cultures et à de meilleurs emplois.'
      }
    ],
    'Chinese': [
      {
        'text': '''语言是连接人类跨越广阔大陆、海洋和几个世纪历史的无形纽带。它不仅仅是文字、语法规则和句法的简单系统；它是人类表达、文化和身份的真正本质。当我们踏上学习一门新语言的旅程时，我们不仅仅是获得了一项可以添加到简历中的新技能；我们正在开启世界和我们自己的一个新维度。语言学习的过程需要耐心、奉献精神和犯错的意愿，但它提供的回报确实是不可估量和改变生活的。

从认知的角度来看，双语或多语的好处是深远的，并得到了科学研究的充分证明。学习一门新语言就像是对大脑进行一次严格的锻炼。它加强了神经通路，提高了记忆力，并增强了批判性思维和解决问题的能力。研究一致表明，说不止一种语言的人往往有更好的注意力，更善于处理多项任务，并且可以更轻松地在任务之间切换。

此外，接触外语可以建立一种认知储备，有助于保护大脑免受与年龄相关的衰退，延缓痴呆症和阿尔茨海默病等疾病的发作。从驾驭不同的语言结构中获得的思维敏捷性是一生的财富。除了智力优势之外，掌握一门新语言为文化沉浸和深刻的人类联系提供了无与伦比的机会。语言和文化有着千丝万缕的联系；没有另一个，你就无法真正理解其中一个。

当你学会用某人的母语与他们交谈时，你不仅仅是在翻译单词；你正在翻译概念、幽默、传统和世界观。纳尔逊·曼德拉有一句名言：“如果你用一个人听得懂的语言和他说话，那会进入他的大脑。如果你用他的语言和他说话，那会进入他的心。” 这句深刻的话概括了语言的情感和同理心力量。它打破了偏见和仇外心理的障碍，促进了全球公民意识和相互尊重。

在当今高度全球化的经济中，语言能力的实际好处怎么强调都不为过。跨国公司和国际组织不断寻找能够无缝地进行跨文化交流的人才。双语可以为令人兴奋的职业机会、国际旅行和原本无法获得的合作打开大门。归根结底，学习一门语言是个人成长和自我发现的旅程。它迫使我们走出舒适区，挑战我们先入为主的观念，并拓宽我们的世界观。''',
        'translation': '语言连接着人类，是文化的本质。学习一门新语言可以增强脑力，提高记忆力，延缓大脑衰老。它为新文化、更好的工作和个人成长打开了大门。'
      }
    ],
    'Italian': [
      {
        'text': '''La lingua è il filo invisibile che connette l'umanità attraverso vasti continenti, oceani e secoli di storia. È molto più di un semplice sistema di parole, regole grammaticali e sintassi; è la vera essenza dell'espressione umana, della cultura e dell'identità. Quando intraprendiamo il viaggio di imparare una nuova lingua, non stiamo solo acquisendo una nuova abilità da aggiungere ai nostri curriculum; stiamo sbloccando una nuova dimensione del mondo e di noi stessi. Il processo di apprendimento delle lingue richiede pazienza, dedizione e la volontà di commettere errori, ma le ricompense che offre sono incommensurabili e cambiano la vita.

Da una prospettiva cognitiva, i benefici del bilinguismo o del multilinguismo sono profondi e ben documentati dalla ricerca scientifica. Imparare una nuova lingua è come un rigoroso allenamento per il cervello. Rafforza i percorsi neurali, migliora la ritenzione della memoria e migliora il pensiero critico e le capacità di risoluzione dei problemi. Gli studi hanno costantemente dimostrato che le persone che parlano più di una lingua tendono ad avere una concentrazione migliore, sono più abili nel multitasking e possono passare da un compito all'altro con maggiore facilità.

Inoltre, impegnarsi con una lingua straniera può costruire una riserva cognitiva che aiuta a proteggere il cervello dal declino legato all'età, ritardando l'insorgenza di condizioni come la demenza e il morbo di Alzheimer. L'agilità mentale acquisita navigando in diverse strutture linguistiche è una risorsa per tutta la vita. Oltre ai vantaggi intellettuali, padroneggiare una nuova lingua offre opportunità senza precedenti per l'immersione culturale e la profonda connessione umana. Lingua e cultura sono inestricabilmente collegate; non puoi veramente capire l'una senza l'altra.

Quando impari a parlare con qualcuno nella sua lingua madre, non stai solo traducendo parole; stai traducendo concetti, umorismo, tradizioni e visioni del mondo. Nelson Mandela disse notoriamente: "Se parli a un uomo in una lingua che capisce, quello gli va alla testa. Se gli parli nella sua lingua, quello gli va al cuore". Questa profonda affermazione racchiude il potere emotivo ed empatico del linguaggio. Abbatte le barriere del pregiudizio e della xenofobia, favorendo la cittadinanza globale e il rispetto reciproco.

Nell'odierna economia altamente globalizzata, i vantaggi pratici della conoscenza delle lingue non possono essere sopravvalutati. Le aziende multinazionali e le organizzazioni internazionali sono costantemente alla ricerca di persone in grado di navigare senza problemi nelle comunicazioni interculturali. In definitiva, imparare una lingua è un viaggio di crescita personale e scoperta di sé. Ci costringe a uscire dalle nostre zone di comfort e amplia la nostra visione del mondo.''',
        'translation': 'Il linguaggio connette l\'umanità ed è l\'essenza della cultura. Imparare una nuova lingua stimola il cervello, migliora la memoria e ritarda l\'invecchiamento cerebrale. Apre le porte a nuove culture, lavori migliori e crescita personale.'
      }
    ],
  };

  @override
  Widget build(BuildContext context) {
    var passages = readingMaterials[selectedLanguage] ?? [];
    var currentData = passages.isNotEmpty
        ? passages[currentPassageIndex]
        : {'text': 'No data available.', 'translation': ''};

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reading Practice', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Select Language:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: languages.map((lang) => ChoiceChip(
                  label: Text(lang),
                  selected: selectedLanguage == lang,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedLanguage = lang;
                    });
                  },
                  selectedColor: AppColors.accentPrimary,
                  labelStyle: TextStyle(
                    color: selectedLanguage == lang ? Colors.white : AppColors.textPrimary,
                  ),
                )).toList(),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.menu_book, color: AppColors.accentPrimary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                "$selectedLanguage Passage",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30, thickness: 1),

                      // ACTUAL LONG TEXT
                      Text(
                        currentData['text']!,
                        style: const TextStyle(fontSize: 16, height: 1.8, color: AppColors.textPrimary),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.accentSecondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.accentSecondary.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.g_translate, color: AppColors.accentSecondary, size: 20),
                                SizedBox(width: 8),
                                Text('Summary / Translation', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentSecondary)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              currentData['translation']!,
                              style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}