import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Answerbutton extends StatelessWidget {
  Answerbutton(this.title, this.handleOnPress);

  final VoidCallback handleOnPress;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        onPressed: handleOnPress,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(
            Color.fromARGB(0, 0, 54, 101),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.kantumruyPro(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
