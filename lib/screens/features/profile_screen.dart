import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../controllers/profile_controller.dart';
import 'instructor_screen.dart';
import 'settings_screen.dart';
import 'help_info_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.accentPrimary,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            Obx(() => Text(controller.userName.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            Obx(() => Text(controller.userEmail.value, style: const TextStyle(color: Colors.grey))),

            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => _showEditProfileSheet(context, controller),
              icon: const Icon(Icons.edit, size: 18),
              label: const Text("Edit Profile"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentPrimary,
                side: const BorderSide(color: AppColors.accentPrimary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 30),

            _buildMenuCard([
              _buildMenuItem(Icons.settings_outlined, "Settings", () => Get.to(() => const SettingsScreen())),
              _buildMenuItem(Icons.person_search_outlined, "Find Instructor", () => Get.to(() => const InstructorScreen())),
              _buildMenuItem(Icons.help_outline, "Help & Info", () => Get.to(() => const HelpInfoScreen())),
            ]),
            const SizedBox(height: 20),
            _buildMenuCard([
              _buildMenuItem(Icons.logout, "Logout", () => controller.logout(), isLogout: true),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 24, left: 24, right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Edit Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentPrimary),
                onPressed: controller.isLoading.value ? null : () => controller.updateProfile(),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Update", style: TextStyle(color: Colors.white)),
              )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : AppColors.accentPrimary),
      title: Text(title, style: TextStyle(color: isLogout ? Colors.red : AppColors.textPrimary, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}