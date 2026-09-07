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

      // Configure child-friendly voice settings
      await _flutterTts!.setLanguage("en-US");
      await _flutterTts!.setSpeechRate(0.48); // Calm, gentle toddler pace
      await _flutterTts!.setVolume(1.0);
      await _flutterTts!.setPitch(1.05); // Cheerful child-friendly pitch

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
      debugPrint('[JAROOS TTS] Native FlutterTts initialized successfully!');
    } catch (e) {
      debugPrint('[JAROOS TTS] Native FlutterTts initialization note: $e');
      _isInitialized = false;
    }
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

    _isSpeaking = true;
    _currentSpeech.value = clean;
    debugPrint('[JAROOS TTS] Speaking: "$clean"');

    if (_isInitialized && _flutterTts != null) {
      try {
        await _flutterTts!.stop();
        await _flutterTts!.speak(clean);
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
