import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userName = "Loading...".obs;
  var userEmail = "".obs;
  var isLoading = false.obs;

  final TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? "";
      try {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          userName.value = data['name'] ?? "No Name";
          nameController.text = userName.value;
        }
      } catch (e) {
        userName.value = "Error";
      }
    }
  }

  Future<void> updateProfile() async {
    User? user = _auth.currentUser;
    if (user != null && nameController.text.isNotEmpty) {
      isLoading(true);
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'name': nameController.text.trim(),
        });
        userName.value = nameController.text.trim();
        Get.back(); // Bottom sheet close karne ke liye
        Get.snackbar("Success", "Profile updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        Get.snackbar("Error", "Update failed", backgroundColor: Colors.redAccent, colorText: Colors.white);
      } finally {
        isLoading(false);
      }
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}