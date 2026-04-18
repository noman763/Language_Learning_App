import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../database/database_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false; // Loading state add ki

  Future<void> _handleSignup() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter your full name.');
      return;
    }

    if (email.isEmpty) {
      _showError('Please enter your email address.');
      return;
    }

    if (!email.endsWith('@gmail.com')) {
      _showError('Only @gmail.com accounts are allowed.');
      return;
    }

    if (password.isEmpty) {
      _showError('Please enter a password.');
      return;
    }

    if (confirmPassword.isEmpty) {
      _showError('Please confirm your password.');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {

      bool isRegistered = await DatabaseHelper.instance.registerUser(name, email, password);

      if (!mounted) return;

      if (isRegistered) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account Created Successfully! Please login.', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pop(context);
      } else {

        _showError('This email is already registered. Try logging in.');
      }
    } catch (e) {
      _showError('An error occurred during registration.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0, iconTheme: const IconThemeData(color: AppColors.textPrimary)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Create Account', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 40),
                _buildTextField(hint: 'Full Name', icon: Icons.person, obscureText: false, controller: _nameController),
                const SizedBox(height: 20),
                _buildTextField(hint: 'Email', icon: Icons.email, obscureText: false, controller: _emailController),
                const SizedBox(height: 20),
                _buildTextField(hint: 'Password', icon: Icons.lock, obscureText: true, controller: _passwordController),
                const SizedBox(height: 20),
                _buildTextField(hint: 'Confirm Password', icon: Icons.lock_outline, obscureText: true, controller: _confirmPasswordController),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 3
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, required bool obscureText, required TextEditingController controller}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey), prefixIcon: Icon(icon, color: AppColors.accentPrimary), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 18)),
      ),
    );
  }
}