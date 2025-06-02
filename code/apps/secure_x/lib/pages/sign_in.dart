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
      //appBar:const CustomAppBar(),
      body:Container(
        color: AppColors.mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
                child: Container(
                  width: 1.sw,
                  height:0.5.sh,
                  alignment: Alignment.center,
                  child:ClipRect(
                    child: Align(
                      alignment: Alignment.center,
                      heightFactor: 0.5,
                      widthFactor: 1,
                      child: Image.asset('assets/img/logo.png',
                      fit: BoxFit.contain,             
                    ),
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
                    borderRadius: BorderRadius.circular(10.r),
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
                        ), 
                        child: Text('SIGN IN',style: TextStyle(
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
                        foregroundColor: AppColors.textSecondary,
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
        
      ),
    );    
  }
}
