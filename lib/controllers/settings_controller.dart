import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';

class SettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isDarkMode = (themeNotifier.value == ThemeMode.dark).obs;
  var isNotificationsOn = true.obs;

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleNotifications(bool value) {
    isNotificationsOn.value = value;
  }

  Future<void> changePassword() async {
    User? user = _auth.currentUser;
    if (user != null && user.email != null) {
      try {
        await _auth.sendPasswordResetEmail(email: user.email!);
        Get.snackbar("Success", "Reset link sent to ${user.email}",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        Get.snackbar("Error", e.toString(),
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }

  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Error", "Please re-login to delete account",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }
}