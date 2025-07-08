import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class Unlock extends StatelessWidget {
  
  Unlock({super.key});

  final AuthController authController=Get.find<AuthController>();
  void _accessLocker(BuildContext context){
    authController.accessLocker();
  }

  void _unassignLocker(BuildContext context){
    authController.unassignLocker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 800.w,
              height: 350.h,
              alignment: Alignment.center,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 0.5,
                  child: Image.asset(
                    'assets/img/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(20.h),
            margin: EdgeInsets.symmetric(horizontal: 10.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(30.r)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location : Department of Computer Engineering ',
                  style: TextStyle(
                    fontSize: 20.sp, 
                    fontWeight: FontWeight.bold),
                ),
                /*Text(
                  'Recent Access Time : xx:xx:xx ',
                  style: TextStyle(
                    fontSize: 20.sp, 
                    fontWeight: FontWeight.bold),
                ),*/
                Text(
                  'Locker No : 2',
                  style: TextStyle(
                    fontSize: 20.sp, 
                    fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 60.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 6.h,
                foregroundColor: AppColors.buttonBackgroundColor1,
                backgroundColor: AppColors.buttonBackgroundColor2,
                shape: CircleBorder(
                  side: BorderSide(color: Colors.black, width: 2.w),
                ),
                padding: EdgeInsets.all(40.h),
              ),
              onPressed: () => _accessLocker(context),
              child: Text('Access', 
              style: TextStyle(
                fontSize: 22.sp)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 6.h,
                foregroundColor: AppColors.buttonBackgroundColor1,
                backgroundColor: AppColors.iconColor,
                shape: CircleBorder(
                  side: BorderSide(color: AppColors.iconColor, width: 2.w),
                ),
                padding: EdgeInsets.all(40.h),
              ),
              onPressed: () => _unassignLocker(context),
              child: Text('Unassign', 
              style: TextStyle(
                fontSize: 22.sp)),
            ),
            ] 
          ),
          SizedBox(height: 30.h),
          
        ],
      ),
    );
  }
}
