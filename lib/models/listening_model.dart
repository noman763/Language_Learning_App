class LanguageConfig {
  final String sttLocale;
  final String ltCode;
  final String ttsLocale;
  final List<String> sentences;

  LanguageConfig({
    required this.sttLocale,
    required this.ltCode,
    required this.ttsLocale,
    required this.sentences,
  });
}

final Map<String, LanguageConfig> listeningData = {
  "English": LanguageConfig(
    sttLocale: "en_US",
    ltCode: "en-US",
    ttsLocale: "en-US",
    sentences: [
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
    ],
  ),
  "Urdu": LanguageConfig(
    sttLocale: "ur_PK",
    ltCode: "auto",
    ttsLocale: "ur-PK",
    sentences: [
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
    ],
  ),
  "Spanish": LanguageConfig(
    sttLocale: "es_ES",
    ltCode: "es",
    ttsLocale: "es-ES",
    sentences: [
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
    ],
  ),
  "French": LanguageConfig(
    sttLocale: "fr_FR",
    ltCode: "fr",
    ttsLocale: "fr-FR",
    sentences: [
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
    ],
  ),
  "Italian": LanguageConfig(
    sttLocale: "it_IT",
    ltCode: "it",
    ttsLocale: "it-IT",
    sentences: [
      "Imparare una nuova lingua apre una nuova dimensione.",
      "La tecnologia si sta evolvendo più velocemente possibile.",
      "Vorrei ordinare una tazza di caffè, per favore.",
      "Il successo non è definitivo, il fallimento non è fatale.",
      "La salute è ricchezza, dobbiamo fare esercizio ogni giorno.",
      "La musica ha l'incredibile potere di guarire l'anima.",
      "L'istruzione è l'arma più potente per cambiare il mondo.",
      "La felicità non è qualcosa di pronto, deriva dalle tue azioni.",
      "Un viaggio di mille miglia inizia con un solo passo.",
      "Con il duro lavoro si può obtener qualsiasi cosa."
    ],
  ),
  "Chinese": LanguageConfig(
    sttLocale: "zh_CN",
    ltCode: "zh",
    ttsLocale: "zh-CN",
    sentences: [
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
    ],
  ),
};