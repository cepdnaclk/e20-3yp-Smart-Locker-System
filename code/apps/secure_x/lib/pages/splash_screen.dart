import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/routes/route_helper.dart';
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

    Future.delayed(const Duration(seconds: 2),()=>
      Get.offNamed(RouteHelper.getInitial()),
    );
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