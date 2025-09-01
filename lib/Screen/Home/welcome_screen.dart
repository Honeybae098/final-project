import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class WelcomeScreen extends StatelessWidget {
 const WelcomeScreen(this.onStartQuiz, {super.key});


 final VoidCallback onStartQuiz;


 @override
 Widget build(BuildContext context) {
   return Container(
     color: const Color(0xFF1B1B1B),
     padding: const EdgeInsets.symmetric(horizontal: 32.0),
     child: Center(
       child: Column(
         mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Image.asset(
             'assets/quizz-welcome-image.png',
             width: 260,
             height: 260,
             fit: BoxFit.contain,
             color: Colors.deepPurpleAccent.withOpacity(0.9), // subtle purple tint
           ),
           const SizedBox(height: 36),
           Text(
             "Assess your general knowledge",
             textAlign: TextAlign.center,
             style: GoogleFonts.kantumruyPro(
               fontSize: 22,
               fontWeight: FontWeight.bold,
               color: Colors.white,
               letterSpacing: 1.1,
               height: 1.3,
             ),
           ),
           const SizedBox(height: 40),
           SizedBox(
             width: double.infinity,
             child: ElevatedButton(
               onPressed: onStartQuiz,
               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.deepPurpleAccent,
                 padding: const EdgeInsets.symmetric(vertical: 18),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(20),
                 ),
                 elevation: 6,
                 shadowColor: Colors.deepPurpleAccent.withOpacity(0.6),
                 textStyle: GoogleFonts.kantumruyPro(
                   fontWeight: FontWeight.bold,
                   fontSize: 18,
                 ),
               ),
               child: Text(
                 "Start Quiz",
                 style: GoogleFonts.kantumruyPro(color: Colors.white),
               ),
             ),
           ),
         ],
       ),
     ),
   );
 }
}


