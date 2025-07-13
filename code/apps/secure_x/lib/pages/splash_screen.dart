import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/routes/route_helper.dart';
import 'package:secure_x/utils/appcolors.dart';

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
      Get.offNamed(RouteHelper.getSignin()),
    );
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/img/back.png', 
            fit: BoxFit.cover,
          ),
          ClipRect(
            child: Align(
              alignment: Alignment.center,
              heightFactor: 0.33,
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.appBarColor, 
                      blurRadius: 15,                       
                      offset: Offset(0, 6),               
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/img/banner.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          )
    
        ],
      )
    );
  }
}