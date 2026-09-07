import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/rhyme_music_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';
import '../../common/widgets/frog_assistant_widget.dart';

/// Legacy model compatibility wrapper for RhymesScreen
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

/// Fully Musical Nursery Rhymes Module for JAROOS.
/// Features authentic melodic singing delivery with pitch modulation,
/// interactive rainbow xylophone (Do-Re-Mi), real-time animated dancing
/// equalizer, karaoke bouncing follower, and rhythm percussion pads.
class RhymesScreen extends StatelessWidget {
  const RhymesScreen({super.key});

  static List<MusicalRhyme> get _catalog => RhymeMusicService.catalog;

  void _openRhymePlayer(BuildContext context, MusicalRhyme rhyme) {
    final learningProvider = Provider.of<LearningProvider>(context, listen: false);
    learningProvider.completeLesson(AppConstants.moduleRhymes, coinReward: 10);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => _RhymePlayerScreen(musicalRhyme: rhyme),
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
            itemCount: _catalog.length,
            itemBuilder: (context, index) {
              final rhyme = _catalog[index];

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

                          // Title & Musical Tag
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
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF132A13).withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        rhyme.musicalKey,
                                        style: GoogleFonts.nunito(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF132A13),
                                        ),
                                      ),
                                    ),
                                  ],
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

/// Fully Musical Sing-Along & Xylophone Player Screen
class _RhymePlayerScreen extends StatefulWidget {
  final MusicalRhyme musicalRhyme;

  const _RhymePlayerScreen({required this.musicalRhyme});

  // Backward compatibility getter for tests expecting rhyme.title
  RhymeItem get rhyme => RhymeItem(
        title: musicalRhyme.title,
        emoji: musicalRhyme.emoji,
        tag: musicalRhyme.tag,
        verses: musicalRhyme.plainVerses,
        themeColor: musicalRhyme.themeColor,
      );

  @override
  State<_RhymePlayerScreen> createState() => _RhymePlayerScreenState();
}

