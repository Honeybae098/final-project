import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camtech_assessment_test/Screen/Authentication/login_form.dart';
import 'package:camtech_assessment_test/Buttombar/bottom_nav_bar.dart';
import 'package:camtech_assessment_test/Screen/Authentication/forget_password_form.dart';
import 'package:camtech_assessment_test/Screen/Authentication/signup_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            );
          case '/forgot-password':
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Forgot Password'),
                  backgroundColor: Colors.deepPurple,
                ),
                body: ForgotPasswordForm(
                  onBack: () => Navigator.of(context).pop(),
                ),
              ),
            );
          case '/sign-up':
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Sign Up'),
                  backgroundColor: Colors.deepPurple,
                ),
                body: SignUpForm(
                  onSignUp: (phone) {
                    // Your sign-up logic here
                    // After successful signup, you might want to navigate somewhere
                    // Navigator.of(context).pushReplacementNamed('/home');
                  },
                  onSwitchMode: () => Navigator.of(context).pop(),
                ),
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Error'),
                  backgroundColor: Colors.deepPurple,
                ),
                body: const Center(
                  child: Text(
                    'Page not found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}