import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';


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

      appBar: AppBar(title:Align(
          alignment:Alignment.centerRight,
          child: const Text("Forgot Password"),
        )
      ),


      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 30.0),
                child: Text("Enter Your Email Address and we will send you a password reset link."
                ,style: TextStyle(fontSize: 18, color: AppColors.ink), textAlign: TextAlign.center,),
              ),        
                                   
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: 
                      BrutalField(
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
                    child: BrutalButton(
                      text: 'Send Reset Link',
                      onTap: () async{
                        if (_formKey.currentState?.validate() ??
                                      false){
        
                        
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        try{
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
                        navigator.pushNamed('/login');
                        
                        } on FirebaseAuthException catch (e) {

                          messenger.showSnackBar(
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


}