class _RhymePlayerScreenState extends State<_RhymePlayerScreen>
    with TickerProviderStateMixin {
  late final RhymeMusicService _musicService;
  bool _isPlaying = false;
  int _activeVerseIndex = -1;
  bool _isPlayAlongMode = false;
  int _targetMelodyNoteIndex = 0;

  late final AnimationController _equalizerController;
  late final AnimationController _discRotationController;

  @override
  void initState() {
    super.initState();
    final tts = Provider.of<TtsService>(context, listen: false);
    _musicService = RhymeMusicService(ttsService: tts);

    _equalizerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _discRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
  }

  @override
  void dispose() {
    _musicService.stop();
    _equalizerController.dispose();
    _discRotationController.dispose();
    super.dispose();
  }

  /// Plays melodic singing line-by-line with karaoke highlighting
  Future<void> _toggleRecital() async {
    if (_isPlaying) {
      await _musicService.stop();
      _discRotationController.stop();
      _equalizerController.stop();
      _equalizerController.reset();
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _activeVerseIndex = -1;
        });
      }
    } else {
      setState(() {
        _isPlaying = true;
        _activeVerseIndex = 0;
      });
      _discRotationController.repeat();
      _equalizerController.repeat(reverse: true);

      try {
        // 1. Musical intro lead-in count-in
        await _musicService.playMusicalLeadIn();

        // 2. Sing each verse melodically with pitch modulation
        for (int i = 0; i < widget.musicalRhyme.scores.length; i++) {
          if (!_isPlaying || !mounted) break;

          setState(() => _activeVerseIndex = i);
          final score = widget.musicalRhyme.scores[i];
          await _musicService.singVerse(score);

          // Brief musical pause between lines
          if (_isPlaying && mounted) {
            await Future.delayed(const Duration(milliseconds: 350));
          }
        }

        // 3. Celebratory musical finale
        if (_isPlaying && mounted) {
          await _musicService.playMusicalFinale(widget.musicalRhyme.title);
        }
      } catch (e) {
        debugPrint('[JAROOS Rhymes Playback] $e');
      } finally {
        if (mounted) {
          _discRotationController.stop();
          _equalizerController.stop();
          _equalizerController.reset();
          setState(() {
            _isPlaying = false;
            _activeVerseIndex = -1;
          });
        }
      }
    }
  }

  /// Sings a single verse when clicked by the child
  Future<void> _singSingleVerse(int index) async {
    if (index >= 0 && index < widget.musicalRhyme.scores.length) {
      setState(() => _activeVerseIndex = index);
      final score = widget.musicalRhyme.scores[index];
      await _musicService.singVerse(score);
      if (mounted) {
        setState(() => _activeVerseIndex = -1);
      }
    }
  }

  /// Tapping a rainbow xylophone key
  Future<void> _onTapXylophoneKey(XylophoneKeyData key) async {
    await _musicService.playXylophoneKey(key);

    // In Play-Along Mode, check if the child hit the correct note
    if (_isPlayAlongMode) {
      final targetNote = widget.musicalRhyme.melodyNotes[_targetMelodyNoteIndex];
      if (key.note == targetNote || (targetNote == 'C5' && key.note == 'C')) {
        setState(() {
          _targetMelodyNoteIndex = (_targetMelodyNoteIndex + 1) % widget.musicalRhyme.melodyNotes.length;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rhyme = widget.musicalRhyme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          rhyme.title,
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleRecital,
            tooltip: _isPlaying ? 'Stop Rhyme' : 'Play Rhyme',
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled_rounded : Icons.volume_up_rounded,
              color: rhyme.themeColor,
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
                // 1. Interactive Musical Stage Card
                _buildMusicalStageCard(rhyme),

                const SizedBox(height: 20),

                // 2. Interactive Rainbow Xylophone (Do-Re-Mi)
                _buildRainbowXylophone(rhyme),

                const SizedBox(height: 20),

                // 3. Rhythm Percussion Pads
                _buildPercussionPads(rhyme),

                const SizedBox(height: 20),

                // 4. Karaoke Lyrical Stanzas
                _buildLyricalStanzas(rhyme),

                const SizedBox(height: 16),

                // 5. Embedded Musical Froggo Companion
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: const FrogAssistantWidget(
                      compact: true,
                      customTip: 'Froggo loves singing rhymes with you! 🐸🎵',
                    ),
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

  /// Top Stage with Rotating Disc, Animated Dancing Equalizer, and Big Sing Button
  Widget _buildMusicalStageCard(MusicalRhyme rhyme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: rhyme.themeColor.withValues(alpha: 0.35),
          width: 2,
        ),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          // Rotating Disc & Dancing Equalizer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rotating Emoji Disc
              RotationTransition(
                turns: _discRotationController,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        rhyme.themeColor.withValues(alpha: 0.3),
                        rhyme.themeColor,
                      ],
                    ),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: rhyme.themeColor.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(rhyme.emoji, style: const TextStyle(fontSize: 36)),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Animated Dancing Equalizer Bars
              _buildDancingEqualizer(rhyme.themeColor),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            rhyme.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle (Exact string needed for tests)
          Text(
            '🎶 Sing along with the words! 🎶',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: rhyme.themeColor,
            ),
          ),

          const SizedBox(height: 6),
          Text(
            '${rhyme.musicalKey} • Melodic Singing 🎼',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // Mode Toggle Pills
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildModePill(
                title: '🎤 Sing Along',
                isSelected: !_isPlayAlongMode,
                onTap: () => setState(() => _isPlayAlongMode = false),
                activeColor: rhyme.themeColor,
              ),
              const SizedBox(width: 8),
              _buildModePill(
                title: '🎹 Play on Xylophone',
                isSelected: _isPlayAlongMode,
                onTap: () => setState(() => _isPlayAlongMode = true),
                activeColor: const Color(0xFF58CC02),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Big Puffy Play/Recite Button (Exact label needed for tests)
          ElevatedButton.icon(
            onPressed: _toggleRecital,
            icon: Icon(
              _isPlaying ? Icons.stop_rounded : Icons.music_note_rounded,
              size: 24,
            ),
            label: Text(_isPlaying ? 'Stop Rhyme' : 'Sing / Play Rhyme 🎵'),
            style: ElevatedButton.styleFrom(
              backgroundColor: rhyme.themeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: const Size(220, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModePill({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// 8 Animated Equalizer Bars that dance dynamically
  Widget _buildDancingEqualizer(Color themeColor) {
    return AnimatedBuilder(
      animation: _equalizerController,
      builder: (context, child) {
        final anim = _equalizerController.value;

        return Row(
          children: List.generate(8, (i) {
            final offset = (i * 0.4) + (anim * math.pi * 2);
            final heightFactor = _isPlaying
                ? (0.3 + 0.7 * math.sin(offset).abs())
                : 0.15;
            final barHeight = 12.0 + (32.0 * heightFactor);

            return Container(
              width: 5,
              height: barHeight,
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.5 + 0.5 * heightFactor),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        );
      },
    );
  }

  /// Interactive Rainbow 8-Key Kids Xylophone (Do-Re-Mi)
  Widget _buildRainbowXylophone(MusicalRhyme rhyme) {
    final targetNote = _isPlayAlongMode && widget.musicalRhyme.melodyNotes.isNotEmpty
        ? widget.musicalRhyme.melodyNotes[_targetMelodyNoteIndex]
        : null;
    final targetSyllable = _isPlayAlongMode && widget.musicalRhyme.melodySyllables.isNotEmpty
        ? widget.musicalRhyme.melodySyllables[_targetMelodyNoteIndex]
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF58CC02).withValues(alpha: 0.35),
          width: 1.8,
        ),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('🎹', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isPlayAlongMode
                      ? 'Follow the Star to Play! ⭐'
                      : 'Rainbow Xylophone (Do-Re-Mi) 🎶',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (_isPlayAlongMode && targetSyllable != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD900).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFFB300), width: 1.5),
                  ),
                  child: Text(
                    'Sing: "$targetSyllable"',
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB78103),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // 8 Rainbow Xylophone Keys
          SizedBox(
            height: 96,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: RhymeMusicService.rainbowKeys.map((k) {
                final isTarget = _isPlayAlongMode &&
                    (k.note == targetNote || (targetNote == 'C5' && k.note == 'C'));

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: GestureDetector(
                      onTap: () => _onTapXylophoneKey(k),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: k.color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isTarget ? Colors.white : Colors.black12,
                            width: isTarget ? 3 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isTarget
                                  ? const Color(0xFFFFD900).withValues(alpha: 0.8)
                                  : k.color.withValues(alpha: 0.35),
                              blurRadius: isTarget ? 10 : 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isTarget)
                              const Text('⭐', style: TextStyle(fontSize: 14))
                            else
                              Text(
                                k.note,
                                style: GoogleFonts.fredoka(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            const SizedBox(height: 2),
                            Text(
                              k.solfege,
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withValues(alpha: 0.95),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Interactive Rhythm Percussion Pads (Drum, Chimes, Horn, Clap, Frog)
  Widget _buildPercussionPads(MusicalRhyme rhyme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFF2ECE0),
          width: 1.5,
        ),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🥁', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Rhythm Percussion Pads',
                  style: GoogleFonts.fredoka(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Tap to jam! 🎶',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.forestGreenDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPadButton('🥁', 'Drum', () => _musicService.playPercussion('drum')),
              _buildPadButton('🔔', 'Chimes', () => _musicService.playPercussion('bell')),
              _buildPadButton('📯', 'Horn', () => _musicService.playPercussion('horn')),
              _buildPadButton('👏', 'Clap', () => _musicService.playPercussion('clap')),
              _buildPadButton('🐸', 'Ribbit', () => _musicService.playPercussion('frog')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPadButton(String emoji, String label, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FCF2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF58CC02).withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF132A13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Karaoke Lyrical Stanzas with Bouncing Active Indicator
  Widget _buildLyricalStanzas(MusicalRhyme rhyme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(rhyme.scores.length, (index) {
        final score = rhyme.scores[index];
        final isActive = _activeVerseIndex == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isActive
                ? rhyme.themeColor.withValues(alpha: 0.12)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive
                  ? rhyme.themeColor
                  : const Color(0xFFF2ECE0),
              width: isActive ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? rhyme.themeColor.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: isActive ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _singSingleVerse(index),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isActive)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        'Singing Now 🎶',
                        style: GoogleFonts.fredoka(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: rhyme.themeColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('⭐', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                if (isActive) const SizedBox(height: 6),

                Text(
                  score.lyrics,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
                    color: isActive ? const Color(0xFF132A13) : AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.music_note_rounded,
                      size: 14,
                      color: rhyme.themeColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Notes: ${score.notes.take(6).join(" • ")}',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: rhyme.themeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
