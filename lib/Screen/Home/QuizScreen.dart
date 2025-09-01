import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camtech_assessment_test/constants/questions.dart';
import 'package:camtech_assessment_test/data/QuestionQuiz.dart';

class QuizScreen extends StatefulWidget {
  final VoidCallback onExitQuiz;
  final String? category;
  final Function(int totalCorrect, List<QuestionQuiz> summaryQuestions)? onQuizComplete;

  const QuizScreen({
    super.key,
    required this.onExitQuiz,
    this.category,
    this.onQuizComplete,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int questionIndex = 0;
  List<String?> selections = [];
  bool isAnswered = false;
  String? selectedAnswer;
  int timeRemaining = 30;
  bool isTimerActive = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (!isTimerActive) return;
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && isTimerActive && timeRemaining > 0) {
        setState(() => timeRemaining--);
        _startTimer();
      } else if (mounted && timeRemaining == 0) {
        _selectAnswer(null);
      }
    });
  }

  void _selectAnswer(String? answer) {
    if (isAnswered) return;

    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
      isTimerActive = false;
      selections.add(answer);
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      if (questionIndex + 1 < listQuestions.length) {
        setState(() {
          questionIndex++;
          isAnswered = false;
          selectedAnswer = null;
          timeRemaining = 30;
          isTimerActive = true;
        });
        _startTimer();
      } else {
        // Quiz finished, send results back via callback
        _sendResults();
      }
    });
  }

  void _sendResults() {
    int totalCorrectAnswer = 0;
    List<QuestionQuiz> summaryQuestions = [];

    for (int i = 0; i < selections.length; i++) {
      final original = listQuestions[i];
      final answer = selections[i];
      summaryQuestions.add(
        QuestionQuiz(
          question: original.question,
          options: original.options,
          answer: original.answer,
        )
          ..customerAnwser = answer
          ..index = i + 1,
      );
      if (answer == original.answer) totalCorrectAnswer++;
    }

    if (widget.onQuizComplete != null) {
      widget.onQuizComplete!(totalCorrectAnswer, summaryQuestions);
    }
  }

  void restartQuiz() {
    setState(() {
      questionIndex = 0;
      selections.clear();
      isAnswered = false;
      selectedAnswer = null;
      timeRemaining = 30;
      isTimerActive = true;
    });
    _startTimer();
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2E2E4D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Exit Quiz?',
          style: GoogleFonts.kantumruyPro(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Are you sure you want to exit? Your progress will be lost.',
          style: GoogleFonts.kantumruyPro(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[400],
              textStyle: GoogleFonts.kantumruyPro(fontWeight: FontWeight.w600),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onExitQuiz();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: GoogleFonts.kantumruyPro(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    isTimerActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If quiz finished, show a blank container to avoid returning summary here
    if (questionIndex >= listQuestions.length) {
      return Container(color: const Color(0xFF1B1B1B));
    }

    final QuestionQuiz questionQuiz = listQuestions[questionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Your existing UI code here (header, progress bar, question card, options, exit button)
              // (Just copy your existing widget tree here exactly)

              // Header with Category and Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category ?? 'Quiz',
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Question ${questionIndex + 1} / ${listQuestions.length}",
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Timer badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: timeRemaining <= 10
                          ? Colors.redAccent.withOpacity(0.85)
                          : Colors.deepPurpleAccent.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      '${timeRemaining}s',
                      style: GoogleFonts.kantumruyPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: (questionIndex + 1) / listQuestions.length,
                  backgroundColor: Colors.white.withOpacity(0.12),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: 32),

              // Question card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A46),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurpleAccent.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Question Text
                      Text(
                        questionQuiz.question ?? "",
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 36),

                      // Answer options
                      Expanded(
                        child: ListView.separated(
                          itemCount: questionQuiz.options.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final option = questionQuiz.options[index];
                            final isSelected = selectedAnswer == option;
                            final isCorrect = option == questionQuiz.answer;

                            Color bgColor() {
                              if (!isAnswered) {
                                return isSelected
                                    ? Colors.deepPurpleAccent.withOpacity(0.25)
                                    : const Color(0xFF3A3A5C);
                              }
                              if (isCorrect) return Colors.green.withOpacity(0.3);
                              if (isSelected && !isCorrect) return Colors.red.withOpacity(0.3);
                              return const Color(0xFF3A3A5C);
                            }

                            Color borderColor() {
                              if (!isAnswered) {
                                return isSelected ? Colors.deepPurpleAccent : Colors.transparent;
                              }
                              if (isCorrect) return Colors.greenAccent;
                              if (isSelected && !isCorrect) return Colors.redAccent;
                              return Colors.transparent;
                            }

                            return ElevatedButton(
                              onPressed: isAnswered ? null : () => _selectAnswer(option),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: bgColor(),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(color: borderColor(), width: 2),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: borderColor() == Colors.transparent
                                          ? Colors.deepPurpleAccent.withOpacity(0.8)
                                          : borderColor(),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      String.fromCharCode(65 + index),
                                      style: GoogleFonts.kantumruyPro(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  if (isAnswered && isCorrect)
                                    const Icon(Icons.check_circle, color: Colors.greenAccent, size: 26),
                                  if (isAnswered && isSelected && !isCorrect)
                                    const Icon(Icons.cancel, color: Colors.redAccent, size: 26),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Exit Quiz Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showExitConfirmation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 6,
                    shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
                    textStyle: GoogleFonts.kantumruyPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  child: Text(
                    "Exit Quiz",
                    style: GoogleFonts.kantumruyPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}