import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../models/voice_persona_model.dart';

/// Abstract Text-to-Speech contract for JAROOS.
/// Provides a unified API for pronouncing words, letters, numbers, colors,
/// animal sounds, and reading bedtime stories and rhymes aloud.
abstract class TtsService {
  Future<void> speak(String text);
  Future<void> stop();
  Future<void> setSpeechRate(double rate);
  Future<void> setVoicePersona(String personaId);
  Future<void> setLanguage(String langCode);
  String get currentVoicePersona;
  String get currentLanguageCode;
  List<VoicePersona> get availablePersonas;
  Future<void> previewPersona(VoicePersona persona);
  bool get isSpeaking;
  ValueNotifier<String?> get currentSpeech;
}

/// Child-optimized Text-to-Speech implementation powered by native FlutterTts.
/// Features high-spirited childish pitch, bubbly cartoon prosody,
/// playful "wow factors", and dynamic emotion pitch modulation.
class ModularTtsService implements TtsService {
  final bool simulateDelay;
  FlutterTts? _flutterTts;
  bool _isSpeaking = false;
  final ValueNotifier<String?> _currentSpeech = ValueNotifier<String?>(null);
  bool _isInitialized = false;
  List<dynamic>? _cachedDeviceVoices;

  // Shared active persona, language, and speed multiplier across instances
  static String _activePersonaId = 'sparky_kid';
  static String _globalLanguageCode = 'en';
  static double _speechRateMultiplier = 1.0;

  static void setActivePersona(String personaId) {
    _activePersonaId = personaId;
  }

  static void setGlobalLanguageCode(String langCode) {
    _globalLanguageCode = langCode;
  }

  static String get globalLanguageCode => _globalLanguageCode;

  static void setGlobalSpeechRateMultiplier(double multiplier) {
    _speechRateMultiplier = multiplier;
  }

  ModularTtsService({this.simulateDelay = true}) {
    // Only initialize native FlutterTts when not in headless test mode
    if (simulateDelay) {
      _initTts();
    }
  }

  Future<void> _initTts() async {
    try {
      _flutterTts = FlutterTts();

      final persona = VoicePersona.getById(_activePersonaId);
      final ttsLocale = _globalLanguageCode == 'hi'
          ? 'hi-IN'
          : (_globalLanguageCode == 'ml' ? 'ml-IN' : 'en-US');
      await _flutterTts!.setLanguage(ttsLocale);
      await _flutterTts!.setSpeechRate((persona.baseRate * _speechRateMultiplier).clamp(0.2, 1.0));
      await _flutterTts!.setVolume(1.0);
      await _flutterTts!.setPitch(persona.basePitch);

      // Select system voice matching current persona
      await _selectVoiceForPersona(persona);

      // Await completion so buttons reflect active speaking state
      try {
        await _flutterTts!.awaitSpeakCompletion(true);
      } catch (_) {}

      _flutterTts!.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts!.setCompletionHandler(() {
        _isSpeaking = false;
        _currentSpeech.value = null;
      });

      _flutterTts!.setCancelHandler(() {
        _isSpeaking = false;
        _currentSpeech.value = null;
      });

      _flutterTts!.setErrorHandler((msg) {
        debugPrint('[JAROOS TTS Error] $msg');
        _isSpeaking = false;
        _currentSpeech.value = null;
      });

      _isInitialized = true;
      debugPrint('[JAROOS TTS] Native voice engine initialized ($ttsLocale) with persona: ${persona.name}!');
    } catch (e) {
      debugPrint('[JAROOS TTS] Native FlutterTts initialization note: $e');
      _isInitialized = false;
    }
  }

