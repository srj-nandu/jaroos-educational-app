import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/localization/app_language.dart';
import '../core/localization/app_translations.dart';
import '../core/services/tts_service.dart';

/// Provider for managing app localization (English, Hindi, Malayalam),
/// persistent language settings, and synchronization with Text-to-Speech voices.
class LanguageProvider with ChangeNotifier {
  static const String _prefKeyLanguage = 'jaroos_selected_language';
  AppLanguage _currentLanguage = AppLanguage.english;

  LanguageProvider() {
    _loadLanguagePreference();
  }

  AppLanguage get currentLanguage => _currentLanguage;
  String get currentLanguageCode => _currentLanguage.code;

  /// Load persisted language choice
  Future<void> _loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefKeyLanguage);
      if (savedCode != null) {
        _currentLanguage = AppLanguage.fromCode(savedCode);
        ModularTtsService.setGlobalLanguageCode(_currentLanguage.code);
        notifyListeners();
      }
    } catch (_) {}
  }

  /// Change active language and synchronize with TTS and storage
  Future<void> setLanguage(AppLanguage language) async {
    if (_currentLanguage == language) return;
    _currentLanguage = language;
    ModularTtsService.setGlobalLanguageCode(language.code);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKeyLanguage, language.code);
    } catch (_) {}
  }

  /// Change active language by language code ('en', 'hi', 'ml')
  Future<void> setLanguageByCode(String code) async {
    final lang = AppLanguage.fromCode(code);
    await setLanguage(lang);
  }

  /// Helper to fetch translated text
  String tr(String key) {
    return AppTranslations.get(key, _currentLanguage.code);
  }
}
