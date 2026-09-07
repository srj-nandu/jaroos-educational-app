import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';

class ShapeItem {
  final String name;
  final String sidesDescription;
  final String emoji;
  final String realWorldExample;
  final String funFact;
  final Color shapeColor;

  const ShapeItem({
    required this.name,
    required this.sidesDescription,
    required this.emoji,
    required this.realWorldExample,
    required this.funFact,
    required this.shapeColor,
  });
}

/// Interactive Shapes Learning Module for JAROOS.
/// Teaches geometric shapes, sides, vertices, and real-world associations.
class ShapesScreen extends StatefulWidget {
  const ShapesScreen({super.key});

  @override
  State<ShapesScreen> createState() => _ShapesScreenState();
}

class _ShapesScreenState extends State<ShapesScreen> {
  static const List<ShapeItem> _shapesList = [
    ShapeItem(
      name: 'Circle',
      sidesDescription: '0 Sides • Completely Round',
      emoji: '⭕',
      realWorldExample: 'Coins, Wall Clocks & Car Wheels',
      funFact: 'A circle is perfectly symmetrical from every angle!',
      shapeColor: AppColors.primaryDark,
    ),
    ShapeItem(
      name: 'Square',
      sidesDescription: '4 Equal Sides • 4 Corners',
      emoji: '🟧',
      realWorldExample: 'Building Blocks, Dice & Windows',
      funFact: 'All 4 straight sides of a square are the exact same length!',
      shapeColor: AppColors.secondaryDark,
    ),
    ShapeItem(
      name: 'Triangle',
      sidesDescription: '3 Straight Sides • 3 Corners',
      emoji: '🔺',
      realWorldExample: 'Pizza Slices, Roofs & Traffic Cones',
      funFact: 'Triangles are one of the strongest shapes used in bridge design!',
      shapeColor: AppColors.candyPink,
    ),
    ShapeItem(
      name: 'Rectangle',
      sidesDescription: '4 Sides (2 Long & 2 Short)',
      emoji: '🚪',
      realWorldExample: 'Doors, Storybooks & Smartphone Screens',
      funFact: 'A rectangle has opposite sides that are parallel and equal!',
      shapeColor: AppColors.mintGreen,
    ),
    ShapeItem(
      name: 'Star',
      sidesDescription: '5 Points • 10 Sides',
      emoji: '⭐',
      realWorldExample: 'Sea Stars, Night Sky & Reward Badges',
      funFact: 'Stars twinkle because their light travels through Earth\'s moving air!',
      shapeColor: Color(0xFFFFB300),
    ),
    ShapeItem(
      name: 'Heart',
      sidesDescription: '2 Curved Lobes • 1 Point',
      emoji: '💖',
      realWorldExample: 'Valentine Cards, Stickers & Strawberries',
      funFact: 'The heart shape is a universal symbol of love and friendship!',
      shapeColor: Color(0xFFE91E63),
    ),
    ShapeItem(
      name: 'Diamond',
      sidesDescription: '4 Slanted Sides (Rhombus)',
      emoji: '💎',
      realWorldExample: 'Flying Kites, Playing Cards & Road Signs',
      funFact: 'A diamond is like a square standing on its pointy tip!',
      shapeColor: AppColors.lavender,
    ),
    ShapeItem(
      name: 'Oval',
      sidesDescription: '0 Sides • Stretched Circle',
      emoji: '🥚',
      realWorldExample: 'Bird Eggs, Mirrors & Watermelons',
      funFact: 'Planets orbit around the Sun in an oval path called an ellipse!',
      shapeColor: Color(0xFF26A69A),
    ),
  ];

  void _speakShape(ShapeItem item) {
    final tts = Provider.of<TtsService>(context, listen: false);
    tts.speak('This is a ${item.name}. ${item.sidesDescription}. Like ${item.realWorldExample}.');
  }

  void _showShapeDetail(int index) {
    var currentIndex = index;
    final item = _shapesList[currentIndex];
    _speakShape(item);

    final learningProvider = Provider.of<LearningProvider>(context, listen: false);
    learningProvider.completeLesson(AppConstants.moduleShapes, coinReward: 5);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final activeItem = _shapesList[currentIndex];

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
                    // Giant Geometric Shape Showcase
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: activeItem.shapeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: activeItem.shapeColor.withValues(alpha: 0.4),
                          width: 2.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: activeItem.shapeColor.withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          activeItem.emoji,
                          style: const TextStyle(fontSize: 64),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    Text(
                      activeItem.name,
                      style: GoogleFonts.fredoka(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Sides Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: activeItem.shapeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        activeItem.sidesDescription,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: activeItem.shapeColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Real-World Examples
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
                          const Text('🔍', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Real-World Examples:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  activeItem.realWorldExample,
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Fun Fact
                    Container(
                      width: double.infinity,
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

                    // Pronounce Button
                    ElevatedButton.icon(
                      onPressed: () => _speakShape(activeItem),
                      icon: const Icon(Icons.volume_up_rounded, size: 22),
                      label: Text('Pronounce "${activeItem.name}"'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeItem.shapeColor,
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
                                  _speakShape(_shapesList[currentIndex]);
                                }
                              : null,
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text('Prev'),
                        ),
                        Text(
                          '${currentIndex + 1} / ${_shapesList.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: currentIndex < _shapesList.length - 1
                              ? () {
                                  setDialogState(() {
                                    currentIndex++;
                                  });
                                  _speakShape(_shapesList[currentIndex]);
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
          'Shapes & Geometry 🔺',
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
                      const Text('🔷', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Discover circles, squares, stars and count their sides!',
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

              // Shapes Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 12,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _shapesList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: isTablet ? 1.05 : 0.94,
                  ),
                  itemBuilder: (context, index) {
                    final item = _shapesList[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showShapeDetail(index),
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: item.shapeColor.withValues(alpha: 0.35),
                              width: 1.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: item.shapeColor.withValues(alpha: 0.14),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Shape Emoji Icon
                              Text(
                                item.emoji,
                                style: const TextStyle(fontSize: 42),
                              ),
                              const SizedBox(height: 6),

                              // Name
                              Text(
                                item.name,
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),

                              // Sides preview
                              Text(
                                item.sidesDescription.split('•').first.trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: item.shapeColor,
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