  /// Automatically selects the best device voice matching the given persona
  Future<void> _selectVoiceForPersona(VoicePersona persona) async {
    if (_flutterTts == null) return;
    try {
      _cachedDeviceVoices ??= await _flutterTts!.getVoices;
      final voices = _cachedDeviceVoices;
      if (voices is List && voices.isNotEmpty) {
        dynamic bestVoice;
        int bestScore = -100;

        final targetLang = persona.languageCode;

        for (final voice in voices) {
          if (voice is Map) {
            final name = voice['name']?.toString().toLowerCase() ?? '';
            final locale = voice['locale']?.toString().toLowerCase() ?? '';

            final isMatchingLocale = (targetLang == 'hi' && (locale.contains('hi') || name.contains('hindi') || name.contains('india'))) ||
                (targetLang == 'ml' && (locale.contains('ml') || name.contains('malayalam') || name.contains('india'))) ||
                (targetLang == 'en' && (locale.contains('en-us') || locale.contains('en_us') || locale.contains('en-gb') || locale.contains('en')));

            if (isMatchingLocale) {
              int score = 0;

              for (final kw in persona.voiceKeywords) {
                if (name.contains(kw.toLowerCase())) {
                  score += 45;
                }
              }

              if (persona.id == 'sparky_kid') {
                if (name.contains('child') || name.contains('kid') || name.contains('young') || name.contains('girl')) {
                  score += 60;
                }
                if (name.contains('sfg')) score += 50;
                if (name.contains('david') || name.contains('male')) score -= 80;
              } else if (persona.id == 'dora_explorer') {
                if (name.contains('child') || name.contains('girl') || name.contains('young') || name.contains('eva') || name.contains('sfg')) {
                  score += 65;
                }
                if (name.contains('es') || name.contains('spanish') || name.contains('mexico') || name.contains('latin')) {
                  score += 40;
                }
                if (name.contains('david') || name.contains('male')) score -= 80;
              } else if (persona.id == 'sweet_lily') {
                if (name.contains('female') || name.contains('woman') || name.contains('girl') || name.contains('eva') || name.contains('jenny')) {
                  score += 60;
                }
                if (name.contains('male') || name.contains('david')) score -= 80;
              } else if (persona.id == 'cheerful_leo') {
                if (name.contains('young') || name.contains('boy') || name.contains('natural')) {
                  score += 50;
                }
              } else if (persona.id == 'teacher_emma') {
                if (name.contains('female') || name.contains('natural') || name.contains('neural')) {
                  score += 50;
                }
              } else if (persona.id == 'robo_buddy') {
                if (name.contains('network') || name.contains('neural') || name.contains('en-us')) {
                  score += 30;
                }
              } else if (persona.id == 'aarav_kid') {
                if (name.contains('child') || name.contains('female') || name.contains('natural')) score += 50;
                if (name.contains('male') && !name.contains('female')) score -= 40;
              } else if (persona.id == 'pari_story') {
                if (name.contains('female') || name.contains('woman') || name.contains('eva')) score += 50;
              } else if (persona.id == 'unni_kid') {
                if (name.contains('child') || name.contains('female') || name.contains('natural')) score += 50;
                if (name.contains('male') && !name.contains('female')) score -= 40;
              } else if (persona.id == 'meenu_story') {
                if (name.contains('female') || name.contains('woman')) score += 50;
              }

              if (score > bestScore) {
                bestScore = score;
                bestVoice = voice;
              }
            }
          }
        }

        if (bestVoice != null && bestVoice is Map) {
          final voiceMap = Map<String, String>.from(
            bestVoice.map((k, v) => MapEntry(k.toString(), v.toString())),
          );
          await _flutterTts!.setVoice(voiceMap);
          debugPrint('[JAROOS TTS] Voice for persona "${persona.name}" selected: ${voiceMap['name']} (score: $bestScore)');
        }
      }
    } catch (e) {
      debugPrint('[JAROOS TTS Voice Selection Note] $e');
    }
  }

  Future<void> _applyVoicePersona(VoicePersona persona) async {
    if (_flutterTts == null || !_isInitialized) return;
    try {
      final ttsLocale = persona.languageCode == 'hi'
          ? 'hi-IN'
          : (persona.languageCode == 'ml' ? 'ml-IN' : 'en-US');
      await _flutterTts!.setLanguage(ttsLocale);
      await _selectVoiceForPersona(persona);
      await _flutterTts!.setPitch(persona.basePitch);
      await _flutterTts!.setSpeechRate((persona.baseRate * _speechRateMultiplier).clamp(0.2, 1.0));
    } catch (e) {
      debugPrint('[JAROOS TTS Apply Persona Note] $e');
    }
  }

