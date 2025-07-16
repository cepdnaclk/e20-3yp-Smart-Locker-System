import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/pages/find.dart';
import 'package:secure_x/pages/unlock.dart';
import 'package:secure_x/routes/route_helper.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class LoginSuccess extends StatelessWidget {
  const LoginSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar:CustomAppBar(),
      body: Stack(
        children: [
          Positioned(
            child: Image.asset('assets/img/backpattern.jpg',
            fit: BoxFit.cover,)),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h,), 
              Center(
                child: Text('Welcome!', style: TextStyle(
                  color: AppColors.textHighlight,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),        
              Center(
                child: Container(
                  width: 800.w,
                  height:350.h,
                  alignment: Alignment.center,
                  child:ClipRect(
                    child: Align(
                      alignment: Alignment.center,
                      heightFactor: 0.5,
                      child: Image.asset('assets/img/logo.png',
                      fit: BoxFit.cover,             
                    ),
                    ),
                  )             
                ),
              ),
              SizedBox(height: 10.h,),
              Center(
                child: ElevatedButton(onPressed: (){
                  Get.toNamed(RouteHelper.getUnlock());
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  Unlock(),));
                      //builder: (context) => const Navigation(selectedIndex: 3),
                    //));*/
                },
                style: ElevatedButton.styleFrom(
                  elevation: 6.h,
                  foregroundColor: AppColors.buttonBackgroundColor1,
                  backgroundColor: AppColors.buttonForegroundColor1,
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r)
                  ),
                  shadowColor: AppColors.appBarColor,
                ),
                child: Text('Unlock my Locker' ,style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),)
                ),
              ),
              SizedBox(height: 50.h),
              Center(
                child: ElevatedButton(onPressed: (){
                  Get.toNamed(RouteHelper.getFind());
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Find(),));*/
                },
                style: ElevatedButton.styleFrom(
                  elevation: 6.h,
                  foregroundColor: AppColors.buttonBackgroundColor2,
                  backgroundColor: AppColors.textMuted,
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r)
                  ),
                  shadowColor: AppColors.iconColor,
                ),
                child: Text('Search a Locker' ,style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),)
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ],),
    );
  }
}