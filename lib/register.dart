import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventplanner/emailverify.dart';
import 'package:eventplanner/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';
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

  "assets/imgs/0.png",
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
  
];

  int _selectedAvatarIndex = 1;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;


            Future<bool> usernameExists(String username) async {
              final result = await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: username.trim().toLowerCase())
              .limit(1)
              .get();

  return result.docs.isNotEmpty;
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

              BrutalField(
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

              BrutalField(
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

              BrutalDateField(
                hint: "Date Of Birth (DD/MM/YYYY)",
                controller: dateController,
                initialDate: DateTime(2016, 1, 1),
                firstDate: DateTime(1960), //  No past dates
                lastDate: DateTime.now(),
              ),
              const SizedBox(height: 18),
              _brutalDropdown(),

              const SizedBox(height: 18),


              BrutalField(
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

              BrutalField(
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

              BrutalButton(
                text: "Create Account",
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Firebase sign up
                    
               WidgetsFlutterBinding.ensureInitialized();
                await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform );
                var instance = FirebaseAuth.instance;
                print (instance);

                

                  final username = nameController.text.trim().toLowerCase();

                  bool exists = await usernameExists(username);

                  if (exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Username already taken")),
                    );
                    return;
                  }
                  else{

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
                    'email': emailController.text.trim(),

                  });


                  var user =credential.user;
                  await user?.sendEmailVerification();

                  print(credential);


                   {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Emailverify()),
                    );
                  }
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
 @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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