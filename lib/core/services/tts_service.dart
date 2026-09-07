import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Abstract Text-to-Speech contract for JAROOS.
/// Provides a unified API for pronouncing words, letters, numbers, colors,
/// animal sounds, and reading bedtime stories and rhymes aloud.
abstract class TtsService {
  Future<void> speak(String text);
  Future<void> stop();
  Future<void> setSpeechRate(double rate);
  Future<void> setPitch(double pitch);
  Future<void> singPhrase(String text, {double pitch = 1.0, double rate = 0.40});
  bool get isSpeaking;
  ValueNotifier<String?> get currentSpeech;
}

/// Modular Text-to-Speech implementation powered by native FlutterTts.
/// Features child-optimized speech rate, cheerful high-clarity pitch,
/// automatic completion callbacks, and safe fallback for tests/unsupported platforms.
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

      // Configure child-friendly, humanized voice settings
      await _flutterTts!.setLanguage("en-US");
      await _flutterTts!.setSpeechRate(0.44); // Warm, gentle conversational pace
      await _flutterTts!.setVolume(1.0);
      await _flutterTts!.setPitch(1.08); // Cheerful, friendly, encouraging pitch

      // Attempt to pick a natural neural / humanized voice
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
      debugPrint('[JAROOS TTS] Native FlutterTts humanized engine initialized successfully!');
    } catch (e) {
      debugPrint('[JAROOS TTS] Native FlutterTts initialization note: $e');
      _isInitialized = false;
    }
  }

  /// Automatically selects a natural, human-like voice from available device voices
  Future<void> _selectHumanizedVoice() async {
    try {
      final voices = await _flutterTts!.getVoices;
      if (voices is List && voices.isNotEmpty) {
        dynamic selectedVoice;
        for (final voice in voices) {
          if (voice is Map) {
            final name = voice['name']?.toString().toLowerCase() ?? '';
            final locale = voice['locale']?.toString().toLowerCase() ?? '';
            if (locale.contains('en-us') || locale.contains('en_us') || locale.contains('en-gb') || locale.contains('en')) {
              // Prioritize natural neural/network voices for lifelike speech
              if (name.contains('neural') || name.contains('network') || name.contains('natural') || name.contains('sfg') || name.contains('iom')) {
                selectedVoice = voice;
                break;
              }
            }
          }
        }
        if (selectedVoice != null && selectedVoice is Map) {
          final voiceMap = Map<String, String>.from(
            selectedVoice.map((k, v) => MapEntry(k.toString(), v.toString())),
          );
          await _flutterTts!.setVoice(voiceMap);
          debugPrint('[JAROOS TTS] Humanized voice selected: ${voiceMap['name']}');
        }
      }
    } catch (e) {
      debugPrint('[JAROOS TTS Voice Selection Note] $e');
    }
  }

  /// Preprocesses text to introduce natural phrasing, pause rhythm, and clear phonetics
  String _humanizeText(String raw) {
    var text = raw.trim();
    // Add micro-pause after periods and colons
    text = text.replaceAll('. ', '... ');
    text = text.replaceAll('! ', '! ');
    text = text.replaceAll(': ', '... ');
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
  Future<void> setPitch(double pitch) async {
    if (_flutterTts != null && _isInitialized) {
      try {
        await _flutterTts!.setPitch(pitch.clamp(0.5, 2.0));
      } catch (_) {}
    }
  }

  @override
  Future<void> singPhrase(String text, {double pitch = 1.0, double rate = 0.40}) async {
    final clean = text.trim();
    if (clean.isEmpty) return;

    _isSpeaking = true;
    _currentSpeech.value = clean;
    debugPrint('[JAROOS Sing] (Pitch: $pitch, Rate: $rate) "$clean"');

    if (_isInitialized && _flutterTts != null) {
      try {
        await _flutterTts!.stop();
        await _flutterTts!.setPitch(pitch.clamp(0.5, 2.0));
        await _flutterTts!.setSpeechRate(rate.clamp(0.1, 1.0));
        await _flutterTts!.speak(clean);
        await _flutterTts!.setPitch(1.08);
        await _flutterTts!.setSpeechRate(0.44);
        _isSpeaking = false;
        _currentSpeech.value = null;
        return;
      } catch (e) {
        debugPrint('[JAROOS Sing Fallback] $e');
      }
    }

    if (simulateDelay) {
      final words = clean.split(' ').length;
      final durationMs = (words * 280).clamp(400, 3000);
      await Future.delayed(Duration(milliseconds: durationMs));
    }

    _isSpeaking = false;
    _currentSpeech.value = null;
  }

  @override
  Future<void> speak(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;

    final humanized = _humanizeText(clean);

    _isSpeaking = true;
    _currentSpeech.value = clean;
    debugPrint('[JAROOS TTS] Speaking: "$humanized"');

    if (_isInitialized && _flutterTts != null) {
      try {
        await _flutterTts!.stop();
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
