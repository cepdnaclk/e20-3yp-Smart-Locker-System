import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:secure_x/pages/find.dart';
import 'package:secure_x/pages/unlock.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class LoginSuccess extends StatelessWidget {
  const LoginSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar:CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h,), 
          Center(
            child: Text('Welcome!', style: TextStyle(
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  Unlock(),));
                  //builder: (context) => const Navigation(selectedIndex: 3),
                //));
            },
            style: ElevatedButton.styleFrom(
              elevation: 6.h,
              foregroundColor: AppColors.textHighlight,
              backgroundColor: AppColors.textMuted
            ),
            child: Text('Unlock my Locker' ,style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),)
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: ElevatedButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Find(),));
            },
            style: ElevatedButton.styleFrom(
              elevation: 6.h,
              foregroundColor: AppColors.textHighlight,
              backgroundColor: AppColors.textMuted,
            ),
            child: Text('Search a Locker' ,style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),)
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}