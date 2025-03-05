import 'package:flutter/material.dart';
import 'package:secure_x/pages/log_in.dart';
import 'package:secure_x/pages/navigation.dart';
import 'package:secure_x/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => Navigation(),)
      );
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: ColorFiltered(
        colorFilter:const ColorFilter.mode(
          AppColors.mainColor, BlendMode.modulate),
        child: Center(
          child: Image.asset('assets/img/logo.png'),),
      ),
    );
  }
}