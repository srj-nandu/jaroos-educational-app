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

  const StoryItem({
    required this.title,
    required this.emoji,
    required this.duration,
    required this.moral,
    required this.summary,
    required this.paragraphs,
    required this.themeColor,
  });
}

/// Interactive Bedtime & Moral Stories Module for JAROOS.
/// Features classic children's moral tales with interactive "Read to Me" TTS narration.
class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  static const List<StoryItem> _storiesList = [
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
            itemCount: _storiesList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // AI Story Magic Promo Banner
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
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

              final story = _storiesList[index - 1];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
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

                          // Story Title & Summary
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  story.title,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
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
      final fullStory = '${widget.story.title}. ${widget.story.paragraphs.join(" ")} Moral of the story: ${widget.story.moral}';
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
