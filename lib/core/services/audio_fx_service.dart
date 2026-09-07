import 'package:flutter/services.dart';
import 'tts_service.dart';

/// Dedicated Audio Sound Effects Service for JAROOS.
/// Delivers rich cartoon sound effects, animal voices, story audio cues,
/// and interactive audio for the Cut-the-Rope style Frog Assistant.
class AudioFxService {
  final TtsService _tts;

  AudioFxService({TtsService? ttsService})
      : _tts = ttsService ?? ModularTtsService();

  /// Play tactile click feedback
  Future<void> playClick() async {
    try {
      await SystemSound.play(SystemSoundType.click);
      await HapticFeedback.selectionClick();
    } catch (_) {}
  }

  /// Play magic sparkle / chime sound effect
  Future<void> playMagicChime() async {
    await playClick();
    await _tts.speak('✨ Ting! Shimmer, shimmer, sparkle! ✨');
  }

  /// Play cheering and applause sound effect
  Future<void> playApplause() async {
    await playClick();
    await _tts.speak('Yay! Woo-hoo! Fantastic job! 👏🎉');
  }

  /// Play page-turn swoosh sound effect
  Future<void> playPageTurn() async {
    await playClick();
    await HapticFeedback.lightImpact();
  }

  /// Play story celebratory fanfare
  Future<void> playStoryFanfare(String storyTitle) async {
    await HapticFeedback.mediumImpact();
    await _tts.speak('🌟 Hooray! You finished $storyTitle! You earned 15 bonus XP! 🏆');
  }

  /// Play story-specific animal/character sound cues
  Future<void> playStoryCharacterSound(String character) async {
    await playClick();
    switch (character.toLowerCase()) {
      case 'lion':
        await _tts.speak('ROAAAR! 🦁 I am the mighty king of the jungle!');
        break;
      case 'mouse':
        await _tts.speak('Squeak squeak squeak! 🐭 Even tiny friends can do big things!');
        break;
      case 'hare':
        await _tts.speak('Whooosh! 🐇 Zoom! Look at how fast I can run!');
        break;
      case 'tortoise':
        await _tts.speak('Step... by... step... 🐢 Slow and steady wins the race!');
        break;
      case 'crow':
        await _tts.speak('Caw caw! 🦅 Plink! Plop! The refreshing water rises to the top!');
        break;
      case 'grasshopper':
        await _tts.speak('Tweedle-dee! 🐜 Zing zing! Dance and sing in the warm sunshine!');
        break;
      default:
        await playMagicChime();
        break;
    }
  }

  // ==========================================
  // Cut-the-Rope Frog Assistant Sound Effects
  // ==========================================

  /// Play happy frog croak ("Ribbit! Ribbit!")
  Future<void> playFrogRibbit() async {
    await playClick();
    await HapticFeedback.mediumImpact();
    await _tts.speak('Ribbit! Ribbit! 🐸 Hi, friend!');
  }

  /// Play Om-Nom style eating / chomp sound effect
  Future<void> playFrogChomp() async {
    await playClick();
    await HapticFeedback.heavyImpact();
    await _tts.speak('Nom nom nom! Chomp! 🍬 Gulp! That sweet candy was delicious!');
  }

  /// Play happy tickle / giggle sound effect
  Future<void> playFrogGiggle() async {
    await playClick();
    await _tts.speak('Hehehe! That tickles! Ribbit! 🎈');
  }

  /// Play encouraging cheer sound effect
  Future<void> playFrogCheer() async {
    await playClick();
    await _tts.speak('Boing! Wheee! 🌟 You are super smart today! Keep it up!');
  }
}
