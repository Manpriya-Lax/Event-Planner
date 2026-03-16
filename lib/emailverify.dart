
import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';
import 'package:eventplanner/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Emailverify extends StatefulWidget {
  const Emailverify({super.key});

  @override
  State<Emailverify> createState() => _EmailverifyState();
}

class _EmailverifyState extends State<Emailverify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

       backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.ink,
        elevation: 0,
        title: const Text("Email Verification"),
      ),


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("A verification email has been sent to your email address. Please verify your email to continue."
              ,style: TextStyle(fontSize: 18, color: AppColors.ink), textAlign: TextAlign.center,),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75.0),
              child: _brutalButton(
                text: 'Verify',
                onTap: ()async  {
                  await FirebaseAuth.instance.currentUser?.reload();
                    var user = FirebaseAuth.instance.currentUser;
                    if (user?.emailVerified ?? false) {
                   Navigator.pushReplacementNamed(context, "/home");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Email not verified yet. Please check your inbox."),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

   Widget _brutalButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.ink, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.ink,
              offset: Offset(5, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}