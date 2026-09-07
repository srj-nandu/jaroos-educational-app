import 'dart:math';
import '../models/ai_models.dart';

/// Abstract contract for AI features in JAROOS.
abstract class AiService {
  Future<String> askJaroosBuddy(String question);
  Future<GeneratedStory> generateBedtimeStory({
    required String hero,
    required String theme,
    required String setting,
  });
  Future<PronunciationFeedback> evaluatePronunciation({
    required String targetWord,
    required String spokenWord,
  });
}

/// Modular AI Service for JAROOS.
/// Includes child safety moderation, an offline child STEM/nature knowledge base
/// for seamless academic viva demonstration, and a dynamic moral story generator.
class ModularAiService implements AiService {
  final bool simulateDelay;
  const ModularAiService({this.simulateDelay = true});

  // Inappropriate words blocklist for child safety
  static const List<String> _safetyFilterKeywords = [
    'kill', 'die', 'blood', 'gun', 'fight', 'hate', 'stupid', 'ugly', 'scary',
    'monster', 'ghost', 'war', 'hurt', 'curse', 'bad', 'weapon'
  ];

  @override
  Future<String> askJaroosBuddy(String question) async {
    final cleanPrompt = question.trim().toLowerCase();

    // 1. Child Safety Moderation Check
    for (final word in _safetyFilterKeywords) {
      if (cleanPrompt.contains(word)) {
        return "That sounds a little scary! 🧸 Let's talk about something cheerful and bright, like cuddly animals, colorful rainbows, or twinkling stars! 🌟";
      }
    }

    // Simulate realistic AI thought processing latency
    if (simulateDelay) {
      await Future.delayed(const Duration(milliseconds: 350));
    }

    // 2. Kid Curiosities Knowledge Engine
    if (cleanPrompt.contains('sky') && cleanPrompt.contains('blue')) {
      return "Sunlight looks white, but it's made of all rainbow colors! 🌈 When sunlight hits the air around our Earth, blue light scatters in every direction because it travels in tiny, short waves. That makes the whole sky glow bright blue! ☀️";
    }

    if (cleanPrompt.contains('spider') || (cleanPrompt.contains('leg') && cleanPrompt.contains('spider'))) {
      return "Spiders have exactly 8 legs! 🕷️ That makes them arachnids. Most insects like ants and bees only have 6 legs. Those extra 2 legs help spiders climb walls and weave silky webs!";
    }

    if (cleanPrompt.contains('leaf') || cleanPrompt.contains('leaves') || cleanPrompt.contains('autumn')) {
      return "Leaves are green because of a plant superpower called chlorophyll! 🍃 In autumn when days get cooler, trees take a nap and stop making green color, letting beautiful gold, orange, and red colors shine through! 🍂";
    }

    if (cleanPrompt.contains('bird') && cleanPrompt.contains('sing')) {
      return "Birds sing to talk to their friends! 🐦 They chirp happy morning songs to say 'Hello!', mark their cozy nests, and call their baby chicks for breakfast!";
    }

    if (cleanPrompt.contains('joke')) {
      final jokes = [
        "Why did the teddy bear say no to dessert? Because it was already stuffed! 🧸😄",
        "Why do birds fly south for winter? Because it's too far to walk! 🐧✈️",
        "What do you call a sleeping dinosaur? A dino-snore! 🦕💤",
        "What has four wheels and flies? A garbage truck! 🚛🪰",
      ];
      return jokes[Random().nextInt(jokes.length)];
    }

    if (cleanPrompt.contains('sleep')) {
      return "Sleeping is like plugging your body into a magic charger! ⚡ When you dream, your brain organizes all the letters, numbers, and games you learned today so you wake up super smart and energized! 🌙";
    }

    if (cleanPrompt.contains('fish') && cleanPrompt.contains('breathe')) {
      return "Fish don't have lungs like us! Instead, they have special feathery gills on the sides of their cheeks that catch invisible oxygen bubbles straight out of the water! 🐠🫧";
    }

    if (cleanPrompt.contains('ocean') && cleanPrompt.contains('salt')) {
      return "Rain gently washes tiny mineral salts from rocks into rivers, which slowly carry them into the ocean! Over millions of years, the water became salty and sparkly! 🌊🐬";
    }

    if (cleanPrompt.contains('dinosaur')) {
      return "Did you know that some dinosaurs like the Brachiosaurus were taller than a 4-story building, but their babies hatched from eggs smaller than a football? 🦕🥚";
    }

    if (cleanPrompt.contains('moon') || cleanPrompt.contains('sun')) {
      return "The Sun is a giant ball of glowing hot gas that gives us warmth! The Moon doesn't have its own light—it acts like a giant mirror reflecting sunlight down to us like a cozy nightlight! ☀️🌙";
    }

    // Universal cheerful educational response
    return "What a wonderful question! 🌟 Curiosity is how young explorers become superheroes! Keep asking big questions and discovering the wonders of our amazing world!";
  }

  @override
  Future<GeneratedStory> generateBedtimeStory({
    required String hero,
    required String theme,
    required String setting,
  }) async {
    if (simulateDelay) {
      await Future.delayed(const Duration(milliseconds: 400));
    }

    final heroEmoji = _getHeroEmoji(hero);
    final title = 'The Adventures of $hero in $setting';

    final paragraphs = [
      'Once upon a sunny morning, $hero $heroEmoji woke up with a big smile ready for an adventure in the magical realm of $setting.',
      'While skipping along, $hero noticed a little friend who was feeling lost and gloomy. Remembering the importance of $theme, $hero stepped forward with an open heart to lend a helping hand.',
      'Together, they solved the puzzle, shared happy laughter, and watched the sky fill with dancing rainbow lights. $hero smiled warmly, knowing that practicing $theme makes the whole world a brighter place!',
    ];

    final moral = 'Moral of the story: Practicing $theme brings happiness and sunshine to everyone around you!';

    return GeneratedStory(
      id: 'story_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      hero: hero,
      theme: theme,
      setting: setting,
      paragraphs: paragraphs,
      moral: moral,
      heroEmoji: heroEmoji,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<PronunciationFeedback> evaluatePronunciation({
    required String targetWord,
    required String spokenWord,
  }) async {
    final cleanTarget = targetWord.trim().toLowerCase();
    final cleanSpoken = spokenWord.trim().toLowerCase();

    if (cleanTarget == cleanSpoken) {
      return PronunciationFeedback(
        targetWord: targetWord,
        spokenWord: spokenWord,
        accuracyScore: 100,
        feedbackMessage: "Perfection! 🌟 You pronounced '$targetWord' crystal clearly like a superstar!",
        isSuperStar: true,
      );
    } else {
      return PronunciationFeedback(
        targetWord: targetWord,
        spokenWord: spokenWord,
        accuracyScore: 85,
        feedbackMessage: "Super close! 👏 Try saying '$targetWord' with a soft breath at the end. You can do it!",
        isSuperStar: false,
      );
    }
  }

  String _getHeroEmoji(String hero) {
    switch (hero.toLowerCase()) {
      case 'baby dragon': return '🐉';
      case 'brave bunny': return '🐰';
      case 'little astronaut': return '🚀';
      case 'friendly robot': return '🤖';
      case 'playful puppy': return '🐶';
      case 'magic mermaid': return '🧜';
      default: return '⭐';
    }
  }
}
