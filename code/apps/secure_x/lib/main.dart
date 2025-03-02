import 'package:flutter/material.dart';
//import 'package:secure_x/find.dart';
import 'package:secure_x/pages/main_screen.dart';
import 'package:secure_x/pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:secure_x/sign_in.dart';
//import 'package:secure_x/create_user.dart';
import 'package:secure_x/pages/log_in.dart';
//import 'package:secure_x/home.dart';
//import 'package:secure_x/sign_in.dart';
//import 'package:secure_x/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  //const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen()
    );
  }
}

