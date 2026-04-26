import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || !email.endsWith('@gmail.com')) {
      _showError('Please enter a valid @gmail.com address.');
      return false;
    }
    if (password.isEmpty) {
      _showError('Please enter your password.');
      return false;
    }

    try {
      isLoading(true);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _showError('Incorrect email or password.');
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> signup(String name, String email, String password, String confirmPassword) async {
    if (name.isEmpty) {
      _showError('Please enter your full name.');
      return false;
    }
    if (email.isEmpty || !email.endsWith('@gmail.com')) {
      _showError('Only @gmail.com accounts are allowed.');
      return false;
    }
    if (password.isEmpty || password.length < 6) {
      _showError('Password must be at least 6 characters.');
      return false;
    }
    if (password != confirmPassword) {
      _showError('Passwords do not match.');
      return false;
    }

    try {
      isLoading(true);
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Account Created Successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
      return true;
    } catch (e) {
      _showError('Registration failed. Email might already be in use.');
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    if (email.isEmpty || !email.endsWith('@gmail.com')) {
      _showError('Enter a valid @gmail.com to reset password.');
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Reset link sent to $email",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      _showError('User not found or connection error.');
    }
  }

  void _showError(String message) {
    Get.snackbar("Error", message,
        backgroundColor: Colors.redAccent, colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }
}