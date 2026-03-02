import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController confirmPasswordController =TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? _selectedGender; 


  
  final List<String> _avatars = [
  "assets/imgs/1.png",
  "assets/imgs/2.png",
  "assets/imgs/3.png",
  "assets/imgs/4.png",
  "assets/imgs/5.png",
  "assets/imgs/6.png",
  "assets/imgs/7.png",
  "assets/imgs/8.png",
  "assets/imgs/9.png",
  "assets/imgs/10.png",
  "assets/imgs/11.png",
  "assets/imgs/12.png",
  "assets/imgs/13.png",
  "assets/imgs/14.png",
  "assets/imgs/15.png",
];

int _selectedAvatarIndex = 0;


Future<void> _pickDate(TextEditingController controller) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime(2016, 1, 1),
    firstDate: DateTime(1950), // 🚫 No past dates
    lastDate: DateTime.now(),
  );

  if (picked != null) {
    // Format: DD/MM/YYYY
    final day = picked.day.toString().padLeft(2, '0');
    final month = picked.month.toString().padLeft(2, '0');
    final year = picked.year.toString();
    controller.text = "$day/$month/$year";
  }
}

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

 Future<void> _pickAvatar() async {
  final chosenIndex = await showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Select an Avatar"),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: _avatars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final isSelected = index == _selectedAvatarIndex;

              return InkWell(
                onTap: () => Navigator.pop(context, index),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.ink,
                      width: isSelected ? 4 : 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(_avatars[index]),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );

  if (chosenIndex != null) {
    setState(() => _selectedAvatarIndex = chosenIndex);
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
             // const SizedBox(height: 20),

              GestureDetector(
  onTap: _pickAvatar,
  child: Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.ink, width: 3),
      boxShadow: const [
        BoxShadow(
          color: AppColors.ink,
          offset: Offset(5, 5),
          blurRadius: 0,
        ),
      ],
    ),
    child: CircleAvatar(
      backgroundImage: AssetImage(_avatars[_selectedAvatarIndex]),
    ),
  ),
),
const SizedBox(height: 4),
TextButton(
  onPressed: _pickAvatar,
  child: const Text("Choose Avatar"),
),

              _brutalField(
                hint: "User Name",
                controller: nameController,
                keyboardType: TextInputType.name,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Enter your user name";
                  }
                  if (v.trim().length < 3) {
                    return "User name must be at least 3 characters";
                  }
                   if (v.trim().length > 15) {
                    return "User name cannot exceed 15 characters";
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
                  if (!v.contains(".")) {
                    return "Enter a valid email";
                  }
                  if (v.contains(" ")) {
                    return "Email cannot contain spaces";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              _buildDateField("Date (DD/MM/YYYY)", dateController),

              const SizedBox(height: 18),
              _brutalDropdown(),

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
                    // Firebase sign up
                    
              WidgetsFlutterBinding.ensureInitialized();
                await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform );
                var instance = FirebaseAuth.instance;
                print (instance);

                var credential = await instance.createUserWithEmailAndPassword(

                   email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  

                  
                  );


                  await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
                    'username': nameController.text.trim(), 
                    'avatarId': _selectedAvatarIndex,
                    'createdAt': FieldValue.serverTimestamp(),
                    'DateOfBirth': dateController.text.trim(),
                    'gender': _selectedGender,

                  });


                  var user =credential.user;
                  await user?.sendEmailVerification();

                  print(credential);

                  final username = nameController.text.trim().toLowerCase();

                    final taken = await isUsernameTaken(username);
                  if (taken) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Username already taken")),
                    );
                    return;
                  } else {
  
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registered Successfully!")),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const homePage()),
                    );
                  }
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

  Widget _buildDateField(String hint, TextEditingController controller) {
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
      readOnly: true,
      onTap: () => _pickDate(controller),
      validator: (value) {
        if (value == null || value.isEmpty) return "Select a date";
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.all(15),
        border: InputBorder.none,
        suffixIcon: const Icon(Icons.calendar_month),
      ),
    ),
  );
}

Widget _brutalDropdown() {
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
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
    child: DropdownButtonFormField<String>(
      value: _selectedGender,
      isExpanded: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      hint: const Text("Gender"),
      items: const [
        DropdownMenuItem(value: "male", child: Text("Male")),
        DropdownMenuItem(value: "female", child: Text("Female")),
        DropdownMenuItem(value: "prefer_not_say", child: Text("Prefer not to say")),
      ],
      onChanged: (value) {
        setState(() => _selectedGender = value);
      },
      validator: (value) {
        if (value == null) return "Please select a gender option";
        return null;
      },
    ),
  );
}


Future<bool> isUsernameTaken(String username) async {
  final doc = await FirebaseFirestore.instance
      .collection('usernames')
      .doc(username.toLowerCase())
      .get();

  return doc.exists;
}
}