import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../models/voice_persona_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/learning_provider.dart';
import '../../../providers/parent_provider.dart';

/// Parent Dashboard for JAROOS.
/// Provides parents with screen time monitoring, weekly analytics charts,
/// subject recommendations, module toggles, audio narration settings, and progress resets.
class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  void _showChangePinDialog(BuildContext context, ParentProvider parent) {
    final pinCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Change Security PIN 🔑',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter a new 4-digit numeric PIN for the Parent Gate:',
              style: GoogleFonts.nunito(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pinCtrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 22, letterSpacing: 8),
              decoration: InputDecoration(
                counterText: '',
                hintText: '••••',
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final text = pinCtrl.text.trim();
              if (text.length == 4) {
                parent.updatePin(text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN updated successfully!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Save PIN'),
          ),
        ],
      ),
    );
  }

  void _showResetProgressDialog(BuildContext context, LearningProvider learning) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Reset Learning Progress? ⚠️',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: AppColors.error),
        ),
        content: Text(
          'This will reset all completed lessons, earned stars, and reset coins to 100. This action cannot be undone.',
          style: GoogleFonts.nunito(fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              learning.resetProgress();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Learning progress has been reset.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Reset All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parent = context.watch<ParentProvider>();
    final learning = context.watch<LearningProvider>();
    final auth = context.watch<AuthProvider>();
    final isTablet = ResponsiveUtil.isTablet(context);
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);

    final childName = auth.user?.childName ?? 'Young Learner';
    final settings = parent.settings;
    final timeLimit = settings.dailyTimeLimitMinutes;
    final timeSpent = settings.todayScreenTimeMinutes;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Parent Dashboard 👨‍👩‍👧',
          style: GoogleFonts.fredoka(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              parent.loadVivaDemoAnalytics();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Loaded Viva Demo Analytics & Weekly Data 📊'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.bar_chart_rounded, size: 18),
            label: const Text('Demo Data', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
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
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Greeting Card
                _buildHeaderGreeting(childName, isTablet),
                const SizedBox(height: 18),

                // 1. Screen Time & Digital Wellness Card
                _buildScreenTimeCard(context, parent, timeSpent, timeLimit, isTablet),
                const SizedBox(height: 18),

                // 2. Weekly Learning Minutes Chart
                _buildWeeklyUsageChart(settings.weeklyMinutes, settings.averageWeeklyHours, isTablet),
                const SizedBox(height: 18),

                // 3. Subject Mastery & Recommendations
                _buildSubjectMasteryCard(settings.subjectAccuracy, isTablet),
                const SizedBox(height: 18),

                // 4. Curriculum & Module Visibility Controls
                _buildModuleControlsCard(context, parent, learning, isTablet),
                const SizedBox(height: 18),

                // 5. App Language & Locale Selection 🌐
                _buildLanguageSelectorCard(context, parent, isTablet),
                const SizedBox(height: 18),

                // 6. Sound & Narration Settings
                _buildAudioSettingsCard(context, parent, isTablet),
                const SizedBox(height: 18),

                // 7. Security & Danger Zone
                _buildSecurityCard(context, parent, learning, isTablet),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Top Parent Greeting Banner
  Widget _buildHeaderGreeting(String childName, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_rounded, color: AppColors.primaryDark, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Monitoring $childName's Growth",
                  style: GoogleFonts.fredoka(
                    fontSize: isTablet ? 20 : 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Insights, healthy limits, and safety controls in one place.',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Screen Time Card with dynamic progress gauge & limit selector
  Widget _buildScreenTimeCard(
    BuildContext context,
    ParentProvider parent,
    int spentMinutes,
    int limitMinutes,
    bool isTablet,
  ) {
    final progress = limitMinutes > 0
        ? (spentMinutes / limitMinutes).clamp(0.0, 1.0)
        : 0.5;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Daily Screen Time ⏳',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  limitMinutes > 0 ? '$spentMinutes / $limitMinutes Min' : '$spentMinutes Min (Unlimited)',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Linear Screen Time Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.85 ? AppColors.error : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Time Limit Selector Chips
          Text(
            'Change Daily Time Limit:',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [15, 30, 45, 60, 0].map((minutes) {
              final isSelected = limitMinutes == minutes;
              final label = minutes == 0 ? 'Unlimited' : '$minutes Min';
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => parent.setDailyTimeLimit(minutes),
                selectedColor: AppColors.primaryLight,
                labelStyle: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Weekly Usage Bar Chart (Mon through Sun)
  Widget _buildWeeklyUsageChart(Map<String, int> weeklyMinutes, double weeklyHours, bool isTablet) {
    const maxMinutes = 60.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Weekly Activity 📊',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${weeklyHours.toStringAsFixed(1)} hrs total',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 7 Day Bars
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weeklyMinutes.entries.map((entry) {
                final day = entry.key;
                final minutes = entry.value;
                final barHeight = (minutes / maxMinutes * 80).clamp(12.0, 80.0);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$minutes',
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: isTablet ? 28 : 22,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      day,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Subject Performance: Strong Areas vs Needs Practice
  Widget _buildSubjectMasteryCard(Map<String, int> accuracy, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subject Performance & Focus 🎯',
            style: GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Accuracy per subject
          ...accuracy.entries.map((e) {
            final subject = e.key;
            final score = e.value;
            final isStrong = score >= 80;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subject,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        isStrong ? '$score% (Strong ⭐)' : '$score% (Needs Practice 💡)',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isStrong ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: score / 100.0,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isStrong ? const Color(0xFF66BB6A) : const Color(0xFFFFA726),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 6),
          // Recommendation Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Recommendation: Encourage 10 minutes of Shape Detective & Colors to boost geometric confidence!',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB78103),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Curriculum & Module Visibility Controls
  Widget _buildModuleControlsCard(
    BuildContext context,
    ParentProvider parent,
    LearningProvider learning,
    bool isTablet,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Module Curriculum Controls 📚',
            style: GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Parents can enable or disable specific subjects as needed.',
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          ...learning.modules.map((m) {
            final isEnabled = parent.isModuleEnabled(m.id);
            return Material(
              color: Colors.transparent,
              child: SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  m.title,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  m.subtitle,
                  style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textSecondary),
                ),
                value: isEnabled,
                activeColor: AppColors.primary,
                onChanged: (_) => parent.toggleModuleVisibility(m.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// App Language & Locale Selection (English, Hindi, Malayalam)
  Widget _buildLanguageSelectorCard(BuildContext context, ParentProvider parent, bool isTablet) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final currentLangCode = parent.selectedLanguageCode;
    final tts = Provider.of<TtsService>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'App Language & Locale 🌐',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLanguage.fromCode(currentLangCode).nativeLabel,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Choose the primary language for lessons, interface, and speech narration.',
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          // 3 Language Cards
          Row(
            children: AppLanguage.values.map((lang) {
              final isSelected = currentLangCode == lang.code;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      parent.setLanguage(lang.code);
                      await langProvider.setLanguage(lang);
                      await tts.setLanguage(lang.code);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Language switched to ${lang.nativeLabel} (${lang.englishLabel}) 🌐'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryLight.withOpacity(0.35) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            lang.flagEmoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lang.nativeLabel,
                            style: GoogleFonts.fredoka(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.englishLabel,
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isSelected) ...[
                            const SizedBox(height: 4),
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Audio, Voice & Speech Narration Settings
  Widget _buildAudioSettingsCard(BuildContext context, ParentProvider parent, bool isTablet) {
    final settings = parent.settings;
    final tts = Provider.of<TtsService>(context, listen: false);
    final activeLanguage = parent.selectedLanguageCode;
    final personasForLang = VoicePersona.getByLanguage(activeLanguage);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Voice & Audio Preferences 🔊',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${personasForLang.length} Voices',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Choose your child\'s favorite character voice for ${AppLanguage.fromCode(activeLanguage).englishLabel}. Tap any voice to switch, or tap Preview to listen.',
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          // Character Narration Voices List
          Text(
            '${AppLanguage.fromCode(activeLanguage).englishLabel} Narration Voices:',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),

          ...personasForLang.map((persona) {
            final isSelected = settings.selectedVoiceId == persona.id;
            final accentColor = Color(persona.accentColorHex);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isSelected ? accentColor.withOpacity(0.07) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? accentColor : const Color(0xFFE2E8F0),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    parent.setVoicePersona(persona.id);
                    tts.setVoicePersona(persona.id);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Switched voice to ${persona.name} (${persona.role}) 🎙️'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar Emoji Circle
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            persona.emoji,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Voice Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 6,
                                runSpacing: 2,
                                children: [
                                  Text(
                                    persona.name,
                                    style: GoogleFonts.fredoka(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: accentColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      persona.role,
                                      style: GoogleFonts.nunito(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                persona.description,
                                style: GoogleFonts.nunito(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isSelected) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.check_circle_rounded, size: 14, color: accentColor),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Active Companion',
                                      style: GoogleFonts.nunito(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Preview / Listen Button
                        IconButton.filledTonal(
                          onPressed: () {
                            tts.previewPersona(persona);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Previewing ${persona.name}... 🔊'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.volume_up_rounded, size: 18),
                          tooltip: 'Preview ${persona.name}',
                          style: IconButton.styleFrom(
                            backgroundColor: accentColor.withOpacity(0.15),
                            foregroundColor: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 14),

          // Speech Speed
          Text(
            'TTS Narration Voice Speed:',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              {'label': 'Slow (0.8x)', 'rate': 0.8},
              {'label': 'Normal (1.0x)', 'rate': 1.0},
              {'label': 'Fast (1.2x)', 'rate': 1.2},
            ].map((entry) {
              final rate = entry['rate'] as double;
              final isSelected = settings.ttsSpeechRate == rate;
              return ChoiceChip(
                label: Text(entry['label'] as String),
                selected: isSelected,
                onSelected: (_) => parent.setTtsSpeechRate(rate),
                selectedColor: AppColors.primaryLight,
                labelStyle: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Toggles
          Material(
            color: Colors.transparent,
            child: SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sound Effects & Audio Feedback'),
              value: settings.soundEffectsEnabled,
              activeColor: AppColors.primary,
              onChanged: (val) => parent.toggleSoundEffects(val),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Background Story Music'),
              value: settings.backgroundMusicEnabled,
              activeColor: AppColors.primary,
              onChanged: (val) => parent.toggleBackgroundMusic(val),
            ),
          ),
        ],
      ),
    );
  }

  /// Security & Danger Zone (Change PIN & Reset)
  Widget _buildSecurityCard(
    BuildContext context,
    ParentProvider parent,
    LearningProvider learning,
    bool isTablet,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security & Safety Settings 🔐',
            style: GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // Change PIN Button
          OutlinedButton.icon(
            onPressed: () => _showChangePinDialog(context, parent),
            icon: const Icon(Icons.password_rounded),
            label: const Text('Change 4-Digit Parent PIN'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 10),

          // Reset Progress Button
          ElevatedButton.icon(
            onPressed: () => _showResetProgressDialog(context, learning),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reset Child Learning Progress'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFEBEE),
              foregroundColor: AppColors.error,
              elevation: 0,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}
