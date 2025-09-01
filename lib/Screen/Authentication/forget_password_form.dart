import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'enter_otp_screen.dart';

class ForgotPasswordForm extends StatefulWidget {
  final VoidCallback onBack;
  
  const ForgotPasswordForm({super.key, required this.onBack});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  void _sendOtp() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 8) {
      _showMessage("Please enter a valid phone number.");
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() => _isLoading = false);
    
    // Navigate to OTP screen after sending
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterOtpScreen(phoneNumber: phone),
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF4141A0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          
          // Header Section
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4141A0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 40,
                    color: Color(0xFF4141A0),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Forgot Password?',
                  style: GoogleFonts.kantumruyPro(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Don\'t worry! Enter your phone number and we\'ll send you a verification code.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kantumruyPro(
                    color: Colors.white60,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Phone Number Field
          TextField(
            controller: _phoneController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Phone Number",
              labelStyle: const TextStyle(color: Colors.white70),
              hintText: "Enter your phone number",
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.phone, color: Colors.white54),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Send OTP Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4141A0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    "Send OTP Code",
                    style: GoogleFonts.kantumruyPro(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Back to Login Button
          Center(
            child: TextButton.icon(
              onPressed: widget.onBack,
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: Colors.white70,
              ),
              label: Text(
                "Back to Login",
                style: GoogleFonts.kantumruyPro(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Help Text
          Center(
            child: Text(
              'Having trouble? Contact support',
              style: GoogleFonts.kantumruyPro(
                color: Colors.white38,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}