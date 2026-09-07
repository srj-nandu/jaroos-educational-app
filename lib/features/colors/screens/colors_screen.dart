import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';

class ColorItem {
  final String name;
  final Color color;
  final String emoji;
  final String objects;
  final String mixingTip;
  final bool isDark;

  const ColorItem({
    required this.name,
    required this.color,
    required this.emoji,
    required this.objects,
    required this.mixingTip,
    this.isDark = false,
  });
}

/// Interactive Colors Learning Module for JAROOS.
/// Teaches early learners about primary, secondary, and rainbow colors
/// using large visual cards, real-world objects, and color mixing tips.
class ColorsScreen extends StatefulWidget {
  const ColorsScreen({super.key});

  @override
  State<ColorsScreen> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {
  static const List<ColorItem> _colorsList = [
    ColorItem(name: 'Red', color: Color(0xFFE53935), emoji: '🍎', objects: 'Apples, Strawberries & Fire Trucks', mixingTip: 'Primary Color! Mix Red with Yellow to create Orange.', isDark: true),
    ColorItem(name: 'Blue', color: Color(0xFF1E88E5), emoji: '🌊', objects: 'The Sky, Ocean Waves & Blueberries', mixingTip: 'Primary Color! Mix Blue with Yellow to create Green.', isDark: true),
    ColorItem(name: 'Yellow', color: Color(0xFFFFD54F), emoji: '☀️', objects: 'The Warm Sun, Bananas & Sunflowers', mixingTip: 'Primary Color! Mix Yellow with Red to create Orange.', isDark: false),
    ColorItem(name: 'Green', color: Color(0xFF43A047), emoji: '🍃', objects: 'Forest Trees, Frogs & Fresh Grass', mixingTip: 'Magic Recipe: Blue + Yellow = Green!', isDark: true),
    ColorItem(name: 'Orange', color: Color(0xFFFB8C00), emoji: '🍊', objects: 'Juicy Oranges, Carrots & Monarch Butterflies', mixingTip: 'Magic Recipe: Red + Yellow = Orange!', isDark: true),
    ColorItem(name: 'Purple', color: Color(0xFF8E24AA), emoji: '🍇', objects: 'Sweet Grapes, Violets & Royal Robes', mixingTip: 'Magic Recipe: Red + Blue = Purple!', isDark: true),
    ColorItem(name: 'Pink', color: Color(0xFFFF6584), emoji: '🌸', objects: 'Flamingos, Bubblegum & Cherry Blossoms', mixingTip: 'Magic Recipe: Red + White = Pink!', isDark: false),
    ColorItem(name: 'Brown', color: Color(0xFF6D4C41), emoji: '🐻', objects: 'Teddy Bears, Delicious Chocolate & Tree Bark', mixingTip: 'The earthy warm color of nature and soil.', isDark: true),
    ColorItem(name: 'White', color: Color(0xFFFAFAFA), emoji: '☁️', objects: 'Fluffy Clouds, Winter Snow & Fresh Milk', mixingTip: 'The pure, bright color of morning sunlight.', isDark: false),
    ColorItem(name: 'Black', color: Color(0xFF263238), emoji: '🌌', objects: 'Night Sky, Sleek Panthers & Shadows', mixingTip: 'The deep color of mysterious outer space.', isDark: true),
  ];

  void _speakColor(ColorItem item) {
    final tts = Provider.of<TtsService>(context, listen: false);
    tts.speak('Color ${item.name}! Like ${item.objects}.');
  }

  void _showColorDetail(int index) {
    var currentIndex = index;
    final item = _colorsList[currentIndex];
    _speakColor(item);

    final learningProvider = Provider.of<LearningProvider>(context, listen: false);
    learningProvider.completeLesson(AppConstants.moduleColors, coinReward: 5);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final activeItem = _colorsList[currentIndex];

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
                    // Giant Visual Color Splash
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: activeItem.color,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.1),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: activeItem.color.withValues(alpha: 0.4),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          activeItem.emoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Color Name
                    Text(
                      activeItem.name,
                      style: GoogleFonts.fredoka(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Real-world associations
                    Text(
                      activeItem.objects,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Color Mixing Tip
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F7F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEADBCE)),
                      ),
                      child: Row(
                        children: [
                          const Text('🎨', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              activeItem.mixingTip,
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pronunciation Button
                    ElevatedButton.icon(
                      onPressed: () => _speakColor(activeItem),
                      icon: const Icon(Icons.volume_up_rounded, size: 22),
                      label: Text('Pronounce "${activeItem.name}"'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeItem.color == const Color(0xFFFAFAFA)
                            ? AppColors.primaryDark
                            : activeItem.color,
                        foregroundColor: activeItem.isDark ? Colors.white : AppColors.textPrimary,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Prev / Next Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: currentIndex > 0
                              ? () {
                                  setDialogState(() {
                                    currentIndex--;
                                  });
                                  _speakColor(_colorsList[currentIndex]);
                                }
                              : null,
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text('Prev'),
                        ),
                        Text(
                          '${currentIndex + 1} / ${_colorsList.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: currentIndex < _colorsList.length - 1
                              ? () {
                                  setDialogState(() {
                                    currentIndex++;
                                  });
                                  _speakColor(_colorsList[currentIndex]);
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
          'Colors Palette 🎨',
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
                      const Text('🌈', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Explore bright colors, what they look like, and how to mix them!',
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

              // Colors Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 12,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _colorsList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: isTablet ? 1.05 : 0.94,
                  ),
                  itemBuilder: (context, index) {
                    final item = _colorsList[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showColorDetail(index),
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: item.color.withValues(alpha: 0.35),
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: item.color.withValues(alpha: 0.18),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Color Swatch Disc
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: item.color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: item.color.withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    item.emoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Color Name
                              Text(
                                item.name,
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),

                              // Real-world item teaser
                              Text(
                                item.objects.split(',').first,
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
