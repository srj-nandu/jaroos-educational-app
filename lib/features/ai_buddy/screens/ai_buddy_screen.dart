import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../models/ai_models.dart';
import '../../../services/ai_service.dart';

/// Interactive AI Voice & Learning Buddy (Sparky) for JAROOS.
/// Answers curious questions from kids aged 3–8 with child-safe, encouraging explanations,
/// vocal TTS speech, and interactive prompt chips.
class AiBuddyScreen extends StatefulWidget {
  const AiBuddyScreen({super.key});

  @override
  State<AiBuddyScreen> createState() => _AiBuddyScreenState();
}

class _AiBuddyScreenState extends State<AiBuddyScreen> {
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isThinking = false;

  final List<AiChatMessage> _messages = [
    AiChatMessage(
      id: 'msg_welcome',
      text: "Hi there, little explorer! 🌟 I'm Sparky, your AI Learning Buddy! Ask me any question about nature, space, animals, or numbers!",
      isUser: false,
      timestamp: DateTime.now(),
      emotionEmoji: '🌟',
    ),
  ];

  static const List<String> _quickCuriosities = [
    'Why is the sky blue? ☀️',
    'How many legs does a spider have? 🕷️',
    'Why do leaves change color? 🍂',
    'Tell me a joke! 😄',
    'Why do birds sing? 🐦',
    'Why do we need sleep? 🌙',
    'How do fish breathe? 🐠',
    'Tell me a dinosaur fact! 🦕',
  ];

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final clean = text.trim();
    if (clean.isEmpty || _isThinking) return;

    _textCtrl.clear();
    setState(() {
      _messages.add(AiChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        text: clean,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isThinking = true;
    });
    _scrollToBottom();

    final ai = Provider.of<AiService>(context, listen: false);
    final tts = Provider.of<TtsService>(context, listen: false);

    final reply = await ai.askJaroosBuddy(clean);

    if (mounted) {
      setState(() {
        _messages.add(AiChatMessage(
          id: 'msg_ai_${DateTime.now().millisecondsSinceEpoch}',
          text: reply,
          isUser: false,
          timestamp: DateTime.now(),
          emotionEmoji: '✨',
        ));
        _isThinking = false;
      });
      _scrollToBottom();

      // Read answer aloud for young learners
      tts.speak(reply);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtil.isTablet(context);
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);
    final tts = context.watch<TtsService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Sparky - AI Buddy 🌟',
          style: GoogleFonts.fredoka(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(AiChatMessage(
                  id: 'msg_welcome_${DateTime.now().millisecondsSinceEpoch}',
                  text: "Fresh chat started! What fun wonder shall we explore now? 🚀",
                  isUser: false,
                  timestamp: DateTime.now(),
                  emotionEmoji: '🚀',
                ));
              });
            },
            tooltip: 'Clear Chat',
            icon: const Icon(Icons.refresh_rounded),
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
          child: Column(
            children: [
              // Mascot Header Card
              _buildMascotHeader(isTablet),

              // Quick Curiosity Prompt Chips
              _buildCuriosityChips(),

              // Chat Message Stream
              Expanded(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _buildChatBubble(msg, tts, isTablet);
                  },
                ),
              ),

              // Thinking / Generating Indicator
              if (_isThinking)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🌟', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        'Sparky is thinking...',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryDark,
                        ),
                      ),
                    ],
                  ),
                ),

              // Bottom Input Bar
              _buildBottomInputBar(isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMascotHeader(bool isTablet) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
              ),
            ),
            child: const Center(
              child: Text('🌟', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ask Sparky any question! Powered by child-safe AI.',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuriosityChips() {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _quickCuriosities.length,
        itemBuilder: (context, index) {
          final prompt = _quickCuriosities[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(prompt),
              backgroundColor: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              labelStyle: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
              onPressed: () => _sendMessage(prompt),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatBubble(AiChatMessage msg, TtsService tts, bool isTablet) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 8, top: 4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0xFFFFD54F), Color(0xFFFFB300)]),
              ),
              child: const Center(child: Text('🌟', style: TextStyle(fontSize: 18))),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: AppColors.softShadow,
                border: isUser ? null : Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: GoogleFonts.nunito(
                      fontSize: isTablet ? 15 : 14,
                      fontWeight: isUser ? FontWeight.w700 : FontWeight.w600,
                      color: isUser ? Colors.white : AppColors.textPrimary,
                      height: 1.35,
                    ),
                  ),
                  if (!isUser) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => tts.speak(msg.text),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.volume_up_rounded, size: 14, color: AppColors.primaryDark),
                                const SizedBox(width: 4),
                                Text(
                                  'Listen 🔊',
                                  style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) ...[
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(left: 8, top: 4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary,
              ),
              child: const Center(child: Text('🧒', style: TextStyle(fontSize: 18))),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomInputBar(bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Simulated Voice Mic Button for Toddlers
          IconButton(
            onPressed: () {
              // Simulated voice recognition prompt
              final sampleVoicePrompts = [
                'Why do birds sing?',
                'Tell me a dinosaur fact!',
                'How do fish breathe?',
                'Why is the sky blue?',
              ];
              final voiceText = (sampleVoicePrompts..shuffle()).first;
              _sendMessage(voiceText);
            },
            tooltip: 'Tap to Speak',
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.secondaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic_rounded, color: AppColors.secondaryDark, size: 22),
            ),
          ),
          const SizedBox(width: 8),

          // Text Field
          Expanded(
            child: TextField(
              controller: _textCtrl,
              decoration: InputDecoration(
                hintText: 'Ask Sparky anything...',
                hintStyle: GoogleFonts.nunito(fontSize: 14, color: AppColors.textSecondary),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),

          // Send Button
          IconButton(
            onPressed: () => _sendMessage(_textCtrl.text),
            tooltip: 'Send Question',
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
