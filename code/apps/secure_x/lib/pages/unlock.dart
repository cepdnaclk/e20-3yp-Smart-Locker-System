import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/models/locker_logs_model.dart';
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
      body:Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/img/backpattern.jpg',
          fit: BoxFit.cover,
        ),
        FutureBuilder<LockerLogsModel?>(
            future: authController.getActiveLockerLog(),
            builder: (context, snapshot) {
              String? location;
              int? lockerId;
              bool hasActive = false;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data != null) {
                location = snapshot.data!.location;
                lockerId = snapshot.data!.lockerId;
                hasActive = true;
              }
              return SingleChildScrollView(
          child: Column(
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
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 0.1.sw,vertical: 0.sh),
            child: Container(
              padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withAlpha((0.7 * 255).round()), // Top color
                        Colors.black.withAlpha((0.3 * 255).round()), 
                        //Colors.transparent,             // Middle (transparent)
                        Colors.black.withAlpha((0.7 * 255).round()), // Bottom color
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
          
              child: Column(   
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  hasActive? 'Location : $location' : 'No active locker assigned',

                  //'Location : Department of Computer Engineering ',
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
                if(hasActive)
                Text(
                  'Locker No : $lockerId',
                  style: TextStyle(
                    fontSize: 20.sp, 
                    fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
    );})]));
  }
}
