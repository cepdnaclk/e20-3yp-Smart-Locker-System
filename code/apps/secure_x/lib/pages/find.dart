import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:secure_x/pages/map.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class Find extends StatefulWidget {
  const Find({super.key});

  @override
  State<Find> createState() => _FindState();
}

class _FindState extends State<Find> {
  int _selectedIndex=0;
  void _onTabSelected(int index){
    setState(() {
      _selectedIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar:CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h,), 
          Center(
            child: Text('Locker Near Me', 
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),        
          Center(
            child: Container(
              width: 400.w,
              height:600.h,
              alignment: Alignment.center,
              child:LockerMap(),         
            ),
          ),
          SizedBox(height: 10.h,),
          Center(
            child: ElevatedButton(
              onPressed:(){
              },
              style: ElevatedButton.styleFrom(
                elevation: 6.h,
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: 12.h, 
                  horizontal: 24.w),
              ), 
              child: Text('FIND',style: TextStyle(
                fontSize: 20.h,
                fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}