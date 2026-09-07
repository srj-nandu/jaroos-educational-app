import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../models/ai_models.dart';
import '../../../providers/learning_provider.dart';
import '../../../services/ai_service.dart';

/// Interactive AI Bedtime Story Generator for JAROOS.
/// Allows young learners to pick a Hero, a Moral Theme, and a Setting,
/// generating a personalized, child-safe bedtime moral tale with full TTS read-aloud support.
class AiStoryGeneratorScreen extends StatefulWidget {
  const AiStoryGeneratorScreen({super.key});

  @override
  State<AiStoryGeneratorScreen> createState() => _AiStoryGeneratorScreenState();
}

class _AiStoryGeneratorScreenState extends State<AiStoryGeneratorScreen> {
  String _selectedHero = 'Baby Dragon';
  String _selectedTheme = 'Kindness';
  String _selectedSetting = 'Enchanted Forest';

  bool _isGenerating = false;
  GeneratedStory? _currentStory;
  bool _isNarrating = false;

  final List<Map<String, String>> _heroes = [
    {'name': 'Baby Dragon', 'emoji': '🐉', 'color': '0xFFFF7043'},
    {'name': 'Brave Bunny', 'emoji': '🐰', 'color': '0xFF4FC3F7'},
    {'name': 'Little Astronaut', 'emoji': '🚀', 'color': '0xFFAB47BC'},
    {'name': 'Friendly Robot', 'emoji': '🤖', 'color': '0xFF66BB6A'},
    {'name': 'Playful Puppy', 'emoji': '🐶', 'color': '0xFFFFA726'},
    {'name': 'Magic Mermaid', 'emoji': '🧜', 'color': '0xFF26C6DA'},
  ];

  final List<Map<String, String>> _themes = [
    {'name': 'Kindness', 'emoji': '💖', 'desc': 'Being warm & gentle'},
    {'name': 'Sharing Toys', 'emoji': '🧸', 'desc': 'Playing together'},
    {'name': 'Telling the Truth', 'emoji': '🌟', 'desc': 'Honesty & trust'},
    {'name': 'Never Giving Up', 'emoji': '💪', 'desc': 'Try again with courage'},
    {'name': 'Helping Friends', 'emoji': '🤝', 'desc': 'Teamwork & care'},
    {'name': 'Patience', 'emoji': '⏳', 'desc': 'Taking calm breaths'},
  ];

  final List<Map<String, String>> _settings = [
    {'name': 'Enchanted Forest', 'emoji': '🌲'},
    {'name': 'Candy Kingdom', 'emoji': '🍭'},
    {'name': 'Twinkling Galaxy', 'emoji': '🌌'},
    {'name': 'Underwater Palace', 'emoji': '🌊'},
    {'name': 'Cloud Castle', 'emoji': '☁️'},
    {'name': 'Sunny Meadow', 'emoji': '🌻'},
  ];

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _generateStory() async {
    setState(() {
      _isGenerating = true;
      _isNarrating = false;
    });

    final ai = Provider.of<AiService>(context, listen: false);
    final learning = Provider.of<LearningProvider>(context, listen: false);

    try {
      final story = await ai.generateBedtimeStory(
        hero: _selectedHero,
        theme: _selectedTheme,
        setting: _selectedSetting,
      );

      // Award 10 coins for generating and reading a story!
      learning.addCoins(10);

      if (mounted) {
        setState(() {
          _currentStory = story;
          _isGenerating = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Oops! Story magic took a little nap. Try again!')),
        );
      }
    }
  }

  Future<void> _narrateStory() async {
    if (_currentStory == null) return;
    final tts = Provider.of<TtsService>(context, listen: false);

    if (_isNarrating) {
      await tts.stop();
      if (mounted) {
        setState(() => _isNarrating = false);
      }
    } else {
      setState(() => _isNarrating = true);
      final fullText = '${_currentStory!.title}. '
          '${_currentStory!.paragraphs.join(' ')} '
          '${_currentStory!.moral}';

      await tts.speak(fullText);
      if (mounted) {
        setState(() => _isNarrating = false);
      }
    }
  }

  void _resetPicker() {
    final tts = Provider.of<TtsService>(context, listen: false);
    tts.stop();
    setState(() {
      _currentStory = null;
      _isNarrating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtil.isTablet(context);
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Story Magic ✨',
          style: GoogleFonts.fredoka(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Talk to Sparky AI',
            icon: const Icon(Icons.forum_rounded, color: AppColors.primaryDark),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.aiBuddy);
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
          child: _isGenerating
              ? _buildGeneratingState(isTablet)
              : _currentStory != null
                  ? _buildStoryReaderView(isTablet, horizontalPadding)
                  : _buildStoryPickerView(isTablet, horizontalPadding),
        ),
      ),
    );
  }

