import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader("Appearance"),
          Obx(() => SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Change app theme to dark"),
            value: controller.isDarkMode.value,
            activeColor: AppColors.accentPrimary,
            onChanged: (value) => controller.toggleTheme(value),
          )),

          _buildSectionHeader("Notifications"),
          Obx(() => SwitchListTile(
            title: const Text("Push Notifications"),
            subtitle: const Text("Daily reminders for learning"),
            value: controller.isNotificationsOn.value,
            activeColor: AppColors.accentPrimary,
            onChanged: (value) => controller.toggleNotifications(value),
          )),

          _buildSectionHeader("Account Security"),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: AppColors.accentPrimary),
            title: const Text("Change Password"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => controller.changePassword(),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.orange),
            title: const Text("Logout"),
            onTap: () => controller.logout(),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text("Delete Account", style: TextStyle(color: Colors.red)),
            onTap: () => _showDeleteDialog(context, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(color: AppColors.accentPrimary, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account?"),
        content: const Text("Kya aap waqai account delete karna chahte hain?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () => controller.deleteAccount(),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}