import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';

class NumberItem {
  final int number;
  final String word;
  final String emoji;
  final String objectName;
  final String funFact;

  const NumberItem({
    required this.number,
    required this.word,
    required this.emoji,
    required this.objectName,
    required this.funFact,
  });
}

/// Interactive Numbers Learning Module (1 to 20) for JAROOS.
/// Features bold numerals, written words, visual count objects,
/// and interactive audio counting.
class NumbersScreen extends StatefulWidget {
  const NumbersScreen({super.key});

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  static const List<NumberItem> _numbersList = [
    NumberItem(number: 1, word: 'One', emoji: '🌟', objectName: 'Star', funFact: 'The Sun is the single brightest star in our solar system!'),
    NumberItem(number: 2, word: 'Two', emoji: '👟', objectName: 'Shoes', funFact: 'We have 2 eyes, 2 ears, 2 hands, and 2 feet!'),
    NumberItem(number: 3, word: 'Three', emoji: '🔺', objectName: 'Triangles', funFact: 'A triangle always has exactly 3 straight sides!'),
    NumberItem(number: 4, word: 'Four', emoji: '🐾', objectName: 'Paws', funFact: 'Most friendly animals like dogs and cats have 4 paws!'),
    NumberItem(number: 5, word: 'Five', emoji: '🖐️', objectName: 'Fingers', funFact: 'We have 5 wonderful fingers on each of our hands!'),
    NumberItem(number: 6, word: 'Six', emoji: '🐝', objectName: 'Bees', funFact: 'All insects have 6 legs and love buzzing flowers!'),
    NumberItem(number: 7, word: 'Seven', emoji: '🌈', objectName: 'Colors', funFact: 'There are 7 days in a week and 7 colors in a rainbow!'),
    NumberItem(number: 8, word: 'Eight', emoji: '🐙', objectName: 'Octopus', funFact: 'An octopus has 8 flexible tentacles and 3 hearts!'),
    NumberItem(number: 9, word: 'Nine', emoji: '🪐', objectName: 'Planets', funFact: 'Nine is the largest single-digit number in math!'),
    NumberItem(number: 10, word: 'Ten', emoji: '🎈', objectName: 'Balloons', funFact: 'We have 10 toes on our two happy feet!'),
    NumberItem(number: 11, word: 'Eleven', emoji: '⚽', objectName: 'Players', funFact: 'A soccer team has exactly 11 players on the field!'),
    NumberItem(number: 12, word: 'Twelve', emoji: '🍩', objectName: 'Donuts', funFact: 'A set of 12 yummy donuts is called a dozen!'),
    NumberItem(number: 13, word: 'Thirteen', emoji: '🧁', objectName: 'Cupcakes', funFact: 'Thirteen is also known as a baker\'s dozen!'),
    NumberItem(number: 14, word: 'Fourteen', emoji: '💖', objectName: 'Hearts', funFact: 'There are 14 days in two full weeks (a fortnight)!'),
    NumberItem(number: 15, word: 'Fifteen', emoji: '🍓', objectName: 'Strawberries', funFact: 'Fifteen minutes is a quarter of an entire hour!'),
    NumberItem(number: 16, word: 'Sixteen', emoji: '🚗', objectName: 'Toy Cars', funFact: 'Sixteen ounces makes one full pound in weight!'),
    NumberItem(number: 17, word: 'Seventeen', emoji: '🦋', objectName: 'Butterflies', funFact: 'Seventeen is a special prime number in mathematics!'),
    NumberItem(number: 18, word: 'Eighteen', emoji: '🎨', objectName: 'Color Pencils', funFact: 'An 18-wheeler is a giant truck with 18 wheels!'),
    NumberItem(number: 19, word: 'Nineteen', emoji: '🚀', objectName: 'Rockets', funFact: 'Nineteen is the last of the exciting teen numbers!'),
    NumberItem(number: 20, word: 'Twenty', emoji: '👑', objectName: 'Golden Coins', funFact: 'You have completed counting all the way up to 20!'),
  ];

  void _speakNumber(NumberItem item) {
    final tts = Provider.of<TtsService>(context, listen: false);
    tts.speak('Number ${item.number}. ${item.word}! Count ${item.number} ${item.objectName}.');
  }

  void _showNumberDetail(int index) {
    var currentIndex = index;
    final item = _numbersList[currentIndex];
    _speakNumber(item);

    final learningProvider = Provider.of<LearningProvider>(context, listen: false);
    learningProvider.completeLesson(AppConstants.moduleNumbers, coinReward: 5);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final activeItem = _numbersList[currentIndex];

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Big Numeral Container
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.secondary, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondaryDark.withValues(alpha: 0.2),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${activeItem.number}',
                            style: GoogleFonts.fredoka(
                              fontSize: 68,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFB78103),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Word Title
                      Text(
                        'Number ${activeItem.word}',
                        style: GoogleFonts.fredoka(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Counting Visualizer
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F7F2),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFEADBCE)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Count the ${activeItem.objectName}:',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 6,
                              runSpacing: 6,
                              children: List.generate(
                                activeItem.number,
                                (i) => Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    activeItem.emoji,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Fun Fact
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                activeItem.funFact,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Pronounce Audio Button
                      ElevatedButton.icon(
                        onPressed: () => _speakNumber(activeItem),
                        icon: const Icon(Icons.volume_up_rounded, size: 22),
                        label: const Text('Hear Pronunciation'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryDark,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Navigation Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton.icon(
                            onPressed: currentIndex > 0
                                ? () {
                                    setDialogState(() {
                                      currentIndex--;
                                    });
                                    _speakNumber(_numbersList[currentIndex]);
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_back_rounded, size: 18),
                            label: const Text('Prev'),
                          ),
                          Text(
                            '${currentIndex + 1} / ${_numbersList.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: currentIndex < _numbersList.length - 1
                                ? () {
                                    setDialogState(() {
                                      currentIndex++;
                                    });
                                    _speakNumber(_numbersList[currentIndex]);
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
          'Numbers (1 to 20) 🔢',
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
                      const Text('🔢', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tap any number to count its items and hear the voice!',
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

              // Numbers Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 12,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _numbersList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: isTablet ? 1.05 : 0.92,
                  ),
                  itemBuilder: (context, index) {
                    final item = _numbersList[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showNumberDetail(index),
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: AppColors.secondary.withValues(alpha: 0.4),
                              width: 1.6,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondaryDark.withValues(alpha: 0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Number Digits
                              Text(
                                '${item.number}',
                                style: GoogleFonts.fredoka(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFB78103),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Word
                              Text(
                                item.word,
                                style: GoogleFonts.fredoka(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Object Representation
                              Text(
                                '${item.emoji} ${item.objectName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
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