  /// Enriches speech with child-like enthusiasm, animated wow factors,
  /// playful sound words, and natural breath rhythm.
  String _humanizeText(String raw) {
    var text = raw.trim();
    if (text.isEmpty) return text;

    final isDora = _activePersonaId == 'dora_explorer';

    // 1. Module intro hooks & child wow factors
    if (text.startsWith("Opening ") && text.endsWith(" practice!")) {
      final module = text.substring("Opening ".length, text.length - " practice!".length);
      if (_globalLanguageCode == 'hi') {
        switch (module.toLowerCase()) {
          case 'alphabet':
            return "वाह! चलो वर्णमाला सीखते हैं! क ख ग... कितना मज़ा आएगा! 🔤🎈";
          case 'numbers':
            return "अरे वाह! संख्याओं का सफर! 1, 2, 3... चलो साथ मिलकर गिनते हैं! ⭐";
          case 'colors':
            return "सुंदर रंग! चलो जादूई रंगों को पहचानते हैं! 🎨✨";
          case 'shapes':
            return "वाह! तरह-तरह के आकार! गोल और तिकोना ढूंढते हैं! 🔷";
          case 'animals':
            return "चलो प्यारे जानवरों से मिलते हैं! जंगल सफारी! 🦁🐾";
          case 'fruits':
            return "स्वादिष्ट और रसीले फल! यम यम! 🍎🍌";
          case 'stories':
            return "जादूई कहानी का समय! सुनो एक प्यारी सी कहानी! 📖✨";
          case 'rhymes':
            return "मज़ेदार बालगीत! चलो गाते हैं और नाचते हैं! 🎵💃";
          case 'quiz':
            return "वाह! सवाल जवाब का खेल! आप जीतेंगे! 🏆⭐";
          case 'ai buddy':
            return "नमस्ते दोस्त! मैं आपके साथ खेलने के लिए तैयार हूँ! 🤖🎈";
          case 'ai stories':
            return "चलो मिलकर एक अनोखी जादूई कहानी बनाते हैं! 🪄✨";
          default:
            return "चलो $module सीखते हैं! 🚀";
        }
      } else if (_globalLanguageCode == 'ml') {
        switch (module.toLowerCase()) {
          case 'alphabet':
            return "വൗ! നമുക്ക് അക്ഷരമാല പഠിക്കാം! അ ആ ഇ... രസകരമായി പഠിക്കാം! 🔤🎈";
          case 'numbers':
            return "അടിപൊളി! സംഖ്യകളുടെ ലോകം! 1, 2, 3... നമുക്ക് ഒരുമിച്ച് എണ്ണാം! ⭐";
          case 'colors':
            return "മനോഹരമായ നിറങ്ങൾ! വർണ്ണങ്ങളുടെ മാന്ത്രിക ലോകം! 🎨✨";
          case 'shapes':
            return "നല്ല രൂപങ്ങൾ! വട്ടവും ത്രികോണവും കണ്ടെത്താം! 🔷";
          case 'animals':
            return "നമുക്ക് മൃഗങ്ങളെ പരിചയപ്പെടാം! കാട്ടുസവാരി! 🦁🐾";
          case 'fruits':
            return "രുചികരമായ പഴങ്ങൾ! യമ്മി യമ്മി! 🍎🍌";
          case 'stories':
            return "കഥാ സമയം! നമുക്കൊരു നല്ല കഥ കേൾക്കാം! 📖✨";
          case 'rhymes':
            return "പാട്ടുപാടാം! നമുക്ക് ഒരുമിച്ച് പാടി നൃത്തം ചെയ്യാം! 🎵💃";
          case 'quiz':
            return "അടിപൊളി ക്വിസ്! നിങ്ങൾക്കത് സാധിക്കും! 🏆⭐";
          case 'ai buddy':
            return "ഹലോ കൂട്ടുകാരാ! നിങ്ങളോടൊപ്പം കളിക്കാൻ എനിക്ക് സന്തോഷമുണ്ട്! 🤖🎈";
          case 'ai stories':
            return "നമുക്കൊരു മാന്ത്രിക കഥ ഉണ്ടാക്കാം! 🪄✨";
          default:
            return "നമുക്ക് $module പഠിക്കാം! 🚀";
        }
      } else if (isDora) {
        switch (module.toLowerCase()) {
          case 'alphabet':
            return "¡Vámonos! Let's explore the Alphabet! Say the letters with me! 🔤🎒";
          case 'numbers':
            return "¡Uno, dos, tres! Let's count together on our adventure! 1, 2, 3! ⭐🎒";
          case 'colors':
            return "¡Colores! Beautiful rainbow magic! Can you spot the colors? 🎨✨";
          case 'shapes':
            return "Shape quest! Let's find circles and triangles together! ¡Vámonos! 🔷🎒";
          case 'animals':
            return "¡Mira! Animal safari! Say it with me... Rooaaarr! 🦁🎒";
          case 'fruits':
            return "Yum yum! Crunchy healthy snacks for our backpack! 🍎🍌";
          case 'stories':
            return "Storytime adventure! Open the magical book! ¡Vámonos! 📖✨";
          case 'rhymes':
            return "Sing-along fiesta! Sing and dance with Dora! 🎵💃";
          case 'quiz':
            return "Super Explorer Challenge! You can do it! ¡Vámonos! 🏆🎒";
          case 'ai buddy':
            return "¡Hola amigo! Dora is super excited to explore with you! 🎒✨";
          case 'ai stories':
            return "¡Magia! Let's create an epic adventure story! 🪄🎒";
          default:
            return "¡Vámonos! Let's explore $module together! 🎒🚀";
        }
      } else {
        switch (module.toLowerCase()) {
          case 'alphabet':
            return "Yay! Let's explore the Alphabet! A B C fun! Wow! 🔤🎈";
          case 'numbers':
            return "Whoa! Number adventure! 1, 2, 3... Let's count together! ⭐";
          case 'colors':
            return "Ooh, pretty colors! Rainbow magic time! Sparkle sparkle! 🎨✨";
          case 'shapes':
            return "Super cool shapes! Let's spot circles and triangles! Wow! 🔷";
          case 'animals':
            return "Rooaaarr! Animal safari time! Let's meet our wild friends! 🦁🐾";
          case 'fruits':
            return "Yum yum! Juicy fruits and crunchy veggies! So yummy! 🍎🥕";
          case 'stories':
            return "Ooh, storybook magic! Settle in for a wonderful tale! 📖✨";
          case 'rhymes':
            return "Sing-along party! Let's sing and dance together! 🎵💃";
          case 'quiz':
            return "Woo-hooo! Quiz challenge! You've got this, superstar! 🏆⭐";
          case 'ai buddy':
            return "Hello friend! Sparky is super excited to play with you! 🤖🎈";
          case 'ai stories':
            return "Abracadabra! Let's create our very own magical story! 🪄✨";
          default:
            return "Yay! Let's jump into $module! Here we go! 🚀";
        }
      }
    }

    // 2. Transform dry educational statements into energetic praise
    if (_globalLanguageCode == 'hi') {
      text = text.replaceAll('Awesome! That is correct!', 'शाबाश! बिल्कुल सही जवाब! कमाल कर दिया! ⭐');
      text = text.replaceAll('Not quite!', 'कोई बात नहीं! फिर से कोशिश करो, तुम कर सकते हो! 🎈');
      text = text.replaceAll('Quiz completed!', 'बधाई हो! आपने पूरा कर लिया! आप तो सुपरस्टार हैं! 🏆✨');
      text = text.replaceAll('Fantastic effort!', 'अद्भुत प्रयास! बहुत बढ़िया! 🌟');
      text = text.replaceAll('Congratulations!', 'बहुत-बहुत बधाई! शाबाश! 🎉🏆');
      text = text.replaceAll('Great job!', 'कमाल कर दिया! बहुत खूब! 🌟');
      text = text.replaceAll('You found a treasure chest! You earned 20 bonus coins!', 'अरे वाह! खज़ाना मिल गया! आपको मिले 20 चमकदार सिक्के! 💎✨');
      text = text.replaceAll('This lesson is locked! Complete the earlier steps first!', 'यह पाठ अभी बंद है! पहले पिछला पाठ पूरा करें! 🗝️✨');
      text = text.replaceAll("Let's start ", "चलो शुरू करते हैं ");
    } else if (_globalLanguageCode == 'ml') {
      text = text.replaceAll('Awesome! That is correct!', 'ഗംഭീരം! ഉത്തരം ശരിയാണ്! അടിപൊളി! ⭐');
      text = text.replaceAll('Not quite!', 'കുഴപ്പമില്ല! വീണ്ടും ശ്രമിക്കൂ, നിങ്ങളെക്കൊണ്ട് കഴിയും! 🎈');
      text = text.replaceAll('Quiz completed!', 'അഭിനന്ദനങ്ങൾ! നിങ്ങൾ മിടുക്കനാണ്! സൂപ്പർസ്റ്റാർ! 🏆✨');
      text = text.replaceAll('Fantastic effort!', 'മികച്ച പരിശ്രമം! വളരെ നന്നായിട്ടുണ്ട്! 🌟');
      text = text.replaceAll('Congratulations!', 'ഹൃദയം നിറഞ്ഞ അഭിനന്ദനങ്ങൾ! 🎉🏆');
      text = text.replaceAll('Great job!', 'വളരെ നന്നായി ചെയ്തു! മിടുക്കൻ! 🌟');
      text = text.replaceAll('You found a treasure chest! You earned 20 bonus coins!', 'വൗ! മാന്ത്രിക നിധിപ്പെട്ടി തുറന്നു! നിങ്ങൾക്ക് 20 ബോണസ് നാണയങ്ങൾ ലഭിച്ചു! 💎✨');
      text = text.replaceAll('This lesson is locked! Complete the earlier steps first!', 'ഈ പാഠം പൂട്ടിയതാണ്! ആദ്യം മുമ്പത്തെ പാഠം പൂർത്തിയാക്കൂ! 🗝️✨');
      text = text.replaceAll("Let's start ", "നമുക്ക് തുടങ്ങാം ");
    } else if (isDora) {
      text = text.replaceAll('Awesome! That is correct!', 'We did it! ¡Lo hicimos! That is correct! Super! High five! 🎒⭐');
      text = text.replaceAll('Not quite!', 'Aww, keep trying! We can do it together! Check your map! 🧭🎒');
      text = text.replaceAll('Quiz completed!', 'We did it! We did it! ¡Lo hicimos! Hooray! You are a super explorer! 🏆🎒');
      text = text.replaceAll('Fantastic effort!', '¡Excelente! Super explorer effort! High five! 🌟🎒');
      text = text.replaceAll('Congratulations!', '¡Felicidades! We did it! Hooray! You did it! 🎉🎒');
      text = text.replaceAll('Great job!', '¡Muy bien! Great job, super explorer! 🌟🎒');
      text = text.replaceAll('You found a treasure chest! You earned 20 bonus coins!', '¡Mira! You found the golden treasure chest! We did it! 20 shiny coins for your backpack! 💎🎒');
      text = text.replaceAll('This lesson is locked! Complete the earlier steps first!', 'Uh-oh! Check your map! We need to visit the earlier step first! 🗝️🎒');
      text = text.replaceAll("Let's start ", "¡Vámonos! Let's explore ");
    } else {
      text = text.replaceAll('Awesome! That is correct!', 'Woo-hooo! Bingo! You got it right! Wow! High five! ⭐');
      text = text.replaceAll('Not quite!', 'Aww, so close! You can do it! Let\'s try together! 🎈');
      text = text.replaceAll('Quiz completed!', 'Tadaaa! Quiz completed! You\'re a superstar! 🏆✨');
      text = text.replaceAll('Fantastic effort!', 'Super-duper amazing effort! High five! 🌟');
      text = text.replaceAll('Congratulations!', 'Yaaay! Hoo-ray! You did it! Congratu-lations! 🎉🏆');
      text = text.replaceAll('Great job!', 'Wowww! Fantastic job, little explorer! 🌟');
      text = text.replaceAll('You found a treasure chest! You earned 20 bonus coins!', 'Whoaaa! A magical treasure chest popped open! Sparkle, sparkle! You won 20 shiny bonus coins! 💎✨');
      text = text.replaceAll('This lesson is locked! Complete the earlier steps first!', 'Uh-oh! That lock is still sleeping! Finish the earlier step to wake it up! 🗝️✨');
      text = text.replaceAll("Let's start ", "Yippee! Let's jump into ");
    }

    // 5. Module item child-friendly enrichments
    if (text.startsWith("Color ") && text.contains("! Like ")) {
      text = text.replaceFirst("Color ", "Ooh, pretty color ");
      text = text.replaceAll("! Like ", "! Bright and colorful, like ");
    } else if (text.startsWith("Number ") && text.contains("! Count ")) {
      text = text.replaceFirst("Number ", "Yay! Number ");
      text = text.replaceAll("! Count ", "! Count along with me! ");
    } else if (text.startsWith("This is a ") && text.contains("Completely Round")) {
      text = text.replaceFirst("This is a ", "Ta-daa! Look at this shape! A ");
    } else if (text.startsWith("This is a ") && text.contains("! It is a healthy ")) {
      text = text.replaceFirst("This is a ", "Yum yum! Look at this delicious ");
      text = text.replaceAll("! It is a healthy ", "! A crunchy, healthy ");
    }

    // 6. Expressive prosody and breath pauses
    text = text.replaceAll('. ', '... ');
    text = text.replaceAll('! ', '! ... ');
    text = text.replaceAll('? ', '? ... ');
    text = text.replaceAll(': ', '... ');

    // Normalize multiple dots and whitespace
    text = text.replaceAll(RegExp(r'\.{4,}'), '... ');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }

