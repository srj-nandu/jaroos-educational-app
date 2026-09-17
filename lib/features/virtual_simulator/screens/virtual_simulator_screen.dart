import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/learning_provider.dart';
import '../../../services/ai_service.dart';

enum CharacterMood {
  idle,
  speaking,
  laughing,
  thinking,
  eating,
  dancing,
  surprised,
  loving,
}

/// Interactive Virtual Simulator Screen (Talking Tom style).
/// Features:
/// - Custom Character Asset rendering (`assets/images/simulator_character.png`)
/// - Dynamic Physics Animations (Idle breath, jump, squash-and-stretch belly wobble, dance groove)
/// - Multi-Zone Touch Targets:
///   * Head/Hair: Tickle chuckle & head shake
///   * Cheeks/Face: Blushing heart pet
///   * Waving Hand: High five! (+5 Coins)
///   * Belly/Tummy: Elastic tickle wobble
///   * Sneakers/Feet: Bouncing spring jump
/// - Voice Repeat ("Talking Tom" Mode) with high-pitch vocal mimicry
/// - AI Q&A Companion: Ask any question, character ponders and vocally answers with animated mouth
/// - Snack Feeding: Feed pizza, apples, cookies with munching sounds & coin rewards
/// - Fun Dress-Up Accessories: Cool sunglasses & golden crown
class VirtualSimulatorScreen extends StatefulWidget {
  const VirtualSimulatorScreen({super.key});

  @override
  State<VirtualSimulatorScreen> createState() => _VirtualSimulatorScreenState();
}

