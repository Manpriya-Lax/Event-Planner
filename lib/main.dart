import 'package:flutter/material.dart';
import 'package:eventplanner/login.dart';
import 'package:eventplanner/home.dart';
import 'package:eventplanner/register.dart';

void main() {
  runApp( const MainApp());
}

  class MainApp extends StatelessWidget {
    const MainApp({super.key}); 

  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RegisterPage(),
    );
  } 
}


