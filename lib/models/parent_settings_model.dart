/// Represents parental control settings, screen time limits,
/// safety configurations, and weekly analytics for JAROOS.
class ParentSettingsModel {
  final String parentPin;
  final bool useMathGate;
  final int dailyTimeLimitMinutes; // 15, 30, 45, 60, 0 for unlimited
  final int todayScreenTimeMinutes;
  final double ttsSpeechRate; // 0.8, 1.0, 1.2
  final bool soundEffectsEnabled;
  final bool backgroundMusicEnabled;
  final List<String> disabledModuleIds;
  final Map<String, int> weeklyMinutes; // 'Mon': 25, 'Tue': 30, etc.
  final Map<String, int> subjectAccuracy; // 'Animals': 98, 'Alphabet': 95, etc.

  const ParentSettingsModel({
    this.parentPin = '1234',
    this.useMathGate = false,
    this.dailyTimeLimitMinutes = 30,
    this.todayScreenTimeMinutes = 18,
    this.ttsSpeechRate = 1.0,
    this.soundEffectsEnabled = true,
    this.backgroundMusicEnabled = true,
    this.disabledModuleIds = const [],
    this.weeklyMinutes = const {
      'Mon': 20,
      'Tue': 35,
      'Wed': 25,
      'Thu': 40,
      'Fri': 30,
      'Sat': 45,
      'Sun': 35,
    },
    this.subjectAccuracy = const {
      'Animals': 98,
      'Alphabet': 95,
      'Numbers': 88,
      'Colors': 92,
      'Shapes': 65,
    },
  });

  ParentSettingsModel copyWith({
    String? parentPin,
    bool? useMathGate,
    int? dailyTimeLimitMinutes,
    int? todayScreenTimeMinutes,
    double? ttsSpeechRate,
    bool? soundEffectsEnabled,
    bool? backgroundMusicEnabled,
    List<String>? disabledModuleIds,
    Map<String, int>? weeklyMinutes,
    Map<String, int>? subjectAccuracy,
  }) {
    return ParentSettingsModel(
      parentPin: parentPin ?? this.parentPin,
      useMathGate: useMathGate ?? this.useMathGate,
      dailyTimeLimitMinutes: dailyTimeLimitMinutes ?? this.dailyTimeLimitMinutes,
      todayScreenTimeMinutes: todayScreenTimeMinutes ?? this.todayScreenTimeMinutes,
      ttsSpeechRate: ttsSpeechRate ?? this.ttsSpeechRate,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      backgroundMusicEnabled: backgroundMusicEnabled ?? this.backgroundMusicEnabled,
      disabledModuleIds: disabledModuleIds ?? this.disabledModuleIds,
      weeklyMinutes: weeklyMinutes ?? this.weeklyMinutes,
      subjectAccuracy: subjectAccuracy ?? this.subjectAccuracy,
    );
  }

  int get totalWeeklyMinutes =>
      weeklyMinutes.values.fold(0, (sum, minutes) => sum + minutes);

  double get averageWeeklyHours => totalWeeklyMinutes / 60.0;
}
