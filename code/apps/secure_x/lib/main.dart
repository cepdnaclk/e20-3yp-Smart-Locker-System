import 'package:flutter/material.dart';
//import 'package:secure_x/find.dart';
import 'package:secure_x/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:secure_x/sign_in.dart';
//import 'package:secure_x/create_user.dart';
import 'package:secure_x/log_in.dart';
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
  bool isAuthenticated=false;
  @override
  void initState(){
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String? token=preferences.getString('authentication_token');
    setState(() {
      isAuthenticated=token!=null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isAuthenticated? const MainScreen():const LogIn(),);
  }
}

