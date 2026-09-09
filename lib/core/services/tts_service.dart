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
  String get currentVoicePersona;
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

  // Shared active persona and speed multiplier across instances
  static String _activePersonaId = 'sparky_kid';
  static double _speechRateMultiplier = 1.0;

  static void setActivePersona(String personaId) {
    _activePersonaId = personaId;
  }

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
      await _flutterTts!.setLanguage("en-US");
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
      debugPrint('[JAROOS TTS] Native child voice engine initialized successfully with persona: ${persona.name}!');
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

        for (final voice in voices) {
          if (voice is Map) {
            final name = voice['name']?.toString().toLowerCase() ?? '';
            final locale = voice['locale']?.toString().toLowerCase() ?? '';

            if (locale.contains('en-us') || locale.contains('en_us') || locale.contains('en-gb') || locale.contains('en')) {
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

    // 1. Module intro hooks & child wow factors
    if (text.startsWith("Opening ") && text.endsWith(" practice!")) {
      final module = text.substring("Opening ".length, text.length - " practice!".length);
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

    // 2. Transform dry educational statements into bubbly child praise
    text = text.replaceAll('Awesome! That is correct!', 'Woo-hooo! Bingo! You got it right! Wow! High five! ⭐');
    text = text.replaceAll('Not quite!', 'Aww, so close! You can do it! Let\'s try together! 🎈');
    text = text.replaceAll('Quiz completed!', 'Tadaaa! Quiz completed! You\'re a superstar! 🏆✨');
    text = text.replaceAll('Fantastic effort!', 'Super-duper amazing effort! High five! 🌟');
    text = text.replaceAll('Congratulations!', 'Yaaay! Hoo-ray! You did it! Congratu-lations! 🎉🏆');
    text = text.replaceAll('Great job!', 'Wowww! Fantastic job, little explorer! 🌟');

    // 3. Animal sound enhancements
    text = text.replaceAll('says Roar', 'says... Rooaaarrr! 🦁 Wow, mighty lion!');
    text = text.replaceAll('says "Meow Meow"', 'says... Mee-owww, mee-oww! 🐱 So cute!');
    text = text.replaceAll('says Moo', 'says... Moo-mooooo! 🐮 Sweet milk!');
    text = text.replaceAll('says Quack', 'says... Quack-quack-quack! 🦆 Splish splash!');
    text = text.replaceAll('says Oink', 'says... Oink-oink-oink! 🐷 Roll in mud!');
    text = text.replaceAll('says Baa', 'says... Baaa-baa! 🐑 Soft wool!');

    // 4. Learning path & interaction wow factors
    text = text.replaceAll('You found a treasure chest! You earned 20 bonus coins!', 'Whoaaa! A magical treasure chest popped open! Sparkle, sparkle! You won 20 shiny bonus coins! 💎✨');
    text = text.replaceAll('This lesson is locked! Complete the earlier steps first!', 'Uh-oh! That lock is still sleeping! Finish the earlier step to wake it up! 🗝️✨');
    text = text.replaceAll("Let's start ", "Yippee! Let's jump into ");

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
  List<VoicePersona> get availablePersonas => VoicePersona.all;

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
