import 'dart:math';
import 'package:flutter/material.dart';
import '../models/parent_settings_model.dart';

/// Centralized state management for parental controls, screen time monitoring,
/// PIN verification, and child safety gates in JAROOS.
class ParentProvider with ChangeNotifier {
  ParentSettingsModel _settings = const ParentSettingsModel();

  // Math Challenge State for Parent Gate
  String _mathQuestion = '8 × 4';
  int _mathAnswer = 32;

  ParentProvider() {
    generateNewMathChallenge();
  }

  ParentSettingsModel get settings => _settings;
  String get mathQuestion => _mathQuestion;

  /// Check if a given 4-digit PIN matches
  bool verifyPin(String pin) {
    return pin.trim() == _settings.parentPin;
  }

  /// Check if the math challenge answer is correct
  bool verifyMathAnswer(int answer) {
    return answer == _mathAnswer;
  }

  /// Generate a new adult-level math question for the parent gate
  void generateNewMathChallenge() {
    final rand = Random();
    final isMultiply = rand.nextBool();
    if (isMultiply) {
      final a = rand.nextInt(8) + 3; // 3 to 10
      final b = rand.nextInt(8) + 3; // 3 to 10
      _mathQuestion = '$a × $b';
      _mathAnswer = a * b;
    } else {
      final a = rand.nextInt(35) + 15; // 15 to 49
      final b = rand.nextInt(35) + 15; // 15 to 49
      _mathQuestion = '$a + $b';
      _mathAnswer = a + b;
    }
    notifyListeners();
  }

  /// Update the 4-digit security PIN
  void updatePin(String newPin) {
    if (newPin.trim().length == 4) {
      _settings = _settings.copyWith(parentPin: newPin.trim());
      notifyListeners();
    }
  }

  /// Toggle between PIN gate and Math Challenge gate
  void setGateMode({required bool useMathGate}) {
    _settings = _settings.copyWith(useMathGate: useMathGate);
    notifyListeners();
  }

  /// Set the daily screen time limit in minutes (0 = unlimited)
  void setDailyTimeLimit(int minutes) {
    _settings = _settings.copyWith(dailyTimeLimitMinutes: minutes);
    notifyListeners();
  }

  /// Add usage time
  void recordScreenTime(int minutes) {
    _settings = _settings.copyWith(
      todayScreenTimeMinutes: _settings.todayScreenTimeMinutes + minutes,
    );
    notifyListeners();
  }

  /// Check whether a module is enabled by parents
  bool isModuleEnabled(String moduleId) {
    return !_settings.disabledModuleIds.contains(moduleId);
  }

  /// Toggle a module between enabled and disabled
  void toggleModuleVisibility(String moduleId) {
    final list = List<String>.from(_settings.disabledModuleIds);
    if (list.contains(moduleId)) {
      list.remove(moduleId);
    } else {
      list.add(moduleId);
    }
    _settings = _settings.copyWith(disabledModuleIds: list);
    notifyListeners();
  }

  /// Configure TTS voice speed (0.8x Slow, 1.0x Normal, 1.2x Fast)
  void setTtsSpeechRate(double rate) {
    _settings = _settings.copyWith(ttsSpeechRate: rate);
    notifyListeners();
  }

  /// Toggle sound effects
  void toggleSoundEffects(bool enabled) {
    _settings = _settings.copyWith(soundEffectsEnabled: enabled);
    notifyListeners();
  }

  /// Toggle background music
  void toggleBackgroundMusic(bool enabled) {
    _settings = _settings.copyWith(backgroundMusicEnabled: enabled);
    notifyListeners();
  }

  /// Load Viva Demo Data for academic evaluation
  void loadVivaDemoAnalytics() {
    _settings = _settings.copyWith(
      todayScreenTimeMinutes: 24,
      dailyTimeLimitMinutes: 30,
      weeklyMinutes: {
        'Mon': 25,
        'Tue': 35,
        'Wed': 30,
        'Thu': 45,
        'Fri': 25,
        'Sat': 50,
        'Sun': 40,
      },
      subjectAccuracy: {
        'Animals': 98,
        'Alphabet': 96,
        'Numbers': 92,
        'Colors': 90,
        'Shapes': 68,
      },
    );
    notifyListeners();
  }
}
