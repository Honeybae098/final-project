import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final Function(String) startQuiz;

  const HomeScreen({Key? key, required this.startQuiz}) : super(key: key);

  final List<Map<String, dynamic>> quizCategories = const [
    {'title': 'Science', 'icon': Icons.science},
    {'title': 'History', 'icon': Icons.account_balance},
    {'title': 'Math', 'icon': Icons.calculate},
    {'title': 'Technology', 'icon': Icons.memory},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Quiz Explorer',
          style: GoogleFonts.kantumruyPro(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9F44D3), Color(0xFF4B2EF1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  '🔥 Quiz Challenge Week!\nEarn Rewards & Badges',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'Choose a Category',
              style: GoogleFonts.kantumruyPro(
                fontSize: 20,
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            // Category Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
                children: quizCategories.map((category) {
                  return GestureDetector(
                    onTap: () => startQuiz(category['title']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F2E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.deepPurpleAccent, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurpleAccent.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category['icon'], color: Colors.white, size: 36),
                          const SizedBox(height: 12),
                          Text(
                            category['title'],
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