  @override
  bool get isSpeaking => _isSpeaking;

  @override
  ValueNotifier<String?> get currentSpeech => _currentSpeech;

  @override
  String get currentVoicePersona => _activePersonaId;

  @override
  String get currentLanguageCode => _globalLanguageCode;

  @override
  List<VoicePersona> get availablePersonas => VoicePersona.getByLanguage(_globalLanguageCode);

  @override
  Future<void> setLanguage(String langCode) async {
    _globalLanguageCode = langCode;
    final defaultVoice = VoicePersona.getDefaultForLanguage(langCode);
    _activePersonaId = defaultVoice.id;
    if (_flutterTts != null && _isInitialized) {
      try {
        final ttsLocale = langCode == 'hi' ? 'hi-IN' : (langCode == 'ml' ? 'ml-IN' : 'en-US');
        await _flutterTts!.setLanguage(ttsLocale);
        await _applyVoicePersona(defaultVoice);
      } catch (_) {}
    }
  }

  @override
  Future<void> setVoicePersona(String personaId) async {
    _activePersonaId = personaId;
    final persona = VoicePersona.getById(personaId);
    await _applyVoicePersona(persona);
  }

  @override
  Future<void> previewPersona(VoicePersona persona) async {
    await stop();
    final savedPersonaId = _activePersonaId;
    _activePersonaId = persona.id;
    if (_flutterTts != null && _isInitialized) {
      await _applyVoicePersona(persona);
    }
    await speak(persona.samplePhrase);
    _activePersonaId = savedPersonaId;
    if (_flutterTts != null && _isInitialized) {
      await _applyVoicePersona(VoicePersona.getById(savedPersonaId));
    }
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    _speechRateMultiplier = rate;
    final persona = VoicePersona.getById(_activePersonaId);
    if (_flutterTts != null && _isInitialized) {
      try {
        await _flutterTts!.setSpeechRate((persona.baseRate * _speechRateMultiplier).clamp(0.2, 1.0));
      } catch (_) {}
    }
  }

