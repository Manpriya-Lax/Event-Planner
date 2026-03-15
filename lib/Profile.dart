import 'dart:math';

import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<String> getUsername() async {
  User? user = FirebaseAuth.instance.currentUser;

  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get();

  return doc['username'];
}
Future<String> avatar() async {
  User? user = FirebaseAuth.instance.currentUser;

  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get();

  return doc['avatarId'].toString();
}




  @override
  Widget build(BuildContext context) {

        User? user = FirebaseAuth.instance.currentUser;

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
            FutureBuilder(
              future: avatar(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {

      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    }

    if (!snapshot.hasData) {
      return const Text("No avatar");
    }

                return Container(
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
                  child: ClipOval(
                    child: Image.asset(
                      "assets/imgs/${snapshot.data}.png",
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  )
                );
              }
            ),

            const SizedBox(height: 30),

            // 🧑 Name Box
            FutureBuilder(
  future: getUsername(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    
      return _profileBox("Name", snapshot.data.toString());

  },
),

            const SizedBox(height: 20),

            // 📧 Email Box
            _profileBox("Email", user?.email ?? "No Email"),
            
            


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