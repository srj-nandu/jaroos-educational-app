import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';

class AnimalItem {
  final String name;
  final String emoji;
  final String sound;
  final String habitat;
  final String category;
  final String funFact;
  final Color themeColor;

  const AnimalItem({
    required this.name,
    required this.emoji,
    required this.sound,
    required this.habitat,
    required this.category,
    required this.funFact,
    required this.themeColor,
  });
}

/// Interactive Animals Learning Module for JAROOS.
/// Teaches animal names, habitat, onomatopoeic sounds, and fun animal facts.
class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  String _selectedCategory = 'All';

  static const List<AnimalItem> _animalsList = [
    AnimalItem(name: 'Lion', emoji: '🦁', sound: 'Roar!', habitat: 'Savannah', category: 'Wild', funFact: 'A lion\'s roar can be heard from up to 5 miles away!', themeColor: AppColors.secondary),
    AnimalItem(name: 'Elephant', emoji: '🐘', sound: 'Pawoo!', habitat: 'Jungle & Plains', category: 'Wild', funFact: 'Elephants use their long trunks to drink water and greet friends!', themeColor: AppColors.primary),
    AnimalItem(name: 'Monkey', emoji: '🐒', sound: 'Ooh-ooh Aah-aah!', habitat: 'Rainforest Canopy', category: 'Wild', funFact: 'Monkeys use their tails for balance while swinging across tall trees!', themeColor: AppColors.coral),
    AnimalItem(name: 'Tiger', emoji: '🐯', sound: 'Growl!', habitat: 'Dense Forest', category: 'Wild', funFact: 'Tigers love swimming and cooling off in refreshing jungle streams!', themeColor: Color(0xFFFF9800)),
    AnimalItem(name: 'Dog', emoji: '🐶', sound: 'Woof Woof!', habitat: 'Home & Backyard', category: 'Farm', funFact: 'Dogs wag their tails happily when they see their favorite friends!', themeColor: Color(0xFF8D6E63)),
    AnimalItem(name: 'Cat', emoji: '🐱', sound: 'Meow Meow!', habitat: 'Cozy Home', category: 'Farm', funFact: 'Cats can jump up to 6 times their own height!', themeColor: AppColors.candyPink),
    AnimalItem(name: 'Cow', emoji: '🐮', sound: 'Moo Moo!', habitat: 'Sunny Meadow', category: 'Farm', funFact: 'Cows give us fresh milk that helps grow strong bones and teeth!', themeColor: AppColors.mintGreen),
    AnimalItem(name: 'Sheep', emoji: '🐑', sound: 'Baa Baa!', habitat: 'Green Pastures', category: 'Farm', funFact: 'Sheep give us soft warm wool used to make winter sweaters!', themeColor: Color(0xFF78909C)),
    AnimalItem(name: 'Horse', emoji: '🐴', sound: 'Neigh!', habitat: 'Farm & Open Plains', category: 'Farm', funFact: 'Horses can sleep both lying down and standing straight up!', themeColor: Color(0xFFA1887F)),
    AnimalItem(name: 'Duck', emoji: '🦆', sound: 'Quack Quack!', habitat: 'Freshwater Ponds', category: 'Water', funFact: 'Duck feathers are completely waterproof so they stay dry swimming!', themeColor: Color(0xFF26A69A)),
    AnimalItem(name: 'Penguin', emoji: '🐧', sound: 'Honk Honk!', habitat: 'Icy Antarctica', category: 'Water', funFact: 'Penguins cannot fly in air, but they glide gracefully underwater!', themeColor: Color(0xFF37474F)),
    AnimalItem(name: 'Dolphin', emoji: '🐬', sound: 'Click-Whistle!', habitat: 'Deep Ocean', category: 'Water', funFact: 'Dolphins are smart ocean friends that communicate with clicks!', themeColor: Color(0xFF0288D1)),
  ];

  List<AnimalItem> get _filteredAnimals {
    if (_selectedCategory == 'All') return _animalsList;
    return _animalsList.where((a) => a.category == _selectedCategory).toList();
  }

  void _speakAnimal(AnimalItem item) {
    final tts = Provider.of<TtsService>(context, listen: false);
    tts.speak('This is a ${item.name}! The ${item.name} lives in the ${item.habitat}, and says ${item.sound}');
  }

  void _showAnimalDetail(AnimalItem item) {
    _speakAnimal(item);

    final learningProvider = Provider.of<LearningProvider>(context, listen: false);
    learningProvider.completeLesson(AppConstants.moduleAnimals, coinReward: 5);

    showDialog(
      context: context,
      builder: (ctx) {
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
                // Animal Avatar Badge
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: item.themeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: item.themeColor.withValues(alpha: 0.4),
                      width: 2.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: item.themeColor.withValues(alpha: 0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 64),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Name & Sound Tag
                Text(
                  item.name,
                  style: GoogleFonts.fredoka(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.themeColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Sound: "${item.sound}"',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: item.themeColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Habitat Info
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
                      const Text('🏡', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(
                        'Habitat: ${item.habitat}',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
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
                          item.funFact,
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
                const SizedBox(height: 18),

                // Speak Audio Button
                ElevatedButton.icon(
                  onPressed: () => _speakAnimal(item),
                  icon: const Icon(Icons.volume_up_rounded, size: 22),
                  label: Text('Hear ${item.name}\'s Sound'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.themeColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
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
          'Animal Friends 🦁',
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
              // Category Filter Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: ['All', 'Wild', 'Farm', 'Water'].map((category) {
                      final isSelected = category == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            category == 'All'
                                ? 'All Animals'
                                : (category == 'Wild'
                                    ? 'Wild 🦁'
                                    : (category == 'Farm' ? 'Farm 🐮' : 'Water 🐬')),
                          ),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedCategory = category),
                          selectedColor: AppColors.secondary,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isSelected ? AppColors.secondaryDark : const Color(0xFFEADBCE),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Animals Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 10,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredAnimals.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: isTablet ? 1.05 : 0.94,
                  ),
                  itemBuilder: (context, index) {
                    final item = _filteredAnimals[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showAnimalDetail(item),
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: item.themeColor.withValues(alpha: 0.35),
                              width: 1.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: item.themeColor.withValues(alpha: 0.14),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.emoji,
                                style: const TextStyle(fontSize: 40),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.name,
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.sound,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: item.themeColor,
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