  @override
  Future<void> speak(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;

    final humanized = _humanizeText(clean);

    _isSpeaking = true;
    _currentSpeech.value = clean;
    debugPrint('[JAROOS TTS ($_activePersonaId)] Speaking: "$humanized"');

    // Trigger gentle child tactile feedback on speech burst
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}

    if (_isInitialized && _flutterTts != null) {
      try {
        await _flutterTts!.stop();

        final persona = VoicePersona.getById(_activePersonaId);

        // Dynamically adjust pitch for excitement vs calm story narrative
        if (humanized.contains('!') || humanized.contains('Yay') || humanized.contains('Whoa') || humanized.contains('Wow')) {
          await _flutterTts!.setPitch(persona.excitedPitch);
          await _flutterTts!.setSpeechRate(((persona.baseRate + 0.01) * _speechRateMultiplier).clamp(0.2, 1.0));
        } else if (clean.length > 150 || clean.contains('Once upon a time') || clean.contains('Bedtime')) {
          await _flutterTts!.setPitch(persona.calmPitch);
          await _flutterTts!.setSpeechRate(((persona.baseRate - 0.04) * _speechRateMultiplier).clamp(0.2, 1.0));
        } else {
          await _flutterTts!.setPitch(persona.basePitch);
          await _flutterTts!.setSpeechRate((persona.baseRate * _speechRateMultiplier).clamp(0.2, 1.0));
        }

        await _flutterTts!.speak(humanized);
        _isSpeaking = false;
        _currentSpeech.value = null;
        return;
      } catch (e) {
        debugPrint('[JAROOS TTS Playback Fallback] $e');
      }
    }

    // Fallback timer simulation when running in tests or if native engine is unavailable
    if (simulateDelay) {
      final words = clean.split(' ').length;
      final durationMs = (words * 250).clamp(400, 2500);
      await Future.delayed(Duration(milliseconds: durationMs));
    }

    _isSpeaking = false;
    _currentSpeech.value = null;
  }

  @override
  Future<void> stop() async {
    _isSpeaking = false;
    _currentSpeech.value = null;
    if (_isInitialized && _flutterTts != null) {
      try {
        await _flutterTts!.stop();
      } catch (_) {}
    }
    debugPrint('[JAROOS TTS] Stopped speech.');
  }
}
