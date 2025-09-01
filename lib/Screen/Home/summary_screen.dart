import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camtech_assessment_test/data/QuestionQuiz.dart';

class QuizHistoryManager {
  static final Map<String, List<Map<String, dynamic>>> _quizHistory = {};

  static void addQuizResult(String quizId, Map<String, dynamic> result) {
    if (_quizHistory[quizId] == null) {
      _quizHistory[quizId] = [];
    }
    _quizHistory[quizId]!.add(result);

    if (_quizHistory[quizId]!.length > 10) {
      _quizHistory[quizId] = _quizHistory[quizId]!.sublist(
        _quizHistory[quizId]!.length - 10,
      );
    }
  }

  static List<Map<String, dynamic>> getQuizHistory(String quizId) {
    return _quizHistory[quizId] ?? [];
  }

  static void clearHistory() {
    _quizHistory.clear();
  }

  static void clearQuizHistory(String quizId) {
    _quizHistory.remove(quizId);
  }
}

class SummaryScreen extends StatefulWidget {
  final int totalCorrectAnswer;
  final List<QuestionQuiz> summaryQuestions;
  final VoidCallback onRestartQuiz;
  final String quizId;

  const SummaryScreen(
    this.totalCorrectAnswer,
    this.summaryQuestions,
    this.onRestartQuiz, {
    Key? key,
    this.quizId = 'default_quiz',
  }) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  List<Map<String, dynamic>> quizHistory = [];

  final Color _backgroundColor = const Color(0xFF121212);
  final Color _cardColor = const Color(0xFF1F1F2E);
  final Color _borderColor = Colors.deepPurpleAccent;

  @override
  void initState() {
    super.initState();
    _saveCurrentQuizResult();
    _loadQuizHistory();
  }

  void _loadQuizHistory() {
    setState(() {
      quizHistory = QuizHistoryManager.getQuizHistory(widget.quizId);
    });
  }

  void _saveCurrentQuizResult() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final currentResult = {
      'timestamp': timestamp,
      'totalQuestions': widget.summaryQuestions.length,
      'correctAnswers': widget.totalCorrectAnswer,
      'wrongAnswers':
          widget.summaryQuestions.length - widget.totalCorrectAnswer,
      'percentage': widget.summaryQuestions.isNotEmpty
          ? ((widget.totalCorrectAnswer / widget.summaryQuestions.length) * 100)
              .round()
          : 0,
      'questions': widget.summaryQuestions.map((q) {
        return {
          'question': q.question,
          'correctAnswer': q.answer,
          'userAnswer': q.customerAnwser,
          'isCorrect': q.answer == q.customerAnwser,
          'index': q.index,
        };
      }).toList(),
    };

    QuizHistoryManager.addQuizResult(widget.quizId, currentResult);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.summaryQuestions.length;
    final correct = widget.totalCorrectAnswer;
    final wrong = total - correct;
    final percentage = total > 0 ? ((correct / total) * 100).round() : 0;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Quiz Summary',
          style: GoogleFonts.kantumruyPro(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9F44D3), Color(0xFF4B2EF1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  total == 0
                      ? 'No Questions'
                      : percentage >= 80
                          ? 'Excellent!'
                          : percentage >= 70
                              ? 'Good Job!'
                              : percentage >= 50
                                  ? 'Keep Trying!'
                                  : 'Need More Practice!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  total == 0
                      ? 'No quiz data available'
                      : '$correct Correct • $wrong Wrong • $total Total',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildScoreCard(percentage, correct, wrong, total),
                    const SizedBox(height: 24),
                    _buildPerformanceHistory(),
                    const SizedBox(height: 30),
                    if (widget.summaryQuestions.isNotEmpty)
                      Text(
                        'Review Your Answers',
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    const SizedBox(height: 16),
                    ...widget.summaryQuestions.map(_buildQuestionCard),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(int percentage, int correct, int wrong, int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: _borderColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage >= 70 ? Colors.green : Colors.orange,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$percentage%',
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: percentage >= 70 ? Colors.green : Colors.orange,
                    ),
                  ),
                  Text(
                    'Score',
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Correct', correct, Colors.green, Icons.check),
              _buildStatItem('Wrong', wrong, Colors.red, Icons.close),
              _buildStatItem('Total', total, Colors.blue, Icons.list),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: GoogleFonts.kantumruyPro(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.kantumruyPro(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceHistory() {
    if (quizHistory.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance History',
            style: GoogleFonts.kantumruyPro(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...quizHistory.take(5).map((attempt) {
            final date = DateTime.fromMillisecondsSinceEpoch(attempt['timestamp']);
            final formatted = '${date.day}/${date.month}/${date.year}';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$formatted\n${attempt['correctAnswers']}/${attempt['totalQuestions']} correct',
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: attempt['percentage'] >= 70 ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${attempt['percentage']}%',
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuestionQuiz q) {
    final isCorrect = q.answer == q.customerAnwser;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Question ${q.index ?? 0}',
                style: GoogleFonts.kantumruyPro(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            q.question ?? 'No question',
            style: GoogleFonts.kantumruyPro(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your answer: ${q.customerAnwser ?? 'None'}',
            style: GoogleFonts.kantumruyPro(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          if (!isCorrect)
            Text(
              'Correct: ${q.answer ?? ''}',
              style: GoogleFonts.kantumruyPro(
                fontSize: 14,
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: _clearHistory,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          label: Text(
            'Clear History',
            style: GoogleFonts.kantumruyPro(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        title: Text(
          'Clear History',
          style: GoogleFonts.kantumruyPro(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to clear your quiz history?',
          style: GoogleFonts.kantumruyPro(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.kantumruyPro(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              QuizHistoryManager.clearQuizHistory(widget.quizId);
              setState(() {
                quizHistory.clear();
              });
              Navigator.of(context).pop();
            },
            child: Text(
              'Clear',
              style: GoogleFonts.kantumruyPro(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
