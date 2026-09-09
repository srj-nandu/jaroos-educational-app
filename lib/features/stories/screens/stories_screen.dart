import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';

class StoryItem {
  final String title;
  final String emoji;
  final String duration;
  final String moral;
  final String summary;
  final List<String> paragraphs;
  final Color themeColor;
  final String language; // 'en' or 'ml'

  const StoryItem({
    required this.title,
    required this.emoji,
    required this.duration,
    required this.moral,
    required this.summary,
    required this.paragraphs,
    required this.themeColor,
    this.language = 'en',
  });
}

/// Interactive Bedtime & Moral Stories Module for JAROOS.
/// Features classic children's moral tales with interactive "Read to Me" TTS narration.
class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  String _selectedFilter = 'all'; // 'all', 'ml', 'en'

  static const List<StoryItem> _storiesList = [
    // ==========================================
    // 🌴 MALAYALAM BEDTIME & MORAL STORIES (ml)
    // ==========================================
    StoryItem(
      title: 'ആമയും മുയലും',
      emoji: '🐢',
      duration: '3 min read',
      moral: 'സ്ഥിരോത്സാഹവും ക്ഷമയുമുണ്ടെങ്കിൽ വിജയം തീർച്ച!',
      summary: 'വേഗത്തിൽ ഓടുന്ന മുയലും പതുക്കെ നടക്കുന്ന ആമയും തമ്മിലുള്ള രസകരമായ ഓട്ടപ്പന്തയം.',
      language: 'ml',
      themeColor: Color(0xFF2E7D32),
      paragraphs: [
        'പണ്ട് പണ്ടൊരു പച്ചപ്പുല്ല് നിറഞ്ഞ വലിയ കാട്ടിൽ അഹങ്കാരിയായ ഒരു മുയൽ ഉണ്ടായിരുന്നു. തനിക്ക് വേഗത്തിൽ ഓടാൻ കഴിയുമെന്ന് അവൻ എപ്പോഴും കാട്ടിലെ മൃഗങ്ങളോട് വീമ്പു പറയുമായിരുന്നു.',
        'മുയലിന്റെ വീരവാദം കേട്ട് മടുത്ത ശാന്തനായ ഒരു ആമ അവനെ ഒരു സൗഹൃദ ഓട്ടപ്പന്തയത്തിന് ക്ഷണിച്ചു. "നീ എന്നെ ഓടി തോൽപ്പിക്കുമോ?" എന്ന് ചോദിച്ച് മുയൽ ഉറക്കെ ചിരിച്ചു.',
        'പന്തയം തുടങ്ങി! മുയൽ മിന്നൽ വേഗത്തിൽ മുന്നോട്ട് കുതിച്ചു. പാതിവഴി എത്തിയപ്പോൾ പിന്നിലേക്ക് നോക്കിയ മുയൽ ആമയെ കണ്ടതേയില്ല.',
        '"ആമ പതുക്കെയല്ലേ വരുന്നുള്ളൂ, ഞാൻ ഒരു മരത്തണലിൽ കുറച്ചു നേരം വിശ്രമിക്കാം" എന്ന് കരുതി മുയൽ സുഖമായി ഉറങ്ങിപ്പോയി.',
        'എന്നാൽ ആമ ഒട്ടും നിർത്താതെ, പതുക്കെയാണെങ്കിലും തന്റെ ലക്ഷ്യത്തിലേക്ക് നടന്നു കൊണ്ടേയിരുന്നു.',
        'മുയൽ ഉണർന്നു നോക്കുമ്പോൾ ആമ വിജയരേഖ കടക്കുന്നതാണ് കണ്ടത്! കാട്ടിലെ മൃഗങ്ങളെല്ലാം ആമയെ സന്തോഷത്തോടെ കൈയടിച്ച് അഭിനന്ദിച്ചു. സ്ഥിരോത്സാഹവും കഠിനാധ്വാനവും കൊണ്ടേ വിജയം കൈവരിക്കാൻ കഴിയൂ എന്ന് മുയൽ മനസ്സിലാക്കി.',
      ],
    ),
    StoryItem(
      title: 'ബുദ്ധിമാനായ കാക്ക',
      emoji: '🦅',
      duration: '2 min read',
      moral: 'ബുദ്ധിയുണ്ടെങ്കിൽ ഏത് വിഷമഘട്ടവും തരണം ചെയ്യാം!',
      summary: 'ദാഹിച്ചുവലഞ്ഞ കാക്ക കല്ലുകൾ പെറുക്കിയിട്ട് കുടത്തിലെ വെള്ളം കുടിക്കുന്ന കൗതുകക്കഥ.',
      language: 'ml',
      themeColor: Color(0xFF1976D2),
      paragraphs: [
        'കടുത്ത വേനൽക്കാലത്ത് കഠിനമായ ദാഹം കാരണം വലഞ്ഞ ഒരു കാക്ക വെള്ളം തേടി കാടും നാടും അലഞ്ഞു പറന്നു.',
        'ഒടുവിൽ ഒരു വീടിന്റെ മുറ്റത്ത് ഒരു മൺകുടം ഇരിക്കുന്നത് കാക്ക കണ്ടു. അവൻ അതിയായ സന്തോഷത്തോടെ കുടത്തിന്റെ വക്കിലിരുന്നു.',
        'പക്ഷേ കുടത്തിന്റെ അടിയിൽ വളരെ കുറച്ചു വെള്ളമേ ഉണ്ടായിരുന്നുള്ളൂ. കാക്കയുടെ കൊക്ക് വെള്ളത്തിലേക്ക് എത്തിയില്ല.',
        'നിരാശപ്പെടാതെ അവൻ ചുറ്റും നോക്കി. മുറ്റത്ത് ചെറിയ ചരൽക്കല്ലുകൾ കിടക്കുന്നത് അവന്റെ ശ്രദ്ധയിൽപ്പെട്ടു.',
        'കാക്ക ഓരോ കല്ലുകളായി കൊക്കിലെടുത്ത് കുടത്തിലേക്ക് ഇട്ടു. കല്ലുകൾ വീണതോടെ കുടത്തിലെ വെള്ളം സാവധാനം ഉയർന്നു വന്നു!',
        'വെള്ളം കുടത്തിന്റെ വക്കോളം എത്തിയപ്പോൾ കാക്ക വയറുനിറയെ വെള്ളം കുടിച്ച് ദാഹം തീർത്തു. ബുദ്ധിയും ക്ഷമയുമുണ്ടെങ്കിൽ ഏത് പ്രതിസന്ധിയും നേരിടാം എന്ന് കാക്ക നമ്മെ പഠിപ്പിക്കുന്നു.',
      ],
    ),
    StoryItem(
      title: 'സിംഹവും കൊച്ചു എലിയും',
      emoji: '🦁',
      duration: '3 min read',
      moral: 'ഒരു ജീവിയെയും നിസ്സാരനായി കാണരുത്; സ്നേഹവും ഉപകാരവും എന്നും തിരികെ ലഭിക്കും!',
      summary: 'മൃഗരാജനായ സിംഹത്തെ വേട്ടക്കാരന്റെ വലയിൽ നിന്നും രക്ഷിക്കുന്ന കുഞ്ഞൻ എലിയുടെ കഥ.',
      language: 'ml',
      themeColor: Color(0xFFE65100),
      paragraphs: [
        'ഒരു കാട്ടിൽ ശക്തിമാനായ ഒരു സിംഹം ഗുഹയ്ക്ക് മുന്നിൽ സുഖമായി ഉറങ്ങുകയായിരുന്നു. അപ്പോൾ അബദ്ധത്തിൽ ഒരു ചെറിയ എലി സിംഹത്തിന്റെ മൂക്കിൻ തുമ്പിലൂടെ ഓടിക്കയറി.',
        'ഉറക്കമുണർന്ന സിംഹം ദേഷ്യത്തോടെ തന്റെ വലിയ കൈപ്പത്തി കൊണ്ട് എലിയെ പിടികൂടി: "എന്റെ ഉറക്കം കളഞ്ഞ നിന്നെ ഞാൻ കൊല്ലും!"',
        'ഭയന്നുവിറച്ച എലി കൈകൂപ്പി പറഞ്ഞു: "പ്രഭോ, എന്നോട് ക്ഷമിക്കണം! ജീവൻ രക്ഷിച്ചാൽ എന്നെങ്കിലും ഞാൻ അങ്ങയെ സഹായിക്കാം!" കൊച്ചു എലി തന്നെ സഹായിക്കുമെന്ന് കേട്ട് സിംഹം ചിരിച്ചു, എങ്കിലും ദയ തോന്നി അവനെ വിട്ടയച്ചു.',
        'കുറച്ചു ദിവസങ്ങൾക്ക് ശേഷം സിംഹം വേട്ടക്കാരുടെ ശക്തമായ കയർവലയിൽ കുടുങ്ങിപ്പോയി. രക്ഷപ്പെടാൻ കഴിയാതെ സിംഹം ഉച്ചത്തിൽ അലറി.',
        'സിംഹത്തിന്റെ അലർച്ച കേട്ട എലി ഉടൻ തന്നെ ഓടിയെത്തി. തന്റെ മൂർച്ചയുള്ള കൊച്ചു പല്ലുകൾ കൊണ്ട് വലയിലെ കയറുകൾ ഓരോന്നായി കടിച്ചുമുറിച്ചു!',
        'സിംഹം പൂർണ്ണമായി സ്വതന്ത്രനായി! സന്തോഷത്തോടെ സിംഹം പറഞ്ഞു: "നന്ദി കൂട്ടുകാരാ, ചെറിയവർക്കും വലിയ കാര്യങ്ങൾ ചെയ്യാൻ കഴിയുമെന്ന് നീ ഇന്ന് എന്നെ പഠിപ്പിച്ചു!"',
      ],
    ),
    StoryItem(
      title: 'ആനയും തയ്യൽക്കാരനും',
      emoji: '🐘',
      duration: '3 min read',
      moral: 'ആരെയും നോവിക്കരുത്; മറ്റുള്ളവരോട് എപ്പോഴും സ്നേഹത്തോടെ പെരുമാറുക!',
      summary: 'ക്ഷേത്രത്തിലെ ആനയും തയ്യൽക്കാരനും തമ്മിലുള്ള അസാധാരണ സൗഹൃദവും വലിയ ഗുണപാഠവും.',
      language: 'ml',
      themeColor: Color(0xFF00897B),
      paragraphs: [
        'കേരളത്തിലെ ഒരു സുന്ദരമായ ഗ്രാമത്തിൽ ഒരു അമ്പലപ്പുഴ ആനയുണ്ടായിരുന്നു. ദിവസവും പുഴയിൽ കുളിക്കാൻ പോകുമ്പോൾ ആന വഴിയിലുള്ള തയ്യൽക്കടയിൽ എത്തുമായിരുന്നു.',
        'തയ്യൽക്കാരൻ ആനയ്ക്ക് ദിവസവും പഴങ്ങളും കരിമ്പും കൊടുക്കുമായിരുന്നു. അവർ തമ്മിൽ നല്ല സൗഹൃദത്തിലായി.',
        'ഒരു ദിവസം തയ്യൽക്കാരന് എന്തോ വലിയ ദേഷ്യമുണ്ടായിരുന്നു. തുമ്പിക്കൈ നീട്ടിയ ആനയ്ക്ക് പഴം കൊടുക്കുന്നതിന് പകരം തയ്യൽക്കാരൻ ഒരു സൂചികൊണ്ട് ആനയുടെ തുമ്പിക്കൈയിൽ കുത്തി!',
        'വേദന സഹിച്ച ആന ഒന്നും ചെയ്യാതെ ശാന്തനായി പുഴയിലേക്ക് നടന്നുപോയി.',
        'കുളി കഴിഞ്ഞ് തിരികെ വരുമ്പോൾ ആന തന്റെ തുമ്പിക്കൈയിൽ കലക്കവെള്ളം നിറച്ചുവെച്ചിരുന്നു.',
        'തയ്യൽക്കടയുടെ മുന്നിൽ എത്തിയപ്പോൾ ആന തുമ്പിക്കൈയിലെ ചെളി വെള്ളം മുഴുവൻ കടയിലെ പുതിയ തുണികളിലേക്ക് ചീറ്റി! തുണികളെല്ലാം വൃത്തികേടായി. ആരെയും വെറുതെ ഉപദ്രവിക്കരുതെന്ന് തയ്യൽക്കാരൻ വലിയ പാഠം പഠിച്ചു.',
      ],
    ),
    StoryItem(
      title: 'സ്വർണ്ണമുട്ടയിടുന്ന താറാവ്',
      emoji: '🪿',
      duration: '3 min read',
      moral: 'അത്യാഗ്രഹം വലിയ നാശത്തിന് കാരണമാകും; ഉള്ളതുകൊണ്ട് സംതൃപ്തരാവുക!',
      summary: 'ദിവസവും സ്വർണ്ണമുട്ടയിടുന്ന അത്ഭുത താറാവും അത്യാഗ്രഹിയായ കർഷകനും.',
      language: 'ml',
      themeColor: Color(0xFFF57C00),
      paragraphs: [
        'ഒരു പാവം കർഷകന്റെ വീട്ടിൽ ഒരു അത്ഭുത താറാവ് ഉണ്ടായിരുന്നു. ആ താറാവ് ദിവസവും രാവിലെ ഒരു സ്വർണ്ണമുട്ട ഇടുമായിരുന്നു.',
        'കർഷകൻ ആ മുട്ട ചന്തയിൽ വിറ്റ് സാവധാനം ധനികനായി മാറി. എന്നാൽ കൂടുതൽ പണം കിട്ടിയതോടെ അവന്റെ അത്യാഗ്രഹവും കൂടി.',
        'അവൻ വിചാരിച്ചു: "ദിവസവും ഓരോ മുട്ടയ്ക്കായി എന്തിന് കാത്തിരിക്കണം? ഈ താറാവിന്റെ വയറ്റിൽ ഒരുപാട് സ്വർണ്ണം ഉണ്ടാകും, അതെല്ലാം ഒറ്റയടിക്ക് എടുക്കാം!"',
        'അത്യാഗ്രഹം മൂത്ത കർഷകൻ താറാവിനെ കൊന്ന് വയറു തുറന്നു നോക്കി. എന്നാൽ സാധാരണ താറാവിനെപ്പോലെ തന്നെയായിരുന്നു അതിന്റെ ഉള്ളും!',
        'താറാവ് ചത്തുപോയി. ദിവസവും കിട്ടിക്കൊണ്ടിരുന്ന സ്വർണ്ണമുട്ടയും നഷ്ടമായി. കർഷകൻ തലയിൽ കൈവെച്ച് പൊട്ടിക്കരഞ്ഞു.',
        'അത്യാഗ്രഹം വലിയ നഷ്ടം മാത്രമേ ഉണ്ടാക്കൂ എന്ന് അവൻ കണ്ണീരോടെ തിരിച്ചറിഞ്ഞു.',
      ],
    ),
    StoryItem(
      title: 'കുറുക്കനും കൊക്കും',
      emoji: '🦊',
      duration: '3 min read',
      moral: 'നാം മറ്റുള്ളവരോട് എങ്ങനെ പെരുമാറുന്നുവോ, അതുപോലെ അവർ തിരിച്ചും പെരുമാറും!',
      summary: 'പരസ്പരം വിരുന്നൊരുക്കിയ തന്ത്രശാലിയായ കുറുക്കനും ബുദ്ധിമാനായ കൊക്കും.',
      language: 'ml',
      themeColor: Color(0xFF8E24AA),
      paragraphs: [
        'ഒരു കാട്ടിൽ തന്ത്രശാലിയായ ഒരു കുറുക്കനും നല്ലൊരു കൊക്കും തമ്മിൽ ചങ്ങാത്തത്തിലായി. ഒരു ദിവസം കുറുക്കൻ കൊക്കിനെ തന്റെ വീട്ടിലേക്ക് അത്താഴത്തിന് ക്ഷണിച്ചു.',
        'കുറുക്കൻ പരന്ന ഒരു പാത്രത്തിൽ സൂപ്പ് വിളമ്പി. പരന്ന പാത്രത്തിൽ നിന്നും കൊക്കിന് നീണ്ട കൊക്കുകൊണ്ട് സൂപ്പ് കുടിക്കാൻ കഴിഞ്ഞില്ല. കുറുക്കൻ എല്ലാം ഒറ്റയ്ക്ക് കുടിച്ചുതീർത്തു ചിരിച്ചു.',
        'കുറച്ചു ദിവസങ്ങൾക്ക് ശേഷം കൊക്ക് കുറുക്കനെ തന്റെ വീട്ടിലേക്ക് വിരുന്നിന് വിളിച്ചു.',
        'കൊക്ക് രുചികരമായ പായസം ഉണ്ടാക്കി, നീളമുള്ള ഇടുങ്ങിയ കഴുത്തുള്ള ഭരണികളിൽ വിളമ്പി.',
        'കൊക്ക് തന്റെ നീണ്ട കൊക്ക് ഭരണിക്കുള്ളിലേക്ക് ഇറക്കി സുഖമായി പായസം കുടിച്ചു. എന്നാൽ കുറുക്കന് കുടുങ്ങിയ ഭരണിക്കുള്ളിലേക്ക് വായ കടത്താൻ സാധിച്ചില്ല!',
        'മറ്റുള്ളവരെ കളിയാക്കിയാൽ അത് തനിക്കും തിരിച്ചുകിട്ടും എന്ന് കുറുക്കൻ മനസ്സിലാക്കി നാണിച്ചു തലതാഴ്ത്തി.',
      ],
    ),

    // ==========================================
    // 🇬🇧 ENGLISH CLASSIC STORIES (en)
    // ==========================================
    StoryItem(
      title: 'The Tortoise and the Hare',
      emoji: '🐢',
      duration: '3 min read',
      moral: 'Slow and steady wins the race!',
      summary: 'A boastful hare challenges a patient tortoise to a race with a surprising finish.',
      paragraphs: [
        'Once upon a time in a lush green forest, there lived a speedy Hare who loved bragging about how fast he could run.',
        'Tired of his bragging, a wise and quiet Tortoise challenged him to a friendly foot race across the meadow.',
        'The Hare laughed out loud: "A race against you? I will win before you even take ten steps!" All the forest animals gathered to watch.',
        'The race began! The Hare zoomed ahead like lightning. Halfway through, seeing the Tortoise far behind, the confident Hare decided to take a quick nap under an apple tree.',
        'While the Hare snoozed deeply, the patient Tortoise kept walking step by step, never pausing or giving up.',
        'When the Hare woke up with a start, he saw the Tortoise crossing the finish line to the cheers of all the animals! The Tortoise smiled and proved that slow and steady wins the race.',
      ],
      themeColor: Color(0xFF26A69A),
    ),
    StoryItem(
      title: 'The Lion and the Mouse',
      emoji: '🦁',
      duration: '3 min read',
      moral: 'Even the smallest friend can be a great helper!',
      summary: 'A tiny mouse promises to help a mighty lion, proving kindness always matters.',
      paragraphs: [
        'One sunny afternoon, a great Lion was fast asleep in his cave. A curious little Mouse scampered across his big nose by accident and woke him up.',
        'The Lion placed his huge paw over the shivering mouse: "How dare you wake the king of beasts!"',
        'The little mouse squeaked: "Please forgive me, mighty Lion! Spare my life, and one day I will surely help you!" The Lion laughed at the idea of a tiny mouse helping him, but kindly let him go.',
        'A few weeks later, the Lion was caught in a strong rope trap set by hunters. He roared loudly in distress throughout the jungle.',
        'Hearing the familiar roar, the little Mouse hurried over. Using her sharp little teeth, she gnawed through the thick ropes until the Lion was completely free!',
        'The mighty Lion bowed his head with gratitude: "Thank you, little friend. Today you taught me that even the smallest creature can make a huge difference."',
      ],
      themeColor: Color(0xFFFFB300),
    ),
    StoryItem(
      title: 'The Thirsty Crow',
      emoji: '🦅',
      duration: '2 min read',
      moral: 'Where there is a will, there is a way!',
      summary: 'A clever crow uses pebbles to raise the water level and quench his thirst.',
      paragraphs: [
        'On a hot summer day, a thirsty Crow flew all across the countryside searching for water to drink.',
        'He flew over farms and trees until at last, in a quiet garden, he spotted a tall clay pitcher with water inside.',
        'The Crow swooped down joyfully, but when he peered in, he found the water level was too low for his beak to reach.',
        'The Crow thought carefully: "If I tip it over, all the water will spill. What can I do?" He looked around and saw smooth little pebbles on the garden path.',
        'One by one, the clever Crow picked up pebbles with his beak and dropped them into the pitcher. With each stone, the water rose higher and higher!',
        'Soon the refreshing water reached the very rim. The smart Crow drank his fill happily, proving that clever thinking solves any problem!',
      ],
      themeColor: Color(0xFF5C6BC0),
    ),
    StoryItem(
      title: 'The Ant and the Grasshopper',
      emoji: '🐜',
      duration: '3 min read',
      moral: 'Hard work today brings peace and comfort tomorrow.',
      summary: 'Hardworking ants prepare for winter while a carefree grasshopper sings the days away.',
      paragraphs: [
        'During a bright summer, a merry Grasshopper spent his days playing music, dancing, and enjoying the warm sunshine.',
        'Nearby, a line of busy Ants marched back and forth carrying heavy grains of wheat into their cozy underground storehouse.',
        'The Grasshopper laughed: "Why work so hard in the summer? Come sing and play with me!" The Ants replied: "We are storing food for the chilly winter, and you should too!"',
        'The Grasshopper ignored their advice and continued dancing. Soon, cold winds blew and white snow covered the entire meadow.',
        'Freezing and hungry, the Grasshopper found no food anywhere. In despair, he knocked on the Ants\' warm door.',
        'The kind Ants shared their warm soup and grains with him. The Grasshopper realized that planning ahead and working diligently is the key to happiness.',
      ],
      themeColor: Color(0xFF66BB6A),
    ),
    StoryItem(
      title: 'The Boy Who Cried Wolf',
      emoji: '🐺',
      duration: '3 min read',
      moral: 'Honesty is always the best policy; truth builds trust.',
      summary: 'A bored shepherd boy learns that playing tricks costs the trust of his village.',
      paragraphs: [
        'A young shepherd boy watched over a flock of fluffy sheep on a hillside near a peaceful village.',
        'Feeling bored one day, he decided to play a trick. He ran toward the village shouting: "Wolf! Wolf! A wolf is chasing the sheep!"',
        'The villagers dropped their work and rushed up the hill with sticks to protect the sheep, only to find the boy laughing heartily at his prank.',
        'A few days later, the boy played the exact same trick again. Once more, the kind villagers came running, only to be laughed at.',
        'Then, one evening at sunset, a real wolf crept out of the shadows toward the flock! Terrified, the boy cried: "Wolf! Wolf! Please help, it is real!"',
        'Thinking it was another trick, no villagers came. The boy learned a lifelong lesson: no one believes a liar, even when they tell the truth.',
      ],
      themeColor: Color(0xFFEF5350),
    ),
    StoryItem(
      title: 'The Golden Goose',
      emoji: '🪿',
      duration: '3 min read',
      moral: 'Be thankful for what you have; greed leads to regret.',
      summary: 'A lucky farmer discovers a goose that lays golden eggs, learning the danger of greed.',
      paragraphs: [
        'A humble country farmer owned a very special goose that laid one solid golden egg every single morning.',
        'Each day, the farmer sold the golden egg and slowly grew wealthy. But the more gold he had, the greedier he became.',
        'He thought to himself: "If this bird lays golden eggs, her inside must be filled with pure gold! Why wait one egg at a time?"',
        'In his impatience, the greedy farmer took the goose and looked inside. But to his dismay, the magical goose was just like any ordinary bird inside!',
        'The farmer wept in regret. In his greed to have everything at once, he had lost the wonderful golden treasure he enjoyed each morning.',
        'He learned that patience and gratitude bring true lasting happiness.',
      ],
      themeColor: Color(0xFFFF7043),
    ),
  ];

  List<StoryItem> get _filteredStories {
    if (_selectedFilter == 'ml') {
      return _storiesList.where((s) => s.language == 'ml').toList();
    } else if (_selectedFilter == 'en') {
      return _storiesList.where((s) => s.language == 'en').toList();
    }
    return _storiesList;
  }

  void _openStoryReader(BuildContext context, StoryItem story) {
    final learningProvider = Provider.of<LearningProvider>(context, listen: false);
    learningProvider.completeLesson(AppConstants.moduleStories, coinReward: 10);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => _StoryReaderScreen(story: story),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);
    final isTablet = ResponsiveUtil.isTablet(context);
    final stories = _filteredStories;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bedtime Stories 📖',
          style: GoogleFonts.fredoka(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton.icon(
            icon: const Text('✨', style: TextStyle(fontSize: 16)),
            label: const Text(
              'AI Magic',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFFE64A19),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.aiStoryGenerator);
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 12,
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: stories.length + 2, // 1 for AI banner, 1 for filter chips
            itemBuilder: (context, index) {
              if (index == 0) {
                // AI Story Magic Promo Banner
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF8A65), Color(0xFFFF5722)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5722).withValues(alpha: 0.28),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.aiStoryGenerator);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('🪄', style: TextStyle(fontSize: 28)),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'AI Bedtime Story Magic',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.fredoka(
                                          fontSize: isTablet ? 18 : 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'NEW',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Choose your hero, moral & setting. Create a custom tale!',
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (index == 1) {
                // Language Filter Bar (All / Malayalam / English)
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildFilterChip('all', 'All Stories 📚', _storiesList.length),
                        const SizedBox(width: 8),
                        _buildFilterChip('ml', '🌴 മലയാളം കഥകൾ', 6, isMalayalam: true),
                        const SizedBox(width: 8),
                        _buildFilterChip('en', '🇬🇧 English Stories', 6),
                      ],
                    ),
                  ),
                );
              }

              final story = stories[index - 2];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: story.themeColor.withValues(alpha: 0.35),
                    width: 1.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: story.themeColor.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openStoryReader(context, story),
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Story Book Cover Disc
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: story.themeColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: story.themeColor.withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                story.emoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Story Title, Badges, and Summary
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        story.title,
                                        style: GoogleFonts.fredoka(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: story.language == 'ml'
                                            ? const Color(0xFFE8F5E9)
                                            : const Color(0xFFEDE7F6),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: story.language == 'ml'
                                              ? const Color(0xFFC8E6C9)
                                              : const Color(0xFFD1C4E9),
                                        ),
                                      ),
                                      child: Text(
                                        story.language == 'ml' ? '🌴 മലയാളം' : '🇬🇧 English',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: story.language == 'ml'
                                              ? const Color(0xFF2E7D32)
                                              : const Color(0xFF512DA8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  story.summary,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Duration & Moral Badge
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: story.themeColor.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        story.duration,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: story.themeColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('⭐', style: TextStyle(fontSize: 12)),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        story.moral,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: AppColors.textLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterId, String label, int count, {bool isMalayalam = false}) {
    final isSelected = _selectedFilter == filterId;
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedFilter = filterId;
        });
      },
      selectedColor: isMalayalam ? const Color(0xFFC8E6C9) : AppColors.primaryLight,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        color: isSelected
            ? (isMalayalam ? const Color(0xFF1B5E20) : AppColors.primaryDark)
            : AppColors.textPrimary,
      ),
    );
  }
}

