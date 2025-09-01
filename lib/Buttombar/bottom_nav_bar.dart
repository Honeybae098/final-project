import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camtech_assessment_test/Screen/Home/HomeScreen.dart';
import 'package:camtech_assessment_test/Screen/Home/QuizScreen.dart';
import 'package:camtech_assessment_test/Screen/Home/summary_screen.dart';
import 'package:camtech_assessment_test/Screen/Home/leaderboard_screen.dart';
import 'package:camtech_assessment_test/Screen/Authentication/ProfileScreen.dart';
import 'package:camtech_assessment_test/data/QuestionQuiz.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;
  
  const BottomNavBar({Key? key, this.currentIndex = 0, this.onTap}) : super(key: key);
  
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  
  // These will hold the quiz results to show summary
  int _totalCorrect = 0;
  List<QuestionQuiz> _summaryQuestions = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _startQuiz(String quizTitle) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          category: quizTitle,
          onExitQuiz: () => Navigator.of(context).pop(),
          onQuizComplete: (totalCorrect, summaryQuestions) {
            setState(() {
              _totalCorrect = totalCorrect;
              _summaryQuestions = summaryQuestions;
              _selectedIndex = 1; // Switch to Summary screen tab
            });
            Navigator.of(context).pop(); // Close quiz screen
          },
        ),
      ),
    );
  }

  void _resetQuizData() {
    setState(() {
      _selectedIndex = 0;
      _totalCorrect = 0;
      _summaryQuestions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(
        startQuiz: _startQuiz,
      ),
      SummaryScreen(
        _totalCorrect,
        _summaryQuestions,
        _resetQuizData,
        quizId: 'default_quiz',
      ),
      const LeaderBoardScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B), // Consistent dark background
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.white54,
          currentIndex: _selectedIndex,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.kantumruyPro(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.kantumruyPro(
            fontSize: 12,
          ),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (widget.onTap != null) widget.onTap!(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'Summary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              activeIcon: Icon(Icons.emoji_events),
              label: 'Leaderboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}