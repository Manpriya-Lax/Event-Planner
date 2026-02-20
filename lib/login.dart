import 'package:flutter/material.dart';

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
                                border: OutlineInputBorder(),
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
                                border: OutlineInputBorder(),
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
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(9.0),
                                  ),
                                ),
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
                              child: Card(
                                child: Container(
                                  height: 50.0,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(9.0),
                                    ),
                                  ),
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
