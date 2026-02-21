import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';
import 'package:eventplanner/home.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool revealPassword = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle textfieldstyle() {
    return TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
       backgroundColor: AppColors.bg,

        body: Container(
          height: double.infinity,
          width: double.infinity,
          

          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (emailString) {
                                if (emailString == null ||
                                    emailString.isEmpty ||
                                    !emailString.contains("@")) {
                                  return "enter valid email";
                                }
                              },
                              style: textfieldstyle(),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintText: "email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                         color: AppColors.ink,
                                         width: 3,
                                       ),
                                ),
                                
                              ),
                            ),

                            SizedBox(height: 8.0),
                            TextFormField(
                              obscureText: !revealPassword,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (PasswordString) {
                                if (PasswordString == null ||
                                    PasswordString.isEmpty ||
                                    PasswordString.length < 6) {
                                  return "enter valid Password";
                                }
                              },
                              style: textfieldstyle(),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintText: "Password",
                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      revealPassword = !revealPassword;
                                    });
                                  },
                                  icon: Icon(
                                    revealPassword == false
                                        ? Icons.remove_red_eye_sharp
                                        : Icons.remove_red_eye_outlined,
                                  ),
                                ),
                                border: OutlineInputBorder(                                 
                                    borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                         color: AppColors.ink,
                                         width: 3,
                                       ), 
                                ),
                              ),
                            ),

                            SizedBox(height: 40.0),
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _formKey.currentState?.save();
                                }
                              },
                              child: Container(
                                height: 50.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                      color: AppColors.blue,
                        borderRadius: BorderRadius.circular(20),

                       border: Border.all(
                        color: AppColors.ink,
                        width: 2,
                        ),
                        
                        boxShadow: const [
                         BoxShadow(
                         color: AppColors.ink,
                         offset: Offset(5, 5), // X and Y shadow position
                        blurRadius: 0,        // IMPORTANT: 0 for brutalism
                          ),
                        ],),
                        
                                child: Center(
                                  child: Text(
                                    "Sign in ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 10.0),
                            Text(
                              "Forgot password",
                              style: TextStyle(fontSize: 18.0),
                            ),

                            SizedBox(height: 40.0),
                            Text(
                              "Dont have a account",
                              style: TextStyle(fontSize: 20.0),
                            ),

                            SizedBox(height: 10.0),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => homePage(),
                                  ),
                                );
                               
                              },
                             
                                child: Container(
                                  height: 50.0,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                    left: 1.0,
                                    right: 1.0,
                                  ),
                                  decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(20),

                       border: Border.all(
                        color: AppColors.ink,
                        width: 2,
                        ),
                        
                        boxShadow: const [
                         BoxShadow(
                         color: AppColors.ink,
                         offset: Offset(5, 5), // X and Y shadow position
                        blurRadius: 0,        // IMPORTANT: 0 for brutalism
                          ),
                        ],),
                                  child: Center(
                                    child: Text(
                                      "Create a new accout ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
