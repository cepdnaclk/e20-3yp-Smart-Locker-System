import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:secure_x/pages/create_user.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/pages/log_in.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/img/back.png',
            fit: BoxFit.cover,
          ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           Center(
            child: Container(
              width: 0.9.sw,
              height: 0.5.sh,
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: Image.asset(
                  'assets/img/banner.png',
                  fit: BoxFit.cover, 
                  width: 2.sw,
                  height: 0.15.sh,
                ),
              ),
            ),
          ),
            SizedBox(height: 5.h,),
            Padding(
                padding:EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.all(50.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.appBarColor,
                        blurRadius: 8.r,
                        offset: Offset(0,4),
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LogIn(),));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 6.h,
                          backgroundColor: AppColors.buttonBackgroundColor2,
                          foregroundColor: AppColors.buttonBackgroundColor1,
                          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.h),
                          shadowColor: AppColors.appBarColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          )
                        ), 
                        child: Text('LOG IN',style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Text('or', style: TextStyle(
                        fontSize: 18.sp,
                      ),),
                      TextButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateUser(),));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        /*backgroundColor: AppColors.textDisabled,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: AppColors.textDisabled,
                              width: 2,
                            )
                          )*/
                      ),
                      child: Text('CREATE ACCOUNT',style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                      ),)
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20.h,)   
          ],
        ),
        ],  
      ),
    );    
  }
}
