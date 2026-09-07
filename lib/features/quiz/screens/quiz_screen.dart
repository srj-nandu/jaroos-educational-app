import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/quiz_model.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';

class QuizTopic {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final Color themeColor;
  final List<QuizQuestion> questions;

  const QuizTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.themeColor,
    required this.questions,
  });
}

/// Interactive Quiz Arena for JAROOS.
/// Delivers child-friendly multiple-choice questions, instant visual/audio feedback,
/// academic scoring algorithm `(correct / total) * 100`, and celebratory star rewards.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuizTopic? _activeTopic;
  int _currentQuestionIndex = 0;
  int _selectedOptionIndex = -1;
  bool _hasSubmitted = false;
  int _correctCount = 0;
  bool _quizFinished = false;

  static final List<QuizTopic> _topics = [
    QuizTopic(
      id: 'animals',
      title: 'Animals & Friends',
      description: 'Sounds, habitats & animal trivia',
      emoji: '🦁',
      themeColor: AppColors.coral,
      questions: const [
        QuizQuestion(
          id: 'q_a1',
          moduleId: 'animals',
          question: 'Which animal says "Meow Meow"?',
          options: ['Dog', 'Cat', 'Cow', 'Lion'],
          correctOptionIndex: 1,
          explanation: 'Cats make a cheerful "Meow Meow" sound!',
        ),
        QuizQuestion(
          id: 'q_a2',
          moduleId: 'animals',
          question: 'Which animal is known as the "King of the Jungle"?',
          options: ['Monkey', 'Elephant', 'Lion', 'Penguin'],
          correctOptionIndex: 2,
          explanation: 'The brave Lion is celebrated as the King of the Jungle!',
        ),
        QuizQuestion(
          id: 'q_a3',
          moduleId: 'animals',
          question: 'Which animal gives us sweet, healthy milk?',
          options: ['Tiger', 'Cow', 'Duck', 'Dolphin'],
          correctOptionIndex: 1,
          explanation: 'Cows give us fresh milk that builds strong bones!',
        ),
        QuizQuestion(
          id: 'q_a4',
          moduleId: 'animals',
          question: 'Which animal has 8 flexible tentacles and lives in the sea?',
          options: ['Octopus', 'Horse', 'Sheep', 'Giraffe'],
          correctOptionIndex: 0,
          explanation: 'An octopus has 8 long arms and 3 hearts!',
        ),
        QuizQuestion(
          id: 'q_a5',
          moduleId: 'animals',
          question: 'Which bird swims underwater and lives on icy snow?',
          options: ['Eagle', 'Parrot', 'Penguin', 'Robin'],
          correctOptionIndex: 2,
          explanation: 'Penguins are amazing swimmers in freezing Antarctica!',
        ),
      ],
    ),
    QuizTopic(
      id: 'alphabet',
      title: 'Alphabet & Phonics',
      description: 'Letters, sounds & matching words',
      emoji: '🔤',
      themeColor: AppColors.primary,
      questions: const [
        QuizQuestion(
          id: 'q_ab1',
          moduleId: 'alphabet',
          question: 'What letter does "Apple" start with?',
          options: ['Letter B', 'Letter A', 'Letter C', 'Letter D'],
          correctOptionIndex: 1,
          explanation: 'A is for Apple! 🍎',
        ),
        QuizQuestion(
          id: 'q_ab2',
          moduleId: 'alphabet',
          question: 'Which word starts with the letter "Z"?',
          options: ['Zebra', 'Elephant', 'Monkey', 'Tiger'],
          correctOptionIndex: 0,
          explanation: 'Z is for Zebra! 🦓',
        ),
        QuizQuestion(
          id: 'q_ab3',
          moduleId: 'alphabet',
          question: 'What is the very first letter of the English alphabet?',
          options: ['Z', 'M', 'A', 'B'],
          correctOptionIndex: 2,
          explanation: 'A is the first letter of the alphabet!',
        ),
        QuizQuestion(
          id: 'q_ab4',
          moduleId: 'alphabet',
          question: 'Which of these items starts with the letter "B"?',
          options: ['Cat', 'Ball', 'Orange', 'Kite'],
          correctOptionIndex: 1,
          explanation: 'B is for bouncy Ball! ⚽',
        ),
        QuizQuestion(
          id: 'q_ab5',
          moduleId: 'alphabet',
          question: 'What letter comes right after "D"?',
          options: ['C', 'F', 'E', 'G'],
          correctOptionIndex: 2,
          explanation: 'A, B, C, D, E! Letter E comes after D.',
        ),
      ],
    ),
    QuizTopic(
      id: 'numbers',
      title: 'Numbers & Counting',
      description: 'Count items & find the right numeral',
      emoji: '🔢',
      themeColor: AppColors.secondary,
      questions: const [
        QuizQuestion(
          id: 'q_n1',
          moduleId: 'numbers',
          question: 'How many fingers do you have on one hand?',
          options: ['3', '4', '5', '10'],
          correctOptionIndex: 2,
          explanation: 'We have 5 fingers on each hand! 🖐️',
        ),
        QuizQuestion(
          id: 'q_n2',
          moduleId: 'numbers',
          question: 'What number comes right after 6?',
          options: ['5', '7', '8', '9'],
          correctOptionIndex: 1,
          explanation: 'Count: 5, 6, 7! 7 comes after 6.',
        ),
        QuizQuestion(
          id: 'q_n3',
          moduleId: 'numbers',
          question: 'How many legs does a spider or octopus have?',
          options: ['4', '6', '8', '10'],
          correctOptionIndex: 2,
          explanation: 'Both spiders and octopuses have 8 legs/arms! 🐙',
        ),
        QuizQuestion(
          id: 'q_n4',
          moduleId: 'numbers',
          question: 'If you have 2 apples and get 2 more, how many do you have?',
          options: ['3', '4', '5', '6'],
          correctOptionIndex: 1,
          explanation: '2 + 2 = 4 apples! 🍎🍎🍎🍎',
        ),
        QuizQuestion(
          id: 'q_n5',
          moduleId: 'numbers',
          question: 'How many colors are there in a bright rainbow?',
          options: ['5', '6', '7', '8'],
          correctOptionIndex: 2,
          explanation: 'A rainbow always has 7 beautiful colors! 🌈',
        ),
      ],
    ),
    QuizTopic(
      id: 'colors_shapes',
      title: 'Colors & Shapes',
      description: 'Geometry, mixing & recognizing shapes',
      emoji: '🎨',
      themeColor: AppColors.candyPink,
      questions: const [
        QuizQuestion(
          id: 'q_cs1',
          moduleId: 'shapes',
          question: 'Which shape is round and has 0 straight sides?',
          options: ['Square', 'Triangle', 'Circle', 'Rectangle'],
          correctOptionIndex: 2,
          explanation: 'A circle is completely round like a coin or clock! ⭕',
        ),
        QuizQuestion(
          id: 'q_cs2',
          moduleId: 'colors',
          question: 'What color do you get when you mix Blue and Yellow?',
          options: ['Green', 'Orange', 'Purple', 'Pink'],
          correctOptionIndex: 0,
          explanation: 'Blue + Yellow makes magical Green! 🍃',
        ),
        QuizQuestion(
          id: 'q_cs3',
          moduleId: 'shapes',
          question: 'How many straight sides does a Triangle have?',
          options: ['2', '3', '4', '5'],
          correctOptionIndex: 1,
          explanation: 'A triangle always has 3 sides like a pizza slice! 🔺',
        ),
        QuizQuestion(
          id: 'q_cs4',
          moduleId: 'colors',
          question: 'What color is a ripe banana and the bright sun?',
          options: ['Red', 'Yellow', 'Blue', 'Brown'],
          correctOptionIndex: 1,
          explanation: 'Bananas and the warm sun are Sunny Yellow! ☀️',
        ),
        QuizQuestion(
          id: 'q_cs5',
          moduleId: 'shapes',
          question: 'Which shape has 4 sides that are all the exact same length?',
          options: ['Rectangle', 'Triangle', 'Square', 'Circle'],
          correctOptionIndex: 2,
          explanation: 'A square has 4 sides of identical length! 🟧',
        ),
      ],
    ),
  ];

  void _startQuiz(QuizTopic topic) {
    setState(() {
      _activeTopic = topic;
      _currentQuestionIndex = 0;
      _selectedOptionIndex = -1;
      _hasSubmitted = false;
      _correctCount = 0;
      _quizFinished = false;
    });

    _speakCurrentQuestion();
  }

  void _speakCurrentQuestion() {
    if (_activeTopic == null) return;
    final q = _activeTopic!.questions[_currentQuestionIndex];
    final tts = Provider.of<TtsService>(context, listen: false);
    tts.speak('${q.question} Is it ${q.options.join(", or ")}?');
  }

  void _selectOption(int index) {
    if (_hasSubmitted) return;

    final q = _activeTopic!.questions[_currentQuestionIndex];
    final isCorrect = q.isCorrect(index);
    final tts = Provider.of<TtsService>(context, listen: false);

    setState(() {
      _selectedOptionIndex = index;
      _hasSubmitted = true;
      if (isCorrect) {
        _correctCount++;
        tts.speak('Awesome! That is correct! ${q.explanation}');
      } else {
        tts.speak('Not quite! The correct answer is ${q.options[q.correctOptionIndex]}. ${q.explanation}');
      }
    });
  }

  void _nextQuestion() {
    if (_activeTopic == null) return;

    if (_currentQuestionIndex < _activeTopic!.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = -1;
        _hasSubmitted = false;
      });
      _speakCurrentQuestion();
    } else {
      // Quiz Finished - Award Coins and complete lesson
      final total = _activeTopic!.questions.length;
      final coinsEarned = _correctCount * 10;

      final learning = Provider.of<LearningProvider>(context, listen: false);
      learning.completeLesson(AppConstants.moduleQuiz, coinReward: coinsEarned);

      final result = QuizResult.calculate(
        id: 'res_${DateTime.now().millisecondsSinceEpoch}',
        moduleId: _activeTopic!.id,
        userId: 'active_learner',
        totalQuestions: total,
        correctAnswers: _correctCount,
      );

      final tts = Provider.of<TtsService>(context, listen: false);
      tts.speak('Quiz completed! You scored ${result.scorePercentage.toInt()}% and earned ${result.starsEarned} stars! Fantastic effort!');

      setState(() {
        _quizFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);
    final isTablet = ResponsiveUtil.isTablet(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _activeTopic == null ? 'Quiz Arena 🏆' : _activeTopic!.title,
          style: GoogleFonts.fredoka(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        leading: _activeTopic != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  setState(() => _activeTopic = null);
                },
              )
            : null,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: _activeTopic == null
              ? _buildTopicSelection(horizontalPadding, isTablet)
              : (_quizFinished
                  ? _buildResultsScreen(horizontalPadding, isTablet)
                  : _buildQuizArena(horizontalPadding, isTablet)),
        ),
      ),
    );
  }

  /// Screen 1: Quiz Topic Selection
  Widget _buildTopicSelection(double horizontalPadding, bool isTablet) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF2ECE0), width: 1.5),
              boxShadow: AppColors.softShadow,
            ),
            child: Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Your Knowledge!',
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Answer fun questions, earn shining stars and win coins! 🪙',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Choose a Challenge 🎯',
            style: GoogleFonts.fredoka(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Topics List
          ..._topics.map((topic) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: topic.themeColor.withValues(alpha: 0.35),
                  width: 1.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: topic.themeColor.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _startQuiz(topic),
                  borderRadius: BorderRadius.circular(22),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: topic.themeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: topic.themeColor.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(topic.emoji, style: const TextStyle(fontSize: 28)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic.title,
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                topic.description,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: topic.themeColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${topic.questions.length} Questions',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: topic.themeColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('🪙 +50 Coins', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB78103))),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: topic.themeColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Screen 2: Active Question Arena
  Widget _buildQuizArena(double horizontalPadding, bool isTablet) {
    final questions = _activeTopic!.questions;
    final currentQ = questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / questions.length;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question Progress Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of ${questions.length}',
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD54F)),
                ),
                child: Row(
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      'Score: $_correctCount',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB78103),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Linear Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFECE7DE),
              valueColor: AlwaysStoppedAnimation<Color>(_activeTopic!.themeColor),
            ),
          ),

          const SizedBox(height: 20),

          // Question Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: _activeTopic!.themeColor.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: AppColors.softShadow,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        currentQ.question,
                        style: GoogleFonts.fredoka(
                          fontSize: isTablet ? 24 : 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.35,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _speakCurrentQuestion,
                      tooltip: 'Hear Question',
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _activeTopic!.themeColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.volume_up_rounded,
                          color: _activeTopic!.themeColor,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Four Option Buttons
          ...List.generate(currentQ.options.length, (i) {
            final optionText = currentQ.options[i];
            final isSelected = _selectedOptionIndex == i;
            final isCorrectOption = i == currentQ.correctOptionIndex;

            Color backgroundColor = Colors.white;
            Color borderColor = const Color(0xFFE5DFD3);
            Widget? statusIcon;

            if (_hasSubmitted) {
              if (isCorrectOption) {
                backgroundColor = const Color(0xFFE8F5E9);
                borderColor = AppColors.mintGreen;
                statusIcon = const Icon(Icons.check_circle_rounded, color: AppColors.mintGreen, size: 24);
              } else if (isSelected && !isCorrectOption) {
                backgroundColor = const Color(0xFFFFEBEE);
                borderColor = AppColors.error;
                statusIcon = const Icon(Icons.cancel_rounded, color: AppColors.error, size: 24);
              }
            } else if (isSelected) {
              borderColor = _activeTopic!.themeColor;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _hasSubmitted ? null : () => _selectOption(i),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Row(
                      children: [
                        // Option Letter (A, B, C, D)
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: _hasSubmitted && isCorrectOption
                                ? AppColors.mintGreen
                                : (_hasSubmitted && isSelected ? AppColors.error : _activeTopic!.themeColor.withValues(alpha: 0.15)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + i), // A, B, C, D
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _hasSubmitted && (isCorrectOption || isSelected)
                                    ? Colors.white
                                    : _activeTopic!.themeColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Option text
                        Expanded(
                          child: Text(
                            optionText,
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),

                        if (statusIcon != null) statusIcon,
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // Immediate Feedback & Next Button
          if (_hasSubmitted) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: currentQ.isCorrect(_selectedOptionIndex)
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: currentQ.isCorrect(_selectedOptionIndex)
                      ? AppColors.mintGreen
                      : const Color(0xFFFFB74D),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    currentQ.isCorrect(_selectedOptionIndex) ? '🎉' : '💡',
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentQ.explanation,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: _activeTopic!.themeColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
              ),
              child: Text(
                _currentQuestionIndex < questions.length - 1
                    ? 'Next Question ➡️'
                    : 'See My Results! 🌟',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Screen 3: Final Results & Celebration Screen
  Widget _buildResultsScreen(double horizontalPadding, bool isTablet) {
    final total = _activeTopic!.questions.length;
    // Academic Project Scoring Algorithm: score = (correct / total) * 100
    final double scorePercentage = total > 0 ? ((_correctCount / total) * 100) : 0.0;

    int stars;
    String praise;
    if (scorePercentage >= 90) {
      stars = 3;
      praise = 'Superstar! Perfect Knowledge! 🏆';
    } else if (scorePercentage >= 60) {
      stars = 2;
      praise = 'Great Job! You\'re getting smarter! 🌟';
    } else {
      stars = 1;
      praise = 'Good Effort! Practice makes perfect! 💪';
    }

    final coinsEarned = _correctCount * 10;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Star Trophy Container
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFFF2ECE0), width: 2),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  children: [
                    // Glowing Celebration Stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        final isLit = i < stars;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            isLit ? Icons.star_rounded : Icons.star_border_rounded,
                            size: 52,
                            color: isLit ? const Color(0xFFFFB300) : const Color(0xFFE0E0E0),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    // Praise Text
                    Text(
                      praise,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Academic Score Percentage Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F7F2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFEADBCE)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${scorePercentage.toInt()}%',
                            style: GoogleFonts.fredoka(
                              fontSize: 54,
                              fontWeight: FontWeight.w800,
                              color: scorePercentage >= 60 ? AppColors.mintGreen : AppColors.secondaryDark,
                            ),
                          ),
                          Text(
                            '$_correctCount of $total Questions Correct',
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Formula: ($_correctCount / $total) × 100',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textLight,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Coins Earned Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFD54F)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            '+$coinsEarned Coins Earned!',
                            style: GoogleFonts.fredoka(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFB78103),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Retry Button
                    ElevatedButton.icon(
                      onPressed: () => _startQuiz(_activeTopic!),
                      icon: const Icon(Icons.replay_rounded, size: 22),
                      label: const Text('Try Again 🔄'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _activeTopic!.themeColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Choose Another Topic Button
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _activeTopic = null),
                      icon: const Icon(Icons.grid_view_rounded, size: 20),
                      label: const Text('Choose Another Quiz'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Continue to Home Button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Back to Home Dashboard 🏠',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
