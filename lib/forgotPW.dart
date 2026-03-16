import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


class Forgotpw extends StatefulWidget {
  const Forgotpw({super.key});

  @override
  State<Forgotpw> createState() => _ForgotpwState();
}

class _ForgotpwState extends State<Forgotpw> {

    final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

   TextStyle textfieldstyle() {
    return TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.ink,
        elevation: 0,
        title: const Text("Forgot Password"),
      ),


      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text("Enter Your Email Address and we will send you a password reset link."
                ,style: TextStyle(fontSize: 18, color: AppColors.ink), textAlign: TextAlign.center,),
              ),        
                                   
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: 
                      _brutalField(
                        hint: "Email",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                    
                        validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Enter email";
                      }
                      if (!v.contains("@")) {
                        return "Enter a valid email";
                      }
                      if (!v.contains(".")) {
                        return "Enter a valid email";
                      }
                      if (v.contains(" ")) {
                        return "Email cannot contain spaces";
                      }
                      return null;
                    },
                      ),
                    ),
                  ),
        
        
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 85.0),
                    child: _brutalButton(
                      text: 'Send Reset Link',
                      onTap: () async{
                        if (_formKey.currentState?.validate() ??
                                      false){
        
                        
                        try{
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
                        Navigator.pushNamed(context,
                         '/login',);
                        
                        } on FirebaseAuthException catch (e) {
                          print(e);

                          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message ?? "Failed to send reset link"),
            ),
          );
                          
                        }
                        
        
                      }
                      },
                    ),
                  )
        
        
        
                ],
          ),
        ),
      ),




    );
  }

  Widget _brutalField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool hideText = false,
    VoidCallback? toggleHide,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? hideText : false,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: toggleHide,
                  icon: Icon(
                    hideText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.ink,
                  ),
                )
              : null,
        ),
      ),
    );
  }


   Widget _brutalButton({
  required String text,
  required Future<void> Function() onTap,
}) {
  return InkWell(
    onTap: () async {
      await onTap();
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
}