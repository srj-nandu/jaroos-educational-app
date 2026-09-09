/// Supported languages in JAROOS
enum AppLanguage {
  english(
    code: 'en',
    name: 'English',
    nativeName: 'English',
    flag: '🇬🇧',
    ttsLocale: 'en-US',
  ),
  hindi(
    code: 'hi',
    name: 'Hindi',
    nativeName: 'हिन्दी',
    flag: '🇮🇳',
    ttsLocale: 'hi-IN',
  ),
  malayalam(
    code: 'ml',
    name: 'Malayalam',
    nativeName: 'മലയാളം',
    flag: '🌴',
    ttsLocale: 'ml-IN',
  );

  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final String ttsLocale;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.ttsLocale,
  });

  String get nativeLabel => nativeName;
  String get englishLabel => name;
  String get flagEmoji => flag;

  static AppLanguage fromCode(String? code) {
    if (code == null) return AppLanguage.english;
    return AppLanguage.values.firstWhere(
      (lang) => lang.code.toLowerCase() == code.toLowerCase(),
      orElse: () => AppLanguage.english,
    );
  }
}
