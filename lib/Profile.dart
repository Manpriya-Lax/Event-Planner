import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.ink,
        elevation: 0,
        title: const Text("Profile"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 👤 Profile Picture
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.mint,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.ink,
                  width: 3,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.ink,
                    offset: Offset(5, 5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 30),

            // 🧑 Name Box
            _profileBox("Name", "Manpriya Laksahan"),

            const SizedBox(height: 20),

            // 📧 Email Box
            _profileBox("Email", "example@email.com"),

            const SizedBox(height: 40),

            // ✏️ Edit Button
            _actionButton(
              text: "Edit Profile",
              icon: Icons.edit,
              onTap: () {
                print("Edit Profile");
              },
            ),

            const SizedBox(height: 20),

            // 🚪 Logout Button
            _actionButton(
              text: "Logout",
              icon: Icons.logout,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 Profile Info Box
  Widget _profileBox(String title, String value) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.ink,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ink,
            offset: Offset(5, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  // 🔥 Action Button
  Widget _actionButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.ink,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.ink,
              offset: Offset(5, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.ink),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}