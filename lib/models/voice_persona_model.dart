/// Voice Persona entity representing distinct character narration voices
/// selectable by parents in the JAROOS Parental Dashboard across English, Hindi, and Malayalam.
class VoicePersona {
  final String id;
  final String name;
  final String role;
  final String emoji;
  final String description;
  final String samplePhrase;
  final String languageCode; // 'en', 'hi', 'ml'
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
    this.languageCode = 'en',
    this.basePitch = 1.34,
    this.excitedPitch = 1.38,
    this.calmPitch = 1.24,
    this.baseRate = 0.48,
    this.accentColorHex = 0xFFFF6B6B,
    this.voiceKeywords = const [],
  });

  // ==========================================
  // ENGLISH VOICES (en)
  // ==========================================

  /// 1. Sparky - The default bubbly cartoon child companion
  static const VoicePersona sparky = VoicePersona(
    id: 'sparky_kid',
    name: 'Sparky',
    role: 'Cartoon Kid ⭐',
    emoji: '🧒',
    languageCode: 'en',
    description: 'Energetic, bubbly cartoon friend with cheerful wow factors and playful praise!',
    samplePhrase: "Yay! I am Sparky! Let's explore and learn together! Woo-hooo! ⭐",
    basePitch: 1.34,
    excitedPitch: 1.38,
    calmPitch: 1.24,
    baseRate: 0.48,
    accentColorHex: 0xFFFF6B6B, // Coral
    voiceKeywords: ['child', 'kid', 'sfg', 'young', 'girl'],
  );

  /// 2. Dora Explorer - Iconic cheerful explorer friend with bilingual cheers & backpack quests
  static const VoicePersona dora = VoicePersona(
    id: 'dora_explorer',
    name: 'Dora Explorer',
    role: 'Little Explorer 🎒',
    emoji: '🎒',
    languageCode: 'en',
    description: 'Iconic, cheerful explorer girl with bilingual cheers, map quests, and "We did it!" celebrations!',
    samplePhrase: "¡Hola! I am Dora! Grab your backpack and let's explore together! ¡Vámonos! 🎒⭐",
    basePitch: 1.33,
    excitedPitch: 1.37,
    calmPitch: 1.22,
    baseRate: 0.48,
    accentColorHex: 0xFFE91E63, // Vibrant Dora Magenta
    voiceKeywords: ['child', 'girl', 'young', 'female', 'sfg', 'es', 'eva', 'natural'],
  );

  /// 3. Sweet Lily - Soft, warm, soothing voice for quiet learning & bedtime
  static const VoicePersona lily = VoicePersona(
    id: 'sweet_lily',
    name: 'Sweet Lily',
    role: 'Gentle Storyteller 🌸',
    emoji: '👧',
    languageCode: 'en',
    description: 'Sweet, soothing, and cozy voice ideal for quiet reading and bedtime stories.',
    samplePhrase: "Hello little star! I am Lily. Settle in for a wonderful, gentle story. ✨",
    basePitch: 1.22,
    excitedPitch: 1.26,
    calmPitch: 1.15,
    baseRate: 0.43,
    accentColorHex: 0xFF9C27B0, // Purple / Lavender
    voiceKeywords: ['eva', 'jenny', 'zira', 'samantha', 'female'],
  );

  /// 4. Leo Explorer - Energetic boy explorer for safari and number quests
  static const VoicePersona leo = VoicePersona(
    id: 'cheerful_leo',
    name: 'Leo Explorer',
    role: 'Adventurous Explorer 🦁',
    emoji: '🦁',
    languageCode: 'en',
    description: 'Brave, spirited adventurer who loves animal safaris and counting quests!',
    samplePhrase: "Rooaaarr! I am Leo! Ready for an epic learning safari? Let's go! 🚀",
    basePitch: 1.15,
    excitedPitch: 1.20,
    calmPitch: 1.10,
    baseRate: 0.49,
    accentColorHex: 0xFFFF9800, // Orange
    voiceKeywords: ['george', 'boy', 'young', 'natural'],
  );

  /// 5. Teacher Emma - Reassuring classroom teacher
  static const VoicePersona emma = VoicePersona(
    id: 'teacher_emma',
    name: 'Teacher Emma',
    role: 'Classroom Guide 👩‍🏫',
    emoji: '👩‍🏫',
    languageCode: 'en',
    description: 'Patient, articulate, and encouraging educator for structured phonics.',
    samplePhrase: "Wonderful job! I am Teacher Emma. Let's practice our lessons step by step! 🌟",
    basePitch: 1.05,
    excitedPitch: 1.08,
    calmPitch: 1.00,
    baseRate: 0.45,
    accentColorHex: 0xFF2E7D32, // Forest green
    voiceKeywords: ['natural', 'en-us', 'female', 'neural'],
  );

  /// 6. Robo-Bot - Quirky, futuristic electronic companion
  static const VoicePersona robo = VoicePersona(
    id: 'robo_buddy',
    name: 'Robo-Bot',
    role: 'Playful Robot 🤖',
    emoji: '🤖',
    languageCode: 'en',
    description: 'Cute sci-fi robotic friend with quirky beep-boop charms!',
    samplePhrase: "Beep-boop! Greetings human explorer! Robo-Bot ready for fun learning missions! ⚡",
    basePitch: 0.92,
    excitedPitch: 0.98,
    calmPitch: 0.88,
    baseRate: 0.46,
    accentColorHex: 0xFF0288D1, // Cyan / Tech Blue
    voiceKeywords: ['en-us', 'network', 'neural'],
  );

  // ==========================================
  // HINDI VOICES (hi)
  // ==========================================

  /// 7. Aarav - Bubbly Hindi cartoon kid companion
  static const VoicePersona aarav = VoicePersona(
    id: 'aarav_kid',
    name: 'Aarav (आरव)',
    role: 'Cartoon Kid ⭐',
    emoji: '🧒',
    languageCode: 'hi',
    description: 'उत्साही और मज़ेदार बाल सखा! खेल-खेल में खुशी से सिखाता है!',
    samplePhrase: "नमस्ते! मैं आरव हूँ! चलो साथ में मज़े से सीखते हैं! शाबाश! ⭐",
    basePitch: 1.34,
    excitedPitch: 1.38,
    calmPitch: 1.24,
    baseRate: 0.48,
    accentColorHex: 0xFFFF5722, // Deep Orange
    voiceKeywords: ['hi', 'hindi', 'india', 'child', 'female', 'natural', 'google'],
  );

  /// 8. Pari - Gentle Hindi storyteller
  static const VoicePersona pari = VoicePersona(
    id: 'pari_story',
    name: 'Pari (परी)',
    role: 'Sweet Storyteller 🌸',
    emoji: '🧚',
    languageCode: 'hi',
    description: 'मीठी और शांत आवाज़, सोने से पहले सुंदर जादुई कहानियों के लिए!',
    samplePhrase: "नमस्ते प्यारे बच्चे! मैं परी हूँ। आओ एक सुंदर जादुई कहानी सुनें! ✨",
    basePitch: 1.22,
    excitedPitch: 1.26,
    calmPitch: 1.15,
    baseRate: 0.43,
    accentColorHex: 0xFF8E24AA, // Purple
    voiceKeywords: ['hi', 'hindi', 'female', 'woman', 'natural', 'eva'],
  );

  /// 9. Kabir - Brave Hindi boy explorer
  static const VoicePersona kabir = VoicePersona(
    id: 'kabir_explorer',
    name: 'Kabir (कबीर)',
    role: 'Safari Explorer 🦁',
    emoji: '🦁',
    languageCode: 'hi',
    description: 'साहसी खोजक दोस्त, जो जंगली जानवरों और गिनती के रोमांचक सफर पर ले जाता है!',
    samplePhrase: "दहाड़ो! मैं कबीर हूँ! क्या आप जंगल सफारी के लिए तैयार हैं? चलो चलें! 🚀",
    basePitch: 1.15,
    excitedPitch: 1.20,
    calmPitch: 1.10,
    baseRate: 0.49,
    accentColorHex: 0xFFFFB300, // Amber
    voiceKeywords: ['hi', 'hindi', 'male', 'young', 'natural'],
  );

  // ==========================================
  // MALAYALAM VOICES (ml)
  // ==========================================

  /// 10. Unni - Cheerful Malayalam cartoon child
  static const VoicePersona unni = VoicePersona(
    id: 'unni_kid',
    name: 'Unni (ഉണ്ണി)',
    role: 'Playful Kid ⭐',
    emoji: '👦',
    languageCode: 'ml',
    description: 'കുസൃതിയും ഉന്മേഷവുമുള്ള കുട്ടിക്കൂട്ടുകാരൻ! ചിരിച്ചുകളിച്ച് പഠിക്കാം!',
    samplePhrase: "നമസ്കാരം! ഞാൻ ഉണ്ണിയാണ്! നമുക്ക് രസകരമായി ഒരുമിച്ച് പഠിക്കാം! അടിപൊളി! ⭐",
    basePitch: 1.34,
    excitedPitch: 1.38,
    calmPitch: 1.24,
    baseRate: 0.48,
    accentColorHex: 0xFF4CAF50, // Fresh Green
    voiceKeywords: ['ml', 'malayalam', 'india', 'child', 'female', 'natural'],
  );

  /// 11. Meenu - Sweet Malayalam bedtime storyteller
  static const VoicePersona meenu = VoicePersona(
    id: 'meenu_story',
    name: 'Meenu (മീനു)',
    role: 'Gentle Storyteller 🌸',
    emoji: '👧',
    languageCode: 'ml',
    description: 'മധുരമായ ശബ്ദമുള്ള കഥാകാരി! ഉറങ്ങാൻ നേരം നല്ല ഗുണപാഠ കഥകൾ കേൾക്കാം!',
    samplePhrase: "ഹലോ കൂട്ടുകാരേ! ഞാൻ മീനു. കേൾക്കാം ഒരു നല്ല കഥ! സന്തോഷം! ✨",
    basePitch: 1.22,
    excitedPitch: 1.26,
    calmPitch: 1.15,
    baseRate: 0.43,
    accentColorHex: 0xFF3F51B5, // Indigo
    voiceKeywords: ['ml', 'malayalam', 'female', 'natural'],
  );

  /// 12. Appu - Brave Malayalam explorer companion
  static const VoicePersona appu = VoicePersona(
    id: 'appu_explorer',
    name: 'Appu (അപ്പു)',
    role: 'Little Explorer 🐘',
    emoji: '🐘',
    languageCode: 'ml',
    description: 'ധീരനായ കുട്ടി പര്യവേക്ഷകൻ! കാടും മേടും ചുറ്റിക്കാണാൻ കൂടെയുണ്ട്!',
    samplePhrase: "ഹേയ് കൂട്ടുകാരേ! ഞാൻ അപ്പു! നമുക്ക് ഒരു വലിയ സാഹസിക യാത്രക്ക് പോകാം! 🚀",
    basePitch: 1.16,
    excitedPitch: 1.21,
    calmPitch: 1.10,
    baseRate: 0.49,
    accentColorHex: 0xFF009688, // Teal
    voiceKeywords: ['ml', 'malayalam', 'young', 'natural'],
  );

  /// Curated list of English companion voices
  static const List<VoicePersona> englishVoices = [
    sparky,
    dora,
    lily,
    leo,
    emma,
    robo,
  ];

  /// Curated list of Malayalam companion voice models
  static const List<VoicePersona> malayalamVoices = [
    unni,
    meenu,
    appu,
  ];

  /// All available active voice personas for the app (6 English + 3 Malayalam)
  static const List<VoicePersona> activePersonas = [
    ...englishVoices,
    ...malayalamVoices,
  ];

  /// All available curated voice personas
  static const List<VoicePersona> all = [
    sparky,
    dora,
    lily,
    leo,
    emma,
    robo,
    aarav,
    pari,
    kabir,
    unni,
    meenu,
    appu,
  ];

  /// Filter personas by language code ('en', 'hi', 'ml')
  static List<VoicePersona> getByLanguage(String langCode) {
    final list = all.where((p) => p.languageCode == langCode).toList();
    if (list.isNotEmpty) return list;
    return all.where((p) => p.languageCode == 'en').toList();
  }

  /// Default persona for each language
  static VoicePersona getDefaultForLanguage(String langCode) {
    switch (langCode.toLowerCase()) {
      case 'hi':
        return aarav;
      case 'ml':
        return unni;
      default:
        return sparky;
    }
  }

  /// Find persona by unique ID with safe fallback
  static VoicePersona getById(String? id) {
    if (id == null) return sparky;
    return all.firstWhere(
      (p) => p.id == id,
      orElse: () => sparky,
    );
  }
}
