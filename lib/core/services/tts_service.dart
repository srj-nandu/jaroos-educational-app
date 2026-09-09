import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Abstract Text-to-Speech contract for JAROOS.
/// Provides a unified API for pronouncing words, letters, numbers, colors,
/// animal sounds, and reading bedtime stories and rhymes aloud.
abstract class TtsService {
  Future<void> speak(String text);
  Future<void> stop();
  Future<void> setSpeechRate(double rate);
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

  ModularTtsService({this.simulateDelay = true}) {
    // Only initialize native FlutterTts when not in headless test mode
    if (simulateDelay) {
      _initTts();
    }
  }

  Future<void> _initTts() async {
    try {
      _flutterTts = FlutterTts();

      // Configure child-friendly, energetic bubbly voice settings
      await _flutterTts!.setLanguage("en-US");
      await _flutterTts!.setSpeechRate(0.48); // Bouncy, animated child pace
      await _flutterTts!.setVolume(1.0);
      await _flutterTts!.setPitch(1.34); // Sweet, enthusiastic child-like pitch

      // Attempt to pick a natural youthful/child-like voice
      await _selectHumanizedVoice();

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
      debugPrint('[JAROOS TTS] Native FlutterTts child voice engine initialized successfully!');
    } catch (e) {
      debugPrint('[JAROOS TTS] Native FlutterTts initialization note: $e');
      _isInitialized = false;
    }
  }

  /// Automatically selects a youthful, female, or child-friendly neural voice
  Future<void> _selectHumanizedVoice() async {
    try {
      final voices = await _flutterTts!.getVoices;
      if (voices is List && voices.isNotEmpty) {
        dynamic bestVoice;
        int bestScore = -1;

        for (final voice in voices) {
          if (voice is Map) {
            final name = voice['name']?.toString().toLowerCase() ?? '';
            final locale = voice['locale']?.toString().toLowerCase() ?? '';

            if (locale.contains('en-us') || locale.contains('en_us') || locale.contains('en-gb') || locale.contains('en')) {
              int score = 0;
              // Strongly prioritize child/youthful/cheerful voice markers
              if (name.contains('child') || name.contains('kid') || name.contains('young') || name.contains('girl')) {
                score += 100;
              }
              // Google TTS energetic female/child neural voice
              if (name.contains('sfg') || name.contains('en-us-x-sfg-network')) {
                score += 85;
              }
              // Friendly, cheerful female neural voices
              if (name.contains('jenny') || name.contains('eva') || name.contains('zira') || name.contains('samantha')) {
                score += 65;
              }
              if (name.contains('neural') || name.contains('network') || name.contains('natural')) {
                score += 40;
              }
              if (name.contains('female') || name.contains('woman')) {
                score += 25;
              }
              // Penalize deep adult male voices for a kids app
              if (name.contains('david') || name.contains('mark') || name.contains('male')) {
                score -= 60;
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
          debugPrint('[JAROOS TTS] Child-friendly voice selected: ${voiceMap['name']} (score: $bestScore)');
        }
      }
    } catch (e) {
      debugPrint('[JAROOS TTS Voice Selection Note] $e');
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
  Future<void> setSpeechRate(double rate) async {
    if (_flutterTts != null && _isInitialized) {
      try {
        await _flutterTts!.setSpeechRate(rate);
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
    debugPrint('[JAROOS Child TTS] Speaking: "$humanized"');

    // Trigger gentle child tactile feedback on speech burst
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}

    if (_isInitialized && _flutterTts != null) {
      try {
        await _flutterTts!.stop();

        // Dynamically adjust pitch for excitement vs calm story narrative
        if (humanized.contains('!') || humanized.contains('Yay') || humanized.contains('Whoa') || humanized.contains('Wow')) {
          await _flutterTts!.setPitch(1.38); // Extra bouncy cartoon child excitement
          await _flutterTts!.setSpeechRate(0.49);
        } else if (clean.length > 150 || clean.contains('Once upon a time') || clean.contains('Bedtime')) {
          await _flutterTts!.setPitch(1.24); // Calmer, sweet bedtime storytelling
          await _flutterTts!.setSpeechRate(0.43);
        } else {
          await _flutterTts!.setPitch(1.34); // Standard sweet, animated child companion
          await _flutterTts!.setSpeechRate(0.48);
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
