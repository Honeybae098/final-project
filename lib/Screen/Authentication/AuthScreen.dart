import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camtech_assessment_test/Screen/Authentication/login_form.dart';
import 'package:camtech_assessment_test/Screen/Authentication/forget_password_form.dart';
import 'package:camtech_assessment_test/Screen/Authentication/signup_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.onLoginSuccess});
  final Function(String) onLoginSuccess;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isForgotPassword = false;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      _isForgotPassword = false;
    });
  }

  void _switchToForgotPassword() {
    setState(() => _isForgotPassword = true);
  }

  void _goBackToLogin() {
    setState(() => _isForgotPassword = false);
  }

  void _handleLoginSuccess(String phone) {
    // Call the callback passed from main.dart
    widget.onLoginSuccess(phone);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Welcome back!',
              style: GoogleFonts.kantumruyPro(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App logo/icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.deepPurpleAccent.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.quiz,
                      size: 60,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Text(
                    _isForgotPassword
                        ? "Reset Password"
                        : _isLogin
                            ? "Welcome Back!"
                            : "Create an Account",
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    _isForgotPassword
                        ? "Enter your email to reset password"
                        : _isLogin
                            ? "Sign in to continue your quiz journey"
                            : "Join us and start your quiz adventure",
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Form container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.deepPurpleAccent.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        if (_isForgotPassword)
                          ForgotPasswordForm(onBack: _goBackToLogin)
                        else if (_isLogin)
                          LoginForm(
                            onLogin: _handleLoginSuccess,
                            onForgotPassword: _switchToForgotPassword,
                            onSwitchMode: _toggleAuthMode,
                          )
                        else
                          SignUpForm(
                            onSignUp: _handleLoginSuccess,
                            onSwitchMode: _toggleAuthMode,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}