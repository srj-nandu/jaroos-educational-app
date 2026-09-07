import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';

class RhymeItem {
  final String title;
  final String emoji;
  final String tag;
  final List<String> verses;
  final Color themeColor;

  const RhymeItem({
    required this.title,
    required this.emoji,
    required this.tag,
    required this.verses,
    required this.themeColor,
  });
}

/// Interactive Rhymes Module for JAROOS.
/// Features beloved classic nursery rhymes with musical lyrics
/// and "Sing / Play Rhyme" interactive TTS audio accompaniment.
class RhymesScreen extends StatelessWidget {
  const RhymesScreen({super.key});

  static const List<RhymeItem> _rhymesList = [
    RhymeItem(
      title: 'Twinkle, Twinkle, Little Star',
      emoji: '⭐',
      tag: 'Lullaby • Star',
      verses: [
        'Twinkle, twinkle, little star,\nHow I wonder what you are!',
        'Up above the world so high,\nLike a diamond in the sky.',
        'When the blazing sun is gone,\nWhen he nothing shines upon,',
        'Then you show your little light,\nTwinkle, twinkle, all the night.',
      ],
      themeColor: Color(0xFFFFB300),
    ),
    RhymeItem(
      title: 'The Wheels on the Bus',
      emoji: '🚌',
      tag: 'Action Song • Travel',
      verses: [
        'The wheels on the bus go round and round,\nRound and round, round and round.\nThe wheels on the bus go round and round,\nAll through the town!',
        'The wipers on the bus go swish, swish, swish,\nSwish, swish, swish, swish, swish, swish.\nThe wipers on the bus go swish, swish, swish,\nAll through the town!',
        'The horn on the bus goes beep, beep, beep,\nBeep, beep, beep, beep, beep, beep.\nThe horn on the bus goes beep, beep, beep,\nAll through the town!',
        'The doors on the bus go open and shut,\nOpen and shut, open and shut.\nThe doors on the bus go open and shut,\nAll through the town!',
      ],
      themeColor: Color(0xFFEF5350),
    ),
    RhymeItem(
      title: 'Old MacDonald Had a Farm',
      emoji: '🚜',
      tag: 'Animals • Farm',
      verses: [
        'Old MacDonald had a farm, E-I-E-I-O!\nAnd on his farm he had a cow, E-I-E-I-O!',
        'With a moo-moo here and a moo-moo there,\nHere a moo, there a moo, everywhere a moo-moo!\nOld MacDonald had a farm, E-I-E-I-O!',
        'And on his farm he had a duck, E-I-E-I-O!\nWith a quack-quack here and a quack-quack there,\nEverywhere a quack-quack!\nOld MacDonald had a farm, E-I-E-I-O!',
      ],
      themeColor: Color(0xFF66BB6A),
    ),
    RhymeItem(
      title: 'Baa, Baa, Black Sheep',
      emoji: '🐑',
      tag: 'Gentle • Animals',
      verses: [
        'Baa, baa, black sheep, have you any wool?\nYes, sir, yes, sir, three bags full!',
        'One for the master, and one for the dame,\nAnd one for the little boy who lives down the lane.',
      ],
      themeColor: Color(0xFF78909C),
    ),
    RhymeItem(
      title: 'Humpty Dumpty',
      emoji: '🥚',
      tag: 'Classic • Rhythm',
      verses: [
        'Humpty Dumpty sat on a wall,\nHumpty Dumpty had a great fall!',
        'All the king\'s horses and all the king\'s men,\nCouldn\'t put Humpty together again!',
      ],
      themeColor: Color(0xFFFF7043),
    ),
    RhymeItem(
      title: 'Row, Row, Row Your Boat',
      emoji: '🚣',
      tag: 'Calm • Water',
      verses: [
        'Row, row, row your boat,\nGently down the stream,\nMerrily, merrily, merrily, merrily,\nLife is but a dream!',
      ],
      themeColor: Color(0xFF29B6F6),
    ),
    RhymeItem(
      title: 'Incy Wincy Spider',
      emoji: '🕷️',
      tag: 'Perseverance • Nature',
      verses: [
        'Incy Wincy spider climbed up the water spout.\nDown came the rain and washed the spider out!',
        'Out came the sunshine and dried up all the rain,\nAnd Incy Wincy spider climbed up the spout again!',
      ],
      themeColor: Color(0xFFAB47BC),
    ),
    RhymeItem(
      title: 'Five Little Monkeys',
      emoji: '🐒',
      tag: 'Counting • Fun',
      verses: [
        'Five little monkeys jumping on the bed,\nOne fell off and bumped his head!',
        'Mama called the doctor and the doctor said:\n"No more monkeys jumping on the bed!"',
      ],
      themeColor: Color(0xFFFFA000),
    ),
  ];

  void _openRhymePlayer(BuildContext context, RhymeItem rhyme) {
    final learningProvider = Provider.of<LearningProvider>(context, listen: false);
    learningProvider.completeLesson(AppConstants.moduleRhymes, coinReward: 10);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => _RhymePlayerScreen(rhyme: rhyme),
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
          'Fun Rhymes 🎵',
          style: GoogleFonts.fredoka(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
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
            itemCount: _rhymesList.length,
            itemBuilder: (context, index) {
              final rhyme = _rhymesList[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: rhyme.themeColor.withValues(alpha: 0.35),
                    width: 1.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: rhyme.themeColor.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openRhymePlayer(context, rhyme),
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Rhyme Disc
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: rhyme.themeColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: rhyme.themeColor.withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                rhyme.emoji,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Title & Tag
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rhyme.title,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: rhyme.themeColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    rhyme.tag,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: rhyme.themeColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: rhyme.themeColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
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

/// Interactive Sing-Along Rhyme Player Screen with rhythmic TTS recital.
class _RhymePlayerScreen extends StatefulWidget {
  final RhymeItem rhyme;

  const _RhymePlayerScreen({required this.rhyme});

  @override
  State<_RhymePlayerScreen> createState() => _RhymePlayerScreenState();
}

class _RhymePlayerScreenState extends State<_RhymePlayerScreen> {
  bool _isPlaying = false;

  Future<void> _toggleRecital() async {
    final tts = Provider.of<TtsService>(context, listen: false);

    if (_isPlaying) {
      await tts.stop();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isPlaying = true);
      final text = '${widget.rhyme.title}. ${widget.rhyme.verses.join(" ... ")}';
      await tts.speak(text);
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.rhyme.title,
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleRecital,
            tooltip: _isPlaying ? 'Pause Rhyme' : 'Play Rhyme',
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled_rounded : Icons.volume_up_rounded,
              color: widget.rhyme.themeColor,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cheerful Rhyme Musical Banner
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: widget.rhyme.themeColor.withValues(alpha: 0.35),
                      width: 2,
                    ),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Column(
                    children: [
                      Text(widget.rhyme.emoji, style: const TextStyle(fontSize: 60)),
                      const SizedBox(height: 12),
                      Text(
                        widget.rhyme.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '🎶 Sing along with the words! 🎶',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: widget.rhyme.themeColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Big Puffy Play/Recite Button
                      ElevatedButton.icon(
                        onPressed: _toggleRecital,
                        icon: Icon(_isPlaying ? Icons.stop_rounded : Icons.music_note_rounded, size: 24),
                        label: Text(_isPlaying ? 'Stop Rhyme' : 'Sing / Play Rhyme 🎵'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.rhyme.themeColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          minimumSize: const Size(200, 48),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Lyrical Stanzas
                ...widget.rhyme.verses.map((verse) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFF2ECE0),
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
                    child: Text(
                      verse,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
