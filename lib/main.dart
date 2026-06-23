import 'package:eventplanner/profile.dart';
import 'package:eventplanner/add.dart';
import 'package:eventplanner/emailverify.dart';
import 'package:eventplanner/forgotPW.dart';
import 'package:eventplanner/friends.dart';
import 'package:eventplanner/invite.dart';
import 'package:eventplanner/requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventplanner/login.dart';
import 'package:eventplanner/home.dart';
import 'package:eventplanner/register.dart';
import 'package:eventplanner/setting.dart';
import 'package:eventplanner/theme.dart';


import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
  runApp( const MainApp());
}

  class MainApp extends StatelessWidget {
    const MainApp({super.key}); 

  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: softNeoTheme(), 
      home:  StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) 
    {
      return const CircularProgressIndicator();
    }
      
    if (snapshot.hasData && snapshot.data!.emailVerified) 
    {
      return const HomePage();
    }
    return const loginPage();
  },
),

      routes: {
      
        "/login": (context) => const loginPage(),
        "/register": (context) => const RegisterPage(),
        "/home": (context) => const HomePage(),
        "/profile": (context) => const ProfilePage(),
        "/add": (context) => const AddEventPage(),
        '/friends': (context) => const FriendsPage(),
        "/settings": (context) => const Setting(),
        "/emailverify": (context) => const Emailverify(),
        "/forgotpw": (context) => const Forgotpw(),
        "/invite": (context) => const InvitePage(),
        "/requests": (context) => const RequestsPage(),

        
        
      },


    );
  } 
}