  /// Magical loading animation state
  Widget _buildGeneratingState(bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '🪄',
                style: TextStyle(fontSize: 54),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 4,
          ),
          const SizedBox(height: 20),
          Text(
            'Sparky is weaving your magical bedtime tale...',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mixing $_selectedHero with $_selectedTheme in $_selectedSetting ✨',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 3-Step Selection View (Hero, Moral Theme, Magical Setting)
  Widget _buildStoryPickerView(bool isTablet, double horizontalPadding) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner introducing AI Story Creation
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF673AB7), Color(0xFF512DA8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF673AB7).withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('📖', style: TextStyle(fontSize: 30)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Your Bedtime Story!',
                        style: GoogleFonts.fredoka(
                          fontSize: isTablet ? 20 : 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pick your hero, moral value, and magical place. Sparky writes it just for you!',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Step 1: Choose Hero
          _buildStepHeader(
            stepNumber: '1',
            title: 'Choose Your Hero',
            subtitle: 'Who goes on today’s big adventure?',
            isTablet: isTablet,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _heroes.map((hero) {
              final isSelected = _selectedHero == hero['name'];
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(hero['emoji']!, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      hero['name']!,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isSelected ? AppColors.primaryDark : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                elevation: isSelected ? 3 : 0,
                onSelected: (_) {
                  setState(() => _selectedHero = hero['name']!);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Step 2: Choose Moral Theme
          _buildStepHeader(
            stepNumber: '2',
            title: 'Choose A Moral Theme',
            subtitle: 'What positive lesson will your hero learn?',
            isTablet: isTablet,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _themes.map((theme) {
              final isSelected = _selectedTheme == theme['name'];
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(theme['emoji']!, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      theme['name']!,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                selectedColor: const Color(0xFFE91E63),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFFC2185B) : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                elevation: isSelected ? 3 : 0,
                onSelected: (_) {
                  setState(() => _selectedTheme = theme['name']!);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Step 3: Choose Setting
          _buildStepHeader(
            stepNumber: '3',
            title: 'Choose Magical Setting',
            subtitle: 'Where does the story take place?',
            isTablet: isTablet,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _settings.map((setting) {
              final isSelected = _selectedSetting == setting['name'];
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(setting['emoji']!, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      setting['name']!,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF00897B),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF004D40) : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                elevation: isSelected ? 3 : 0,
                onSelected: (_) {
                  setState(() => _selectedSetting = setting['name']!);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Magical Action Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              icon: const Text('✨', style: TextStyle(fontSize: 22)),
              label: Text(
                'Generate Bedtime Story',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _generateStory,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStepHeader({
    required String stepNumber,
    required String title,
    required String subtitle,
    required bool isTablet,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: isTablet ? 19 : 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Story Reader View when a tale has been created
  Widget _buildStoryReaderView(bool isTablet, double horizontalPadding) {
    final story = _currentStory!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Story Cover Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB74D), Color(0xFFF57C00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF57C00).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  story.heroEmoji,
                  style: const TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 10),
                Text(
                  story.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: isTablet ? 26 : 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildPillChip('Hero: ${story.hero}', Colors.white.withValues(alpha: 0.25)),
                    _buildPillChip('Theme: ${story.theme}', Colors.white.withValues(alpha: 0.25)),
                    _buildPillChip('Setting: ${story.setting}', Colors.white.withValues(alpha: 0.25)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Audio Narrator & Story Controls
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(
                    _isNarrating ? Icons.pause_circle_filled_rounded : Icons.volume_up_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    _isNarrating ? 'Pause Audio ⏸️' : 'Read to Me 🔊',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isNarrating ? Colors.redAccent : AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _narrateStory,
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryDark),
                label: const Text('New Story', style: TextStyle(fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _resetPicker,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Paragraph Cards
          ...story.paragraphs.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final para = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.border,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$idx',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      para,
                      style: GoogleFonts.nunito(
                        fontSize: isTablet ? 17 : 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 6),

          // Moral Takeaway Golden Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF9C4), Color(0xFFFFF176)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFFBC02D), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFBC02D).withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🌟', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      'Golden Lesson',
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF7F4B00),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  story.moral,
                  style: GoogleFonts.nunito(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF5D4037),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Coins Award Notification
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🪙', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '+10 Golden Coins Earned For Reading!',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildPillChip(String text, Color bg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
