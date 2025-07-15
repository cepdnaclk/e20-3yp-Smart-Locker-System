import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/pages/locker_logs.dart';
import 'package:secure_x/pages/settings.dart';
import 'package:secure_x/pages/user_details.dart';
import 'package:secure_x/routes/route_helper.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  // Variable to store the formatted registration number
  String formattedRegNo = "XX/XX/XXX";
  
  // Get the AuthController instance
  final AuthController _authController = Get.find<AuthController>();
  
  @override
  void initState() {
    super.initState();
    // Retrieve registration number when screen loads
    _loadUserRegNo();

    final user=_authController.userModel.value;
    if(user!=null && _authController.profileImagebytes.value==null){
      _authController.getUserToken().then((token){
        if(token!=null){
          _authController.loadProfileImage(user.id!, token);
        }
      });
    }
  }
  
  // Method to format registration number (E20002 -> E/20/002)
  String _formatRegNo(String regNo) {
    if (regNo == null || regNo.isEmpty) return "XX/XX/XXX";
    
    // For registration number in format 'E20002'
    if (regNo.length >= 6 && regNo[0].toUpperCase() == 'E') {
      return '${regNo[0]}/${regNo.substring(1, 3)}/${regNo.substring(3)}';
    }
    
    // If it doesn't match the expected format, return as is
    return regNo;
  }

  // Load user data from AuthController
  void _loadUserRegNo() {
    // Access the regNo from the userModel in AuthController
    final userRegNo = _authController.userModel.value.regNo;
    
    if (userRegNo != null && userRegNo.isNotEmpty) {
      setState(() {
        formattedRegNo = _formatRegNo(userRegNo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar:CustomAppBar(),
     body: Stack(
        fit: StackFit.expand,
  children: [
    Positioned.fill(
      child: Image.asset(
        'assets/img/backpattern.jpg', 
        fit: BoxFit.cover,
      ),
    ),
      Container(
        color:Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.h),            
              child:Center(
                child: CircleAvatar(
                  radius:80.r,
                  backgroundColor:AppColors.mainColor,
                  child:ClipOval(
                    child: Obx((){
                      final imageBytes =_authController.profileImagebytes.value;
                      if(imageBytes!=null){
                        return Image.memory(
                          imageBytes,
                          width: 150.w,
                          height: 150.w,
                          fit: BoxFit.cover,
                        );
                      }else{
                        return Image.asset(
                          'assets/img/userImage.png',
                          width: 150.w,
                          height: 150.w,
                          fit: BoxFit.cover,
                        );
                      }
                    }),
                    /*child: Image.asset('assets/img/userImage.png',
                    width:150.w,
                    height:150.h,
                    fit:BoxFit.cover,*/
                    )
                  )
                ),
            ),
            SizedBox(height: 20.h,),
            Padding(
                padding:EdgeInsets.symmetric(horizontal: 20.h,),
                child: Container(
                  padding: EdgeInsets.all(40.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        formattedRegNo,
                        style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textInverse,
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      TextButton.icon(
                        onPressed: (){
                          //Get.to(() => UserDetails());
                          Get.toNamed(RouteHelper.getUserDetails());
                      }, 
                      icon: Icon(
                        Icons.person_4_outlined,
                        color: AppColors.buttonBackgroundColor1,
                        size: 22.sp,
                      ),
                      label: Text('User Detail',style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonBackgroundColor1,
                      ),)
                      ),
                      SizedBox(height: 20.h,),
                      TextButton.icon(
                        onPressed: (){
                          Get.to(() => LockerLogs());
                          Get.toNamed(RouteHelper.getLockerLogs());
                      }, 
                      icon: Icon(
                        Icons.history,
                        color: AppColors.buttonBackgroundColor1,
                        size: 22.sp,
                      ),
                      label: Text('User History',style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonBackgroundColor1,
                      ),)
                      ),
                      SizedBox(height: 20.h,),
                      TextButton.icon(
                        onPressed: (){
                          //Get.to(() => Settings());
                          Get.toNamed(RouteHelper.getSettings());
                      }, 
                      icon: Icon(
                        Icons.settings,
                        color: AppColors.buttonBackgroundColor1,
                        size: 22.sp,
                      ),
                      label: Text('Settings',style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonBackgroundColor1,
                      ),)
                      ),
                    ],
                  ),
                ),
      )]),
           // SizedBox(height: 20.h,)   
     )],
        ),      
    );
    ;  
  }
}
