import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();

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
                Obx(() => ElevatedButton(
                  onPressed: authController.isLoading.value ? null : () async {
                    bool success = await authController.signup(
                      _nameController.text.trim(),
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                      _confirmPasswordController.text.trim(),
                    );
                    if (success) Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  child: authController.isLoading.value
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                )),
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
        decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppColors.accentPrimary), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 18)),
      ),
    );
  }
}