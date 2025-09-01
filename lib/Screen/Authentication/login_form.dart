import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1B1B1B),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: LoginForm(
            onLogin: (phone) async {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(child: Text("Login successful! Welcome back!")),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              
              // Wait a moment for user to see the success message
              await Future.delayed(const Duration(seconds: 1));
              
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
            onForgotPassword: () {
              // Navigate to forgot password screen
              Navigator.of(context).pushNamed('/forgot-password');
            },
            onSwitchMode: () {
              // Navigate to sign up screen
              Navigator.of(context).pushNamed('/sign-up');
            },
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final void Function(String phone) onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onSwitchMode;

  const LoginForm({
    super.key,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onSwitchMode,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  void _submit() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    if (phone.length < 8) {
      _showMessage('Please enter a valid phone number');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters long');
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    
    widget.onLogin(phone);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        
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
                  Icons.login,
                  size: 40,
                  color: Color(0xFF4141A0),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome Back',
                style: GoogleFonts.kantumruyPro(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to your account to continue',
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
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        
        const SizedBox(height: 20),

        // Password Field
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          icon: Icons.lock,
          obscure: _obscure,
          suffix: IconButton(
            icon: Icon(
              _obscure ? Icons.visibility : Icons.visibility_off,
              color: Colors.white54,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
        
        const SizedBox(height: 16),

        // Remember Me Checkbox
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) => setState(() => _rememberMe = value ?? false),
              activeColor: const Color(0xFF4141A0),
              checkColor: Colors.white,
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => _rememberMe = !_rememberMe),
              child: Text(
                'Remember me',
                style: GoogleFonts.kantumruyPro(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: widget.onForgotPassword,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.kantumruyPro(
                  color: const Color(0xFF4141A0),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),

        // Login Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submit,
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
                    'Login',
                    style: GoogleFonts.kantumruyPro(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        
        const SizedBox(height: 32),

        // Divider with "OR"
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: Colors.white24,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: GoogleFonts.kantumruyPro(
                  color: Colors.white38,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: Colors.white24,
                thickness: 1,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),

        // Sign Up Button
        Center(
          child: TextButton(
            onPressed: widget.onSwitchMode,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.kantumruyPro(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                children: [
                  const TextSpan(text: "Don't have an account? "),
                  TextSpan(
                    text: 'Sign Up',
                    style: GoogleFonts.kantumruyPro(
                      color: const Color(0xFF4141A0),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),

        // Help Text
        Center(
          child: Text(
            'Need help? Contact support',
            style: GoogleFonts.kantumruyPro(
              color: Colors.white38,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
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
        prefixIcon: Icon(icon, color: Colors.white54),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}