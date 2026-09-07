import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';

class FoodItem {
  final String name;
  final String emoji;
  final String category;
  final String taste;
  final String superpower;
  final Color themeColor;

  const FoodItem({
    required this.name,
    required this.emoji,
    required this.category,
    required this.taste,
    required this.superpower,
    required this.themeColor,
  });
}

/// Interactive Fruits & Vegetables Learning Module for JAROOS.
/// Teaches healthy eating, taste profiles, nutritional superpowers,
/// and category distinction (Fruits vs Vegetables).
class FruitsScreen extends StatefulWidget {
  const FruitsScreen({super.key});

  @override
  State<FruitsScreen> createState() => _FruitsScreenState();
}

class _FruitsScreenState extends State<FruitsScreen> {
  String _selectedFilter = 'All';

  static const List<FoodItem> _foodList = [
    FoodItem(name: 'Apple', emoji: '🍎', category: 'Fruit', taste: 'Sweet & Crunchy', superpower: 'Rich in Vitamin C and fiber for a healthy tummy!', themeColor: Color(0xFFE53935)),
    FoodItem(name: 'Banana', emoji: '🍌', category: 'Fruit', taste: 'Creamy & Sweet', superpower: 'Full of potassium for instant physical playground energy!', themeColor: Color(0xFFFBC02D)),
    FoodItem(name: 'Orange', emoji: '🍊', category: 'Fruit', taste: 'Juicy & Tangy', superpower: 'High in Vitamin C to protect against coughs and sneezes!', themeColor: Color(0xFFFB8C00)),
    FoodItem(name: 'Mango', emoji: '🥭', category: 'Fruit', taste: 'Tropical & Luscious', superpower: 'The King of Fruits, loaded with Vitamin A for glowing health!', themeColor: Color(0xFFFFA000)),
    FoodItem(name: 'Grapes', emoji: '🍇', category: 'Fruit', taste: 'Juicy Pop', superpower: 'Packed with antioxidants that protect our heart and mind!', themeColor: Color(0xFF8E24AA)),
    FoodItem(name: 'Strawberry', emoji: '🍓', category: 'Fruit', taste: 'Sweet & Fragrant', superpower: 'The only fruit that wears its tiny seeds on the outside!', themeColor: Color(0xFFE91E63)),
    FoodItem(name: 'Watermelon', emoji: '🍉', category: 'Fruit', taste: 'Crisp & Refreshing', superpower: 'Made of 92% refreshing water to keep you cool and hydrated!', themeColor: Color(0xFF43A047)),
    FoodItem(name: 'Carrot', emoji: '🥕', category: 'Vegetable', taste: 'Crunchy & Sweet', superpower: 'Packed with Beta-Carotene to give you sharp superhero eyesight!', themeColor: Color(0xFFFF7043)),
    FoodItem(name: 'Tomato', emoji: '🍅', category: 'Vegetable', taste: 'Juicy & Savory', superpower: 'Contains Lycopene to keep our cells happy and strong!', themeColor: Color(0xFFEF5350)),
    FoodItem(name: 'Broccoli', emoji: '🥦', category: 'Vegetable', taste: 'Crisp Green Trees', superpower: 'Full of calcium and iron to build super strong bones and teeth!', themeColor: Color(0xFF2E7D32)),
    FoodItem(name: 'Corn', emoji: '🌽', category: 'Vegetable', taste: 'Golden Sweet', superpower: 'Gives our muscles healthy natural energy to run and jump!', themeColor: Color(0xFFFFB300)),
    FoodItem(name: 'Potato', emoji: '🥔', category: 'Vegetable', taste: 'Warm & Earthy', superpower: 'Healthy carbohydrates to fuel our busy brain all day!', themeColor: Color(0xFF8D6E63)),
  ];

  List<FoodItem> get _filteredList {
    if (_selectedFilter == 'All') return _foodList;
    return _foodList.where((item) => item.category == _selectedFilter).toList();
  }

  void _speakFood(FoodItem item) {
    final tts = Provider.of<TtsService>(context, listen: false);
    tts.speak('This is a ${item.name}! It is a healthy ${item.category}. It tastes ${item.taste}. ${item.superpower}');
  }

  void _showFoodDetail(FoodItem item) {
    _speakFood(item);

    final learningProvider = Provider.of<LearningProvider>(context, listen: false);
    learningProvider.completeLesson(AppConstants.moduleFruits, coinReward: 5);

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
                // Illustration Badge
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

                // Name & Category Badge
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
                    '${item.category} • ${item.taste}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: item.themeColor,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Nutrition Superpower Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F7F2),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFEADBCE)),
                  ),
                  child: Row(
                    children: [
                      const Text('⚡', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Healthy Superpower:',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.superpower,
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
                const SizedBox(height: 18),

                // Audio Pronounce Button
                ElevatedButton.icon(
                  onPressed: () => _speakFood(item),
                  icon: const Icon(Icons.volume_up_rounded, size: 22),
                  label: Text('Pronounce "${item.name}"'),
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
          'Fruits & Veggies 🍎🥕',
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
              // Filter Chips (All, Fruits, Vegetables)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'All Foods 🥗'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Fruit', 'Fruits 🍎'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Vegetable', 'Veggies 🥕'),
                    ],
                  ),
                ),
              ),

              // Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 10,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: isTablet ? 1.05 : 0.94,
                  ),
                  itemBuilder: (context, index) {
                    final item = _filteredList[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showFoodDetail(item),
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
                                item.category,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
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

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedFilter = value),
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
    );
  }
}
