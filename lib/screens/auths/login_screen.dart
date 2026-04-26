import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../dashboard/main_navigation.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.language, size: 80, color: AppColors.accentPrimary),
                const SizedBox(height: 20),
                const Text('Welcome Back', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const Text('Login to continue learning', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 40),
                _buildTextField(hint: 'Email', icon: Icons.email, obscureText: false, controller: _emailController),
                const SizedBox(height: 20),
                _buildTextField(hint: 'Password', icon: Icons.lock, obscureText: true, controller: _passwordController),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () => authController.sendPasswordReset(_emailController.text),
                      child: const Text('Forgot Password?', style: TextStyle(color: AppColors.accentSecondary, fontWeight: FontWeight.w600))
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton(
                  onPressed: authController.isLoading.value ? null : () async {
                    bool success = await authController.login(_emailController.text, _passwordController.text);
                    if (success) Get.offAll(() => const MainNavigation());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  child: authController.isLoading.value
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Log In', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () => Get.to(() => const SignupScreen()),
                      child: const Text('Register', style: TextStyle(color: AppColors.accentPrimary, fontWeight: FontWeight.bold)),
                    ),
                  ],
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
        decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppColors.accentPrimary), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 18)),
      ),
    );
  }
}