import 'package:eventplanner/firebase_options.dart';
import 'package:eventplanner/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';
import 'package:eventplanner/login.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

 Future<void> _registerUser() async {
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
              } on FirebaseAuthException catch (e) {
                print("Firebase Error Code: ${e.code}");
                print("Firebase Error Message: ${e.message}");
              } catch (e) {
                print("General Error: $e");
              }
            }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.ink,
        elevation: 0,
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),

              _brutalField(
                hint: "Full Name",
                controller: nameController,
                keyboardType: TextInputType.name,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              _brutalField(
                hint: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Enter email";
                  }
                  if (!v.contains("@")) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              _brutalField(
                hint: "Password",
                controller: passwordController,
                isPassword: true,
                hideText: _hidePassword,
                toggleHide: () {
                  setState(() => _hidePassword = !_hidePassword);
                },
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Enter password";
                  }
                  if (v.length < 8) {
                    return "Password must be at least 8 characters";
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(v)) {
                    return "Include at least one uppercase letter";
                  }
                  if (!RegExp(r'[a-z]').hasMatch(v)) {
                    return "Include at least one lowercase letter";
                  }
                  if (!RegExp(r'[0-9]').hasMatch(v)) {
                    return "Include at least one number";
                  }
                  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) {
                    return "Include at least one special character";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              _brutalField(
                hint: "Confirm Password",
                controller: confirmPasswordController,
                isPassword: true,
                hideText: _hideConfirmPassword,
                toggleHide: () {
                  setState(() => _hideConfirmPassword = !_hideConfirmPassword);
                },
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Confirm your password";
                  }
                  if (v != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 28),

              _brutalButton(
                text: "Create Account",
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // ✅ Here you can add Firebase sign up later
                    
              WidgetsFlutterBinding.ensureInitialized();
                await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform );
                var instance = FirebaseAuth.instance;
                print (instance);

                var credential = await instance.createUserWithEmailAndPassword(

                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  
                  
                  );
                  print(credential);
  
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registered Successfully!")),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const loginPage()),
                    );
                  }
                },
              ),

              const SizedBox(height: 18),

             

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context, '/login',
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Brutal UI TextField
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
            horizontal: 18,
            vertical: 15,
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

  // ✅ Brutal UI Button
  Widget _brutalButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
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