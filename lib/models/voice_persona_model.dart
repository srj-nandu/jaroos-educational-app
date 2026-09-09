/// Voice Persona entity representing distinct character narration voices
/// selectable by parents in the JAROOS Parental Dashboard.
class VoicePersona {
  final String id;
  final String name;
  final String role;
  final String emoji;
  final String description;
  final String samplePhrase;
  final double basePitch;
  final double excitedPitch;
  final double calmPitch;
  final double baseRate;
  final int accentColorHex;
  final List<String> voiceKeywords;

  const VoicePersona({
    required this.id,
    required this.name,
    required this.role,
    required this.emoji,
    required this.description,
    required this.samplePhrase,
    this.basePitch = 1.34,
    this.excitedPitch = 1.38,
    this.calmPitch = 1.24,
    this.baseRate = 0.48,
    this.accentColorHex = 0xFFFF6B6B,
    this.voiceKeywords = const [],
  });

  /// 1. Sparky - The default bubbly cartoon child companion
  static const VoicePersona sparky = VoicePersona(
    id: 'sparky_kid',
    name: 'Sparky',
    role: 'Cartoon Kid ⭐',
    emoji: '🧒',
    description: 'Energetic, bubbly cartoon friend with cheerful wow factors and playful praise!',
    samplePhrase: "Yay! I am Sparky! Let's explore and learn together! Woo-hooo! ⭐",
    basePitch: 1.34,
    excitedPitch: 1.38,
    calmPitch: 1.24,
    baseRate: 0.48,
    accentColorHex: 0xFFFF6B6B, // Coral
    voiceKeywords: ['child', 'kid', 'sfg', 'young', 'girl'],
  );

  /// 2. Sweet Lily - Soft, warm, soothing voice for quiet learning & bedtime
  static const VoicePersona lily = VoicePersona(
    id: 'sweet_lily',
    name: 'Sweet Lily',
    role: 'Gentle Storyteller 🌸',
    emoji: '👧',
    description: 'Sweet, soothing, and cozy voice ideal for quiet reading and bedtime stories.',
    samplePhrase: "Hello little star! I am Lily. Settle in for a wonderful, gentle story. ✨",
    basePitch: 1.22,
    excitedPitch: 1.26,
    calmPitch: 1.15,
    baseRate: 0.43,
    accentColorHex: 0xFF9C27B0, // Purple / Lavender
    voiceKeywords: ['eva', 'jenny', 'zira', 'samantha', 'female'],
  );

  /// 3. Leo Explorer - Energetic boy explorer for safari and number quests
  static const VoicePersona leo = VoicePersona(
    id: 'cheerful_leo',
    name: 'Leo Explorer',
    role: 'Adventurous Explorer 🦁',
    emoji: '🦁',
    description: 'Brave, spirited adventurer who loves animal safaris and counting quests!',
    samplePhrase: "Rooaaarr! I am Leo! Ready for an epic learning safari? Let's go! 🚀",
    basePitch: 1.15,
    excitedPitch: 1.20,
    calmPitch: 1.10,
    baseRate: 0.49,
    accentColorHex: 0xFFFF9800, // Orange
    voiceKeywords: ['george', 'boy', 'young', 'natural'],
  );

  /// 4. Teacher Emma - Reassuring classroom teacher
  static const VoicePersona emma = VoicePersona(
    id: 'teacher_emma',
    name: 'Teacher Emma',
    role: 'Classroom Guide 👩‍🏫',
    emoji: '👩‍🏫',
    description: 'Patient, articulate, and encouraging educator for structured phonics.',
    samplePhrase: "Wonderful job! I am Teacher Emma. Let's practice our lessons step by step! 🌟",
    basePitch: 1.05,
    excitedPitch: 1.08,
    calmPitch: 1.00,
    baseRate: 0.45,
    accentColorHex: 0xFF2E7D32, // Forest green
    voiceKeywords: ['natural', 'en-us', 'female', 'neural'],
  );

  /// 5. Robo-Bot - Quirky, futuristic electronic companion
  static const VoicePersona robo = VoicePersona(
    id: 'robo_buddy',
    name: 'Robo-Bot',
    role: 'Playful Robot 🤖',
    emoji: '🤖',
    description: 'Cute sci-fi robotic friend with quirky beep-boop charms!',
    samplePhrase: "Beep-boop! Greetings human explorer! Robo-Bot ready for fun learning missions! ⚡",
    basePitch: 0.92,
    excitedPitch: 0.98,
    calmPitch: 0.88,
    baseRate: 0.46,
    accentColorHex: 0xFF0288D1, // Cyan / Tech Blue
    voiceKeywords: ['en-us', 'network', 'neural'],
  );

  /// 6. Dora Explorer - Iconic cheerful explorer friend with bilingual cheers & backpack quests
  static const VoicePersona dora = VoicePersona(
    id: 'dora_explorer',
    name: 'Dora Explorer',
    role: 'Little Explorer 🎒',
    emoji: '🎒',
    description: 'Iconic, cheerful explorer girl with bilingual cheers, map quests, and "We did it!" celebrations!',
    samplePhrase: "¡Hola! I am Dora! Grab your backpack and let's explore together! ¡Vámonos! 🎒⭐",
    basePitch: 1.33,
    excitedPitch: 1.37,
    calmPitch: 1.22,
    baseRate: 0.48,
    accentColorHex: 0xFFE91E63, // Vibrant Dora Magenta
    voiceKeywords: ['child', 'girl', 'young', 'female', 'sfg', 'es', 'eva', 'natural'],
  );

  /// All available curated voice personas
  static const List<VoicePersona> all = [
    sparky,
    dora,
    lily,
    leo,
    emma,
    robo,
  ];

  /// Find persona by unique ID with safe fallback to Sparky
  static VoicePersona getById(String? id) {
    if (id == null) return sparky;
    return all.firstWhere(
      (p) => p.id == id,
      orElse: () => sparky,
    );
  }
}