class _VirtualSimulatorScreenState extends State<VirtualSimulatorScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _idleController;
  late AnimationController _jumpController;
  late AnimationController _wobbleController;
  late AnimationController _danceController;
  late AnimationController _talkController;

  late TtsService _ttsService;
  final TextEditingController _inputCtrl = TextEditingController();

  CharacterMood _currentMood = CharacterMood.idle;
  String _speechBubbleText = "Hi there! I'm your interactive buddy! Tap me, feed me, or talk with me! 🌟";
  bool _showSunglasses = false;
  bool _showCrown = false;
  bool _isVoiceRepeatMode = false;
  bool _isProcessingAI = false;

  final List<String> _quickRepeats = [
    "I love learning! 🚀",
    "You are so funny! 😂",
    "JAROOS is awesome! ⭐",
    "Let's play and grow! 🌿",
  ];

  final List<String> _curiosityQuestions = [
    "Why is the sky blue? ☀️",
    "Tell me a funny joke! 😄",
    "How do birds fly? 🐦",
    "What is your favorite food? 🍕",
  ];

  @override
  void initState() {
    super.initState();
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    _ttsService = ModularTtsService(simulateDelay: !isTest);

    // Idle continuous breathing
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (!isTest) {
      _idleController.repeat(reverse: true);
    } else {
      _idleController.value = 0.5;
    }

    // Jump animation
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Wobble squash & stretch
    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Dance groove
    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Talking mouth sync
    _talkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _idleController.dispose();
    _jumpController.dispose();
    _wobbleController.dispose();
    _danceController.dispose();
    _talkController.dispose();
    _inputCtrl.dispose();
    super.dispose();
  }

  // ==========================================================================
  // SPEECH & INTERACTION LOGIC
  // ==========================================================================

  Future<void> _speakAsCharacter(String text, {CharacterMood mood = CharacterMood.speaking}) async {
    setState(() {
      _speechBubbleText = text;
      _currentMood = mood;
    });

    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTest) {
      _talkController.repeat(reverse: true);
    }

    await _ttsService.speak(text);

    if (mounted) {
      if (!isTest) {
        _talkController.stop();
        _talkController.value = 0.0;
      }
      setState(() {
        _currentMood = CharacterMood.idle;
      });
    }
  }

  /// Touch Zone 1: Head / Hair Tickle
  void _onTapHead() {
    _wobbleController.forward(from: 0.0);
    _speakAsCharacter(
      "Hehehe! That tickles my hair! You're making me chuckle! 😄",
      mood: CharacterMood.laughing,
    );
  }

  /// Touch Zone 2: Cheeks / Face Petting
  void _onTapFace() {
    setState(() => _currentMood = CharacterMood.loving);
    _speakAsCharacter(
      "Aww, thanks for the love! You're the best buddy ever! 💖",
      mood: CharacterMood.loving,
    );
  }

  /// Touch Zone 3: Waving Hand (High Five)
  void _onTapHand() {
    final learning = Provider.of<LearningProvider>(context, listen: false);
    learning.addCoins(5);
    _wobbleController.forward(from: 0.0);
    _speakAsCharacter(
      "High five, champ! 🖐️ +5 Stars earned! You're doing amazing today!",
      mood: CharacterMood.dancing,
    );
  }

  /// Touch Zone 4: Tummy / Belly Poke
  void _onTapBelly() {
    _wobbleController.forward(from: 0.0);
    _speakAsCharacter(
      "Whoa-ho-ho! My tummy is super ticklish! Stop it, hehe! 😆",
      mood: CharacterMood.laughing,
    );
  }

  /// Touch Zone 5: Sneakers / Feet Jump
  void _onTapFeet() {
    _jumpController.forward(from: 0.0);
    _speakAsCharacter(
      "Boing! Look how high I can jump in my white sneakers! 👟✨",
      mood: CharacterMood.dancing,
    );
  }

  /// Feed a Snack to Character
  void _feedSnack(String snackName, String emoji) {
    final learning = Provider.of<LearningProvider>(context, listen: false);
    learning.addCoins(5);
    setState(() => _currentMood = CharacterMood.eating);
    _wobbleController.forward(from: 0.0);

    _speakAsCharacter(
      "Munch, munch, crunch! 😋 That $snackName $emoji was so delicious! +5 Stars!",
      mood: CharacterMood.eating,
    );
  }

  /// Trigger Dance Groove
  void _startDanceParty() {
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTest) {
      _danceController.repeat(reverse: true);
    } else {
      _danceController.forward(from: 0.0);
    }
    _speakAsCharacter(
      "Woo-hoo! Dance party time! Let's groove together! 💃🎶",
      mood: CharacterMood.dancing,
    ).then((_) {
      if (!isTest) {
        _danceController.stop();
        _danceController.value = 0.0;
      }
    });
  }

  /// Talking Tom Voice Repeat Mode
  void _handleRepeatPhrase(String phrase) {
    _inputCtrl.clear();
    _speakAsCharacter(
      "🗣️ \"$phrase\" ... Hehe, that sounds awesome when I say it!",
      mood: CharacterMood.speaking,
    );
  }

  /// Ask Question to AI Companion
  Future<void> _askAiQuestion(String question) async {
    final clean = question.trim();
    if (clean.isEmpty || _isProcessingAI) return;

    _inputCtrl.clear();
    setState(() {
      _isProcessingAI = true;
      _currentMood = CharacterMood.thinking;
      _speechBubbleText = "Hmm... let me think about that! 🤔";
    });

    final ai = Provider.of<AiService>(context, listen: false);
    final answer = await ai.askJaroosBuddy(clean);

    if (mounted) {
      setState(() => _isProcessingAI = false);
      _speakAsCharacter(answer, mood: CharacterMood.speaking);
    }
  }

  // ==========================================================================
  // BUILD UI
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final learning = context.watch<LearningProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8), // Warm soft cream canvas
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1F2937), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Virtual Buddy 🎮',
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        actions: [
          // Coins Capsule
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1EADB)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('💎', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 4),
                Text(
                  '${learning.coins}',
                  style: GoogleFonts.fredoka(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFA000),
                  ),
                ),
              ],
            ),
          ),

          // Accessory Toggles Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.palette_outlined, color: Color(0xFF1F2937)),
            tooltip: 'Dress Up Accessories',
            onSelected: (val) {
              if (val == 'shades') setState(() => _showSunglasses = !_showSunglasses);
              if (val == 'crown') setState(() => _showCrown = !_showCrown);
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'shades',
                child: Row(
                  children: [
                    Text(_showSunglasses ? '✅ ' : '🕶️ '),
                    const Text('Cool Sunglasses'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'crown',
                child: Row(
                  children: [
                    Text(_showCrown ? '✅ ' : '👑 '),
                    const Text('Golden Crown'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Speech Bubble Banner above character
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: _buildSpeechBubble(),
            ),

            // 2. Interactive Character Stage (Touch Zones)
            Expanded(
              child: Center(
                child: _buildInteractiveCharacterStage(),
              ),
            ),

            // 3. Bottom Action Controls (Snacks, Repeat Mode, Dance, AI Q&A)
            _buildBottomControlPanel(),
          ],
        ),
      ),
    );
  }

  /// Cartoon Speech Bubble with Tail
  Widget _buildSpeechBubble() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1EADB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA000).withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Dynamic Mood Emoji Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D6),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFA000).withValues(alpha: 0.4)),
            ),
            child: Center(
              child: Text(
                _getMoodEmoji(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Speech Text
          Expanded(
            child: Text(
              _speechBubbleText,
              style: GoogleFonts.fredoka(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _getMoodEmoji() {
    switch (_currentMood) {
      case CharacterMood.speaking:
        return '🗣️';
      case CharacterMood.laughing:
        return '🤣';
      case CharacterMood.thinking:
        return '🤔';
      case CharacterMood.eating:
        return '😋';
      case CharacterMood.dancing:
        return '💃';
      case CharacterMood.surprised:
        return '😲';
      case CharacterMood.loving:
        return '🥰';
      case CharacterMood.idle:
      default:
        return '😊';
    }
  }

  /// Interactive Living Character with Layered Gesture Touch Zones
  Widget _buildInteractiveCharacterStage() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _idleController,
        _jumpController,
        _wobbleController,
        _danceController,
        _talkController,
      ]),
      builder: (context, child) {
        // Continuous gentle breathing offset
        final idleBob = math.sin(_idleController.value * 2 * math.pi) * 6.0;

        // Jump vertical launch & land curve
        final jumpHeight = math.sin(_jumpController.value * math.pi) * -65.0;

        // Belly squash & stretch
        final wobbleScaleX = 1.0 + (math.sin(_wobbleController.value * 4 * math.pi) * 0.08);
        final wobbleScaleY = 1.0 - (math.sin(_wobbleController.value * 4 * math.pi) * 0.06);

        // Dance side tilt
        final danceRotation = math.sin(_danceController.value * 2 * math.pi) * 0.12;

        final totalOffsetY = idleBob + jumpHeight;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Character Body with Physics Transforms
            Flexible(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Transform.translate(
                  offset: Offset(0, totalOffsetY),
                  child: Transform.rotate(
                    angle: danceRotation,
                    child: Transform.scale(
                      scaleX: wobbleScaleX,
                      scaleY: wobbleScaleY,
                      child: SizedBox(
                        width: 260,
                        height: 380,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                      children: [
                        // 1. Character Visual Image
                        Image.asset(
                          'assets/images/simulator_character.png',
                          width: 260,
                          height: 380,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text('🧍‍♂️✨', style: TextStyle(fontSize: 80)),
                          ),
                        ),

                        // 2. Cool Sunglasses Accessory Overlay
                        if (_showSunglasses)
                          Positioned(
                            top: 88,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: const Text('🕶️ 😎', style: TextStyle(fontSize: 18)),
                            ),
                          ),

                        // 3. Golden Crown Accessory Overlay
                        if (_showCrown)
                          const Positioned(
                            top: 8,
                            child: Text('👑', style: TextStyle(fontSize: 36)),
                          ),

                        // 4. Talking Mouth Animation Ripple Indicator
                        if (_currentMood == CharacterMood.speaking)
                          Positioned(
                            top: 135,
                            child: Container(
                              width: 14,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5722),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF9800).withValues(alpha: 0.6),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // ====================================================
                        // TOUCH TARGET ZONES (Transparent Interactive Overlays)
                        // ====================================================

                        // Zone A: Head & Curly Hair (Tickle)
                        Positioned(
                          top: 0,
                          left: 40,
                          right: 40,
                          height: 95,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _onTapHead,
                            child: Container(color: Colors.transparent),
                          ),
                        ),

                        // Zone B: Face & Cheeks (Loving Pet)
                        Positioned(
                          top: 95,
                          left: 60,
                          right: 60,
                          height: 70,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _onTapFace,
                            child: Container(color: Colors.transparent),
                          ),
                        ),

                        // Zone C: Waving Hand (High Five!)
                        Positioned(
                          top: 155,
                          left: 10,
                          width: 65,
                          height: 65,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _onTapHand,
                            child: Container(color: Colors.transparent),
                          ),
                        ),

                        // Zone D: Belly / Green Shirt (Poke & Giggle)
                        Positioned(
                          top: 170,
                          left: 75,
                          right: 75,
                          height: 90,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _onTapBelly,
                            child: Container(color: Colors.transparent),
                          ),
                        ),

                        // Zone E: Sneakers / Feet (Bouncy Jump)
                        Positioned(
                          bottom: 0,
                          left: 45,
                          right: 45,
                          height: 75,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _onTapFeet,
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

            // Dynamic Ground Shadow (Scales with jumps)
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 140 - (jumpHeight.abs() * 0.8).clamp(0.0, 70.0),
              height: 16 - (jumpHeight.abs() * 0.15).clamp(0.0, 8.0),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.15 - (jumpHeight.abs() * 0.0015)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Bottom Control Panel (Feed, Voice Repeat, Dance, AI Questions)
  Widget _buildBottomControlPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        border: const Border(top: BorderSide(color: Color(0xFFF1EADB), width: 1.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Action Quick Buttons Row: Snacks, Dance, Repeat, Q&A
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                label: 'Snacks 🍎',
                color: const Color(0xFFFFECE5),
                textColor: const Color(0xFFFF5722),
                onTap: _showSnackMenu,
              ),
              _buildActionButton(
                label: 'Dance 💃',
                color: const Color(0xFFF5EBFD),
                textColor: const Color(0xFF9333EA),
                onTap: _startDanceParty,
              ),
              _buildActionButton(
                label: 'Repeat 🎙️',
                color: _isVoiceRepeatMode ? const Color(0xFFFFA000) : const Color(0xFFFFF3D6),
                textColor: _isVoiceRepeatMode ? Colors.white : const Color(0xFFE65100),
                onTap: () {
                  setState(() => _isVoiceRepeatMode = !_isVoiceRepeatMode);
                },
              ),
              _buildActionButton(
                label: 'High Five 🖐️',
                color: const Color(0xFFEBF3FE),
                textColor: const Color(0xFF3B82F6),
                onTap: _onTapHand,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Voice Repeat Phrases or Curiosity Chips
          if (_isVoiceRepeatMode)
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _quickRepeats.length,
                itemBuilder: (context, index) {
                  final phrase = _quickRepeats[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(
                        phrase,
                        style: GoogleFonts.fredoka(fontSize: 12, color: const Color(0xFFE65100)),
                      ),
                      backgroundColor: const Color(0xFFFFF8E1),
                      side: const BorderSide(color: Color(0xFFFFD54F)),
                      onPressed: () => _handleRepeatPhrase(phrase),
                    ),
                  );
                },
              ),
            )
          else
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _curiosityQuestions.length,
                itemBuilder: (context, index) {
                  final q = _curiosityQuestions[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(
                        q,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                      backgroundColor: const Color(0xFFEBF3FE),
                      side: const BorderSide(color: Color(0xFFBFDBFE)),
                      onPressed: () => _askAiQuestion(q),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 8),

          // Question / Speech Input Bar
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F7F2),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFEADBCE)),
                  ),
                  child: TextField(
                    controller: _inputCtrl,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (text) {
                      if (_isVoiceRepeatMode) {
                        _handleRepeatPhrase(text);
                      } else {
                        _askAiQuestion(text);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: _isVoiceRepeatMode ? 'Type words to repeat...' : 'Ask me anything...',
                      hintStyle: GoogleFonts.nunito(fontSize: 13, color: const Color(0xFF9CA3AF)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  final text = _inputCtrl.text.trim();
                  if (text.isNotEmpty) {
                    if (_isVoiceRepeatMode) {
                      _handleRepeatPhrase(text);
                    } else {
                      _askAiQuestion(text);
                    }
                  }
                },
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFA000), Color(0xFFFF8F00)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF8F00).withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _showSnackMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Feed a Snack to Your Buddy! 🍎',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSnackItem('Pizza', '🍕', ctx),
                  _buildSnackItem('Apple', '🍎', ctx),
                  _buildSnackItem('Cookie', '🍪', ctx),
                  _buildSnackItem('Milk', '🥛', ctx),
                  _buildSnackItem('Banana', '🍌', ctx),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSnackItem(String name, String emoji, BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        _feedSnack(name, emoji);
      },
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1EADB)),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: GoogleFonts.fredoka(fontSize: 12, color: const Color(0xFF4B5563)),
          ),
        ],
      ),
    );
  }
}
