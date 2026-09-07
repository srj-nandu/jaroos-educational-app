import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';

class AlphabetItem {
  final String letter;
  final String word;
  final String emoji;
  final String funFact;
  final Color cardColor;

  const AlphabetItem({
    required this.letter,
    required this.word,
    required this.emoji,
    required this.funFact,
    required this.cardColor,
  });
}

/// Interactive Alphabet Learning Module for JAROOS.
/// Displays A to Z with phonic pronunciation, giant animated letters,
/// real-world association, and educational fun facts.
class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  static const List<AlphabetItem> _alphabetList = [
    AlphabetItem(letter: 'A', word: 'Apple', emoji: '🍎', funFact: 'Apples float in water because 25% of their volume is air!', cardColor: Color(0xFFFFEBEE)),
    AlphabetItem(letter: 'B', word: 'Ball', emoji: '⚽', funFact: 'A ball is a perfect sphere that loves to bounce high!', cardColor: Color(0xFFE3F2FD)),
    AlphabetItem(letter: 'C', word: 'Cat', emoji: '🐱', funFact: 'Cats can make over 100 different cheerful sounds!', cardColor: Color(0xFFFFF8E1)),
    AlphabetItem(letter: 'D', word: 'Dog', emoji: '🐶', funFact: 'Dogs are loyal friends with an incredible sense of smell!', cardColor: Color(0xFFE8F5E9)),
    AlphabetItem(letter: 'E', word: 'Elephant', emoji: '🐘', funFact: 'Elephants are the largest living land animals on Earth!', cardColor: Color(0xFFF3E5F5)),
    AlphabetItem(letter: 'F', word: 'Fish', emoji: '🐟', funFact: 'Fish breathe underwater using special organs called gills!', cardColor: Color(0xFFE0F7FA)),
    AlphabetItem(letter: 'G', word: 'Giraffe', emoji: '🦒', funFact: 'Giraffes have very long necks to reach tall green leaves!', cardColor: Color(0xFFFFF3E0)),
    AlphabetItem(letter: 'H', word: 'Hat', emoji: '🎩', funFact: 'Hats protect our heads and look wonderfully stylish!', cardColor: Color(0xFFEDE7F6)),
    AlphabetItem(letter: 'I', word: 'Ice Cream', emoji: '🍦', funFact: 'Ice cream is a cool sweet treat loved all around the world!', cardColor: Color(0xFFFFEBEE)),
    AlphabetItem(letter: 'J', word: 'Juice', emoji: '🧃', funFact: 'Fresh fruit juice is delicious and full of healthy vitamins!', cardColor: Color(0xFFFFFDE7)),
    AlphabetItem(letter: 'K', word: 'Kite', emoji: '🪁', funFact: 'Kites soar up high in the sky when gentle winds blow!', cardColor: Color(0xFFE1F5FE)),
    AlphabetItem(letter: 'L', word: 'Lion', emoji: '🦁', funFact: 'Lions are brave big cats known as kings of the jungle!', cardColor: Color(0xFFFFF8E1)),
    AlphabetItem(letter: 'M', word: 'Monkey', emoji: '🐒', funFact: 'Monkeys love swinging playfully from tree to tree!', cardColor: Color(0xFFEFEBE9)),
    AlphabetItem(letter: 'N', word: 'Nest', emoji: '🪺', funFact: 'Birds weave cozy nests out of twigs to keep baby chicks safe!', cardColor: Color(0xFFE8EAF6)),
    AlphabetItem(letter: 'O', word: 'Orange', emoji: '🍊', funFact: 'Oranges are round citrus fruits bursting with Vitamin C!', cardColor: Color(0xFFFFF3E0)),
    AlphabetItem(letter: 'P', word: 'Panda', emoji: '🐼', funFact: 'Giant pandas love munching on crunchy green bamboo shoots!', cardColor: Color(0xFFECEFF1)),
    AlphabetItem(letter: 'Q', word: 'Queen', emoji: '👑', funFact: 'A queen wears a sparkling golden crown with colorful gems!', cardColor: Color(0xFFF3E5F5)),
    AlphabetItem(letter: 'R', word: 'Rainbow', emoji: '🌈', funFact: 'A rainbow displays 7 gorgeous colors when sun meets rain!', cardColor: Color(0xFFE0F2F1)),
    AlphabetItem(letter: 'S', word: 'Sun', emoji: '☀️', funFact: 'The Sun gives our planet Earth warm light and energy!', cardColor: Color(0xFFFFFDE7)),
    AlphabetItem(letter: 'T', word: 'Tiger', emoji: '🐯', funFact: 'Every tiger has a unique pattern of stripes like fingerprints!', cardColor: Color(0xFFFFE0B2)),
    AlphabetItem(letter: 'U', word: 'Umbrella', emoji: '☂️', funFact: 'Umbrellas shield us from raindrops so we stay cozy and dry!', cardColor: Color(0xFFEDE7F6)),
    AlphabetItem(letter: 'V', word: 'Violin', emoji: '🎻', funFact: 'Violins produce sweet, soaring musical melodies!', cardColor: Color(0xFFFFF8E1)),
    AlphabetItem(letter: 'W', word: 'Watermelon', emoji: '🍉', funFact: 'Watermelons are 92% refreshing water on hot sunny days!', cardColor: Color(0xFFFFEBEE)),
    AlphabetItem(letter: 'X', word: 'Xylophone', emoji: '🎼', funFact: 'Xylophones create delightful musical bells when struck!', cardColor: Color(0xFFE8F5E9)),
    AlphabetItem(letter: 'Y', word: 'Yacht', emoji: '⛵', funFact: 'A yacht is a graceful sailing boat that glides across the sea!', cardColor: Color(0xFFE0F7FA)),
    AlphabetItem(letter: 'Z', word: 'Zebra', emoji: '🦓', funFact: 'Zebras have black and white stripes to keep them cool!', cardColor: Color(0xFFF5F5F5)),
  ];

  void _speakLetter(AlphabetItem item) {
    final tts = Provider.of<TtsService>(context, listen: false);
    tts.speak('${item.letter}. ${item.letter} for ${item.word}!');
  }

  void _showLetterDetail(int index) {
    var currentIndex = index;
    final item = _alphabetList[currentIndex];
    _speakLetter(item);

    final learningProvider = Provider.of<LearningProvider>(context, listen: false);
    learningProvider.completeLesson(AppConstants.moduleAlphabet, coinReward: 5);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final activeItem = _alphabetList[currentIndex];

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Giant Character Card
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: activeItem.cardColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            activeItem.letter,
                            style: GoogleFonts.fredoka(
                              fontSize: 64,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          Text(
                            activeItem.emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Word
                    Text(
                      '${activeItem.letter} for ${activeItem.word}',
                      style: GoogleFonts.fredoka(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Fun Fact Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F7F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEADBCE)),
                      ),
                      child: Row(
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              activeItem.funFact,
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Pronounce Audio Button
                    ElevatedButton.icon(
                      onPressed: () => _speakLetter(activeItem),
                      icon: const Icon(Icons.volume_up_rounded, size: 24),
                      label: const Text('Hear Pronunciation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Previous / Next Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: currentIndex > 0
                              ? () {
                                  setDialogState(() {
                                    currentIndex--;
                                  });
                                  _speakLetter(_alphabetList[currentIndex]);
                                }
                              : null,
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text('Prev'),
                        ),
                        Text(
                          '${currentIndex + 1} / ${_alphabetList.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: currentIndex < _alphabetList.length - 1
                              ? () {
                                  setDialogState(() {
                                    currentIndex++;
                                  });
                                  _speakLetter(_alphabetList[currentIndex]);
                                }
                              : null,
                          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                          label: const Text('Next'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);
    final columns = ResponsiveUtil.getLearningGridColumns(context);
    final isTablet = ResponsiveUtil.isTablet(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alphabet (A to Z) 🔤',
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
          child: Column(
            children: [
              // Instruction Banner
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppColors.softShadow,
                    border: Border.all(color: const Color(0xFFF2ECE0)),
                  ),
                  child: Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tap any letter to hear its sound and learn its word!',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Alphabet Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 12,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _alphabetList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: isTablet ? 1.05 : 0.92,
                  ),
                  itemBuilder: (context, index) {
                    final item = _alphabetList[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showLetterDetail(index),
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              width: 1.6,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Giant Letter
                              Text(
                                item.letter,
                                style: GoogleFonts.fredoka(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Emoji Illustration
                              Text(
                                item.emoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(height: 4),

                              // Word
                              Text(
                                item.word,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
