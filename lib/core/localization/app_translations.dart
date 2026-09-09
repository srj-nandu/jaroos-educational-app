/// Centralized multilingual string dictionary for English, Hindi, and Malayalam
class AppTranslations {
  static const Map<String, Map<String, String>> _strings = {
    // Navigation
    'nav_home': {
      'en': 'Home',
      'hi': 'होम',
      'ml': 'ഹോം',
    },
    'nav_learn': {
      'en': 'Learn',
      'hi': 'सीखें',
      'ml': 'പഠനം',
    },
    'nav_courses': {
      'en': 'Courses',
      'hi': 'कोर्स',
      'ml': 'പാഠങ്ങൾ',
    },
    'nav_practice': {
      'en': 'Practice',
      'hi': 'अभ्यास',
      'ml': 'പരിശീലനം',
    },
    'nav_progress': {
      'en': 'Progress',
      'hi': 'प्रगति',
      'ml': 'പുരോഗതി',
    },
    'nav_profile': {
      'en': 'Profile',
      'hi': 'प्रोफ़ाइल',
      'ml': 'പ്രൊഫൈൽ',
    },

    // Home Header & Greetings
    'greeting_hello': {
      'en': 'Hello',
      'hi': 'नमस्ते',
      'ml': 'ഹലോ',
    },
    'home_subtitle': {
      'en': "What would you like to explore today?",
      'hi': 'आज आप क्या नया सीखना चाहेंगे?',
      'ml': 'ഇന്ന് എന്താണ് പുതിയതായി പഠിക്കേണ്ടത്?',
    },
    'streak_days': {
      'en': 'Day Streak',
      'hi': 'दिन की लकीर',
      'ml': 'ദിവസത്തെ സ്ട്രീക്ക്',
    },
    'daily_quest': {
      'en': 'Daily Quest',
      'hi': 'दैनिक खोज',
      'ml': 'ദിവസേനയുള്ള ലക്ഷ്യം',
    },

    // Learning Modules
    'module_alphabet': {
      'en': 'Everyday Alphabet',
      'hi': 'वर्णमाला (Alphabet)',
      'ml': 'അക്ഷരമാല (Alphabet)',
    },
    'module_alphabet_sub': {
      'en': 'Learn A to Z with phonics & fun sounds',
      'hi': 'चित्रों और ध्वनियों के साथ A से Z सीखें',
      'ml': 'ചിത്രങ്ങളും ശബ്ദങ്ങളുമായി A to Z പഠിക്കാം',
    },
    'module_numbers': {
      'en': 'Counting Numbers',
      'hi': 'संख्याएं और गिनती',
      'ml': 'സംഖ്യകളും എണ്ണലും',
    },
    'module_numbers_sub': {
      'en': 'Count 1 to 20 with interactive stars',
      'hi': 'मज़ेदार सितारों के साथ 1 से 20 तक गिनें',
      'ml': 'നക്ഷത്രങ്ങൾ എണ്ണി 1 മുതൽ 20 വരെ പഠിക്കാം',
    },
    'module_colors': {
      'en': 'Magic Colors',
      'hi': 'जादुई रंग',
      'ml': 'മാന്ത്രിക നിറങ്ങൾ',
    },
    'module_colors_sub': {
      'en': 'Discover bright rainbow shades',
      'hi': 'इंद्रधनुष के सुंदर रंगों को पहचानें',
      'ml': 'മഴവില്ലിൻ്റെ മനോഹരമായ നിറങ്ങൾ കണ്ടെത്താം',
    },
    'module_shapes': {
      'en': 'Shape Detective',
      'hi': 'आकार खोजक',
      'ml': 'രൂപങ്ങൾ കണ്ടെത്താം',
    },
    'module_shapes_sub': {
      'en': 'Spot circles, triangles & rectangles',
      'hi': 'गोल, चौकोर और तिकोने आकार पहचानें',
      'ml': 'വൃത്തവും ത്രികോണവും ചതുരവും തിരിച്ചറിയാം',
    },
    'module_animals': {
      'en': 'Animal Safari',
      'hi': 'पशु सफारी',
      'ml': 'മൃഗങ്ങളുടെ ലോകം',
    },
    'module_animals_sub': {
      'en': 'Wild & farm friends with real sounds',
      'hi': 'जंगली और पालतू जानवरों की आवाज़ें सुनें',
      'ml': 'കാട്ടിലെയും നാട്ടിലെയും മൃഗങ്ങളെ അറിയാം',
    },
    'module_fruits': {
      'en': 'Yummy Fruits',
      'hi': 'स्वादिष्ट फल व सब्जियां',
      'ml': 'രുചികരമായ പഴങ്ങൾ',
    },
    'module_fruits_sub': {
      'en': 'Crispy fruits & healthy vegetables',
      'hi': 'ताज़े और पौष्टिक फल तथा सब्जियां',
      'ml': 'ആരോഗ്യപ്രദമായ പഴങ്ങളും പച്ചക്കറികളും',
    },
    'module_stories': {
      'en': 'Bedtime Stories',
      'hi': 'सुंदर कहानियां',
      'ml': 'കുട്ടിക്കഥകൾ',
    },
    'module_stories_sub': {
      'en': 'Sweet moral tales read aloud with love',
      'hi': 'नैतिक शिक्षा वाली प्यारी कहानियां',
      'ml': 'ഗുണപാഠമുള്ള മനോഹരമായ കഥകൾ കേൾക്കാം',
    },
    'module_rhymes': {
      'en': 'Fun Rhymes',
      'hi': 'मनोरंजक बालगीत',
      'ml': 'കുട്ടിപ്പാട്ടുകൾ',
    },
    'module_rhymes_sub': {
      'en': 'Musical sing-along songs with rhymes',
      'hi': 'संगीत और ताल के साथ प्यारे बालगीत गाएं',
      'ml': 'താളത്തിൽ പാടി രസിക്കാൻ കുട്ടിപ്പാട്ടുകൾ',
    },
    'module_quiz': {
      'en': 'Quiz Arena',
      'hi': 'क्विज़ अखाड़ा',
      'ml': 'ക്വിസ് അരീന',
    },
    'module_quiz_sub': {
      'en': 'Test your knowledge & win shiny stars',
      'hi': 'अपने ज्ञान को परखें और सितारे जीतें',
      'ml': 'ചോദ്യങ്ങൾക്ക് ഉത്തരം നൽകി താരങ്ങൾ നേടാം',
    },

    // Parental Dashboard
    'parent_dashboard_title': {
      'en': 'Parent Dashboard 👨‍👩‍👧',
      'hi': 'पेरेंट डैशबोर्ड 👨‍👩‍👧',
      'ml': 'രക്ഷിതാക്കളുടെ ഡാഷ്‌ബോർഡ് 👨‍👩‍👧',
    },
    'language_section_title': {
      'en': 'App Language & Locale 🌐',
      'hi': 'ऐप की भाषा और क्षेत्र 🌐',
      'ml': 'ആപ്പ് ഭാഷയും പ്രദേശവും 🌐',
    },
    'language_section_subtitle': {
      'en': 'Choose between English, Hindi, and Malayalam for learning & narration.',
      'hi': 'पढ़ने और आवाज़ के लिए अंग्रेज़ी, हिन्दी या मलयालम चुनें।',
      'ml': 'പഠനത്തിനും ശബ്ദത്തിനും ഇംഗ്ലീഷ്, ഹിന്ദി, മലയാളം തിരഞ്ഞെടുക്കാം.',
    },
    'voice_preferences_title': {
      'en': 'Voice & Audio Preferences 🔊',
      'hi': 'आवाज़ और ऑडियो प्राथमिकताएँ 🔊',
      'ml': 'ശബ്ദവും ഓഡിയോ മുൻഗണനകളും 🔊',
    },
    'voice_preferences_subtitle': {
      'en': 'Choose your child\'s favorite character voice. Tap any voice to switch, or tap Preview to listen.',
      'hi': 'अपने बच्चे का पसंदीदा पात्र चुनें। बदलने के लिए टैप करें या सुनने के लिए पूर्वावलोकन पर टैप करें।',
      'ml': 'കുട്ടിയുടെ പ്രിയപ്പെട്ട കഥാപാത്രത്തെ തിരഞ്ഞെടുക്കൂ. പ്രിവ്യൂ ടാപ്പ് ചെയ്ത് ശബ്ദം കേട്ടുനോക്കാം.',
    },
    'character_voices': {
      'en': 'Character Narration Voices:',
      'hi': 'पात्रों की आवाज़ें:',
      'ml': 'കഥാപാത്രങ്ങളുടെ ശബ്ദങ്ങൾ:',
    },
    'preview_btn': {
      'en': 'Preview',
      'hi': 'सुनें',
      'ml': 'കേൾക്കാം',
    },
    'active_companion': {
      'en': 'Active Companion',
      'hi': 'सक्रिय साथी',
      'ml': 'സജീവ കഥാപാത്രം',
    },
    'screen_time_title': {
      'en': 'Daily Screen Time ⏳',
      'hi': 'दैनिक स्क्रीन समय ⏳',
      'ml': 'ദിവസേനയുള്ള സ്ക്രീൻ സമയം ⏳',
    },
    'weekly_activity_title': {
      'en': 'Weekly Activity 📊',
      'hi': 'साप्ताहिक गतिविधि 📊',
      'ml': 'പ്രതിവാര പ്രവർത്തനം 📊',
    },
    'subject_mastery_title': {
      'en': 'Subject Performance & Focus 🎯',
      'hi': 'विषय प्रदर्शन और ध्यान 🎯',
      'ml': 'വിഷയങ്ങളുടെ പ്രകടനം 🎯',
    },
    'curriculum_controls_title': {
      'en': 'Module Curriculum Controls 📚',
      'hi': 'पाठ्यक्रम नियंत्रण 📚',
      'ml': 'പാഠ്യപദ്ധതി നിയന്ത്രണങ്ങൾ 📚',
    },
    'security_settings_title': {
      'en': 'Security & Safety Settings 🔐',
      'hi': 'सुरक्षा सेटिंग्स 🔐',
      'ml': 'സുരക്ഷാ ക്രമീകരണങ്ങൾ 🔐',
    },

    // Praise & Celebrations
    'praise_correct': {
      'en': 'Awesome! That is correct! ⭐',
      'hi': 'अरे वाह! बिल्कुल सही! शाबाश! ⭐',
      'ml': 'അടിപൊളി! ശരിയുത്തരം! മിടുക്കൻ! ⭐',
    },
    'praise_try_again': {
      'en': 'Not quite! Let\'s try together! 🎈',
      'hi': 'कोई बात नहीं! चलो फिर से प्रयास करते हैं! 🎈',
      'ml': 'സാരമില്ല! നമുക്ക് ഒന്നുകൂടി നോക്കാം! 🎈',
    },
    'praise_quiz_completed': {
      'en': 'Quiz completed! You\'re a superstar! 🏆✨',
      'hi': 'क्विज़ पूरा हुआ! आप एक सुपरस्टार हैं! 🏆✨',
      'ml': 'ക്വിസ് കഴിഞ്ഞു! നിങ്ങൾ ഒരു സൂപ്പർസ്റ്റാറാണ്! 🏆✨',
    },
  };

  /// Fetch translation string by key with language code fallback
  static String get(String key, String langCode) {
    final entry = _strings[key];
    if (entry == null) return key;
    return entry[langCode] ?? entry['en'] ?? key;
  }
}
