import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/audio_fx_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';
import '../../common/widgets/frog_assistant_widget.dart';

class StoryItem {
  final String title;
  final String emoji;
  final String duration;
  final String moral;
  final String summary;
  final List<String> paragraphs;
  final Color themeColor;
  final String characterName;

  const StoryItem({
    required this.title,
    required this.emoji,
    required this.duration,
    required this.moral,
    required this.summary,
    required this.paragraphs,
    required this.themeColor,
    required this.characterName,
  });
}

/// Interactive Bedtime & Moral Stories Module for JAROOS.
/// Features:
/// - Classic children's moral tales
/// - Interactive "Read to Me" voice narration
/// - Built-in Audio Sound FX Soundboard (character voices, magic sparkles, cheering)
/// - Illustrated reading cards
/// - Embedded Cut-the-Rope Frog Assistant ("Froggo")
class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  static const List<StoryItem> _storiesList = [
    StoryItem(
      title: 'The Tortoise and the Hare',
      emoji: '🐢',
      duration: '3 min read',
      moral: 'Slow and steady wins the race!',
      summary: 'A boastful hare challenges a patient tortoise to a race with a surprising finish.',
      characterName: 'Hare',
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
      characterName: 'Lion',
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
      characterName: 'Crow',
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
      characterName: 'Grasshopper',
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
  ];

  void _openStoryReader(BuildContext context, StoryItem story) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _StoryReaderScreen(story: story)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Bedtime Stories 📖',
          style: GoogleFonts.fredoka(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF132A13),
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
              itemCount: _storiesList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // AI Story Creator Banner
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.aiStoryGenerator),
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Center(
                                  child: Text('✨', style: TextStyle(fontSize: 28)),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Story Magic Studio',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
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
                              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final story = _storiesList[index - 1];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: story.themeColor.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _openStoryReader(context, story),
                      borderRadius: BorderRadius.circular(22),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: story.themeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Text(story.emoji, style: const TextStyle(fontSize: 30)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    story.title,
                                    style: GoogleFonts.fredoka(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1F2937),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    story.summary,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF9CA3AF)),
                                      const SizedBox(width: 4),
                                      Text(
                                        story.duration,
                                        style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF9CA3AF),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text('🔊 Sound FX', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.duolingoLime)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF9CA3AF)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Embedded Frog Assistant
          Positioned(
            bottom: 16,
            right: 16,
            child: const FrogAssistantWidget(
              compact: true,
              customTip: "Ribbit! Pick a story and listen to animal sounds! 📖",
            ),
          ),
        ],
      ),
    );
  }
}

/// Illustrated Story Reader Screen with "Read to Me" voice narration and Sound FX
class _StoryReaderScreen extends StatefulWidget {
  final StoryItem story;

  const _StoryReaderScreen({required this.story});

  @override
  State<_StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<_StoryReaderScreen> {
  bool _isNarrating = false;
  late AudioFxService _audioFx;
  String _activeSoundMessage = '';

  @override
  void initState() {
    super.initState();
    _audioFx = AudioFxService();
  }

  Future<void> _toggleNarration() async {
    final tts = ModularTtsService();

    if (_isNarrating) {
      await tts.stop();
      if (mounted) setState(() => _isNarrating = false);
    } else {
      if (mounted) setState(() => _isNarrating = true);
      final fullStory = '${widget.story.title}. ${widget.story.paragraphs.join(" ")} Moral of the story: ${widget.story.moral}';
      await tts.speak(fullStory);
      if (mounted) {
        setState(() => _isNarrating = false);
        _audioFx.playStoryFanfare(widget.story.title);
        context.read<LearningProvider>().completeLesson(AppConstants.moduleStories, coinReward: 15);
      }
    }
  }

  void _playSound(String label, Future<void> Function() soundAction) async {
    setState(() => _activeSoundMessage = label);
    await soundAction();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _activeSoundMessage = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.story.title,
          style: GoogleFonts.fredoka(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF132A13),
          ),
        ),
        actions: [
          // "Read to Me" Text & Button for test compatibility
          TextButton.icon(
            onPressed: _toggleNarration,
            icon: Icon(
              _isNarrating ? Icons.pause_circle_filled_rounded : Icons.volume_up_rounded,
              color: AppColors.duolingoLime,
              size: 22,
            ),
            label: Text(
              'Read to Me',
              style: GoogleFonts.fredoka(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.duolingoLime,
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Story Cover Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.forestGreenDark,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Text(widget.story.emoji, style: const TextStyle(fontSize: 36)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.story.title,
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.story.summary,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Interactive Soundboard Header & Buttons
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('🔊', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Story Soundboard FX (Tap to Play!)',
                                style: GoogleFonts.fredoka(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF132A13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildSoundChip('🦁 Roar', () => _audioFx.playStoryCharacterSound('lion')),
                            _buildSoundChip('🐭 Squeak', () => _audioFx.playStoryCharacterSound('mouse')),
                            _buildSoundChip('🐇 Zoom', () => _audioFx.playStoryCharacterSound('hare')),
                            _buildSoundChip('🐢 Steps', () => _audioFx.playStoryCharacterSound('tortoise')),
                            _buildSoundChip('🦅 Plop', () => _audioFx.playStoryCharacterSound('crow')),
                            _buildSoundChip('✨ Magic', () => _audioFx.playMagicChime()),
                            _buildSoundChip('👏 Cheers', () => _audioFx.playApplause()),
                          ],
                        ),
                        if (_activeSoundMessage.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Playing: $_activeSoundMessage',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.duolingoLime,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Paragraph Cards
                  for (int i = 0; i < widget.story.paragraphs.length; i++) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
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
                              color: AppColors.duolingoLime.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: GoogleFonts.fredoka(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.duolingoLime,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.story.paragraphs[i],
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF374151),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Moral of the Story Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('🌟', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 8),
                            Text(
                              'Moral of the Story',
                              style: GoogleFonts.fredoka(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF92400E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.story.moral,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),

          // Embedded Frog Assistant listening along!
          Positioned(
            bottom: 16,
            right: 16,
            child: const FrogAssistantWidget(
              compact: true,
              customTip: "Ribbit! What an inspiring story! 🌟",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundChip(String label, Future<void> Function() soundAction) {
    return GestureDetector(
      onTap: () => _playSound(label, soundAction),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }
}