/// Full interactive illustrated Story Reader Screen with "Read to Me" voice narration.
class _StoryReaderScreen extends StatefulWidget {
  final StoryItem story;

  const _StoryReaderScreen({required this.story});

  @override
  State<_StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<_StoryReaderScreen> {
  bool _isNarrating = false;

  Future<void> _toggleNarration() async {
    final tts = Provider.of<TtsService>(context, listen: false);

    if (_isNarrating) {
      await tts.stop();
      setState(() => _isNarrating = false);
    } else {
      setState(() => _isNarrating = true);
      final fullStory = widget.story.language == 'ml'
          ? '${widget.story.title}. ${widget.story.paragraphs.join(" ")} ഗുണപാഠം: ${widget.story.moral}'
          : '${widget.story.title}. ${widget.story.paragraphs.join(" ")} Moral of the story: ${widget.story.moral}';

      await tts.speak(fullStory);
      if (mounted) {
        setState(() => _isNarrating = false);
      }
    }
  }

  @override
  void dispose() {
    // Stop speech if exiting reader
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.story.title,
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleNarration,
            tooltip: _isNarrating ? 'Pause Narration' : 'Read to Me',
            icon: Icon(
              _isNarrating ? Icons.pause_circle_filled_rounded : Icons.volume_up_rounded,
              color: widget.story.themeColor,
              size: 28,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Story Header Cover Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: widget.story.themeColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Row(
                    children: [
                      Text(widget.story.emoji, style: const TextStyle(fontSize: 48)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.story.title,
                              style: GoogleFonts.fredoka(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.story.duration,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: widget.story.themeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // "Read to Me" Floating Action Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: widget.story.themeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isNarrating ? Icons.graphic_eq_rounded : Icons.auto_stories_rounded,
                        color: widget.story.themeColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _isNarrating ? 'Reading story aloud...' : 'Tap "Read to Me" to listen along!',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: widget.story.themeColor,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _toggleNarration,
                        icon: Icon(_isNarrating ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 20),
                        label: Text(_isNarrating ? 'Stop' : 'Read to Me'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.story.themeColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Story Paragraphs
                ...widget.story.paragraphs.map((p) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      p,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 10),

                // Moral of the Story Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFFFD54F), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFB300).withValues(alpha: 0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('⭐', style: TextStyle(fontSize: 22)),
                          SizedBox(width: 8),
                          Text(
                            'Moral of the Story',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFB78103),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.story.moral,
                        style: GoogleFonts.fredoka(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
