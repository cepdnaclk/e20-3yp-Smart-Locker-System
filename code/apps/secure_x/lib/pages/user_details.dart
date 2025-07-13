import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/models/user_model.dart';
import 'package:secure_x/pages/edit_profile.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class UserDetails extends StatelessWidget {
  UserDetails({super.key});

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final UserModel? user = _authController.userModel.value;

    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/img/backpattern.jpg',
          fit: BoxFit.cover,
      ),     
      Padding(
        padding: EdgeInsets.all(16.h),
        child: user == null
            ? const Center(child: Text('No user data available'))
            : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //User Image
                  ClipOval(
                    child: Image.asset('assets/img/userImage.png',
                    width:160.w,
                    height:160.w,
                    fit:BoxFit.cover,),
                  ),
              
                  SizedBox(height: 24.h,),

                  _buildDetailItem("Email", user.email ?? 'Not provided'),
                  _buildDetailItem("First Name", user.firstName ?? 'Not provided'),
                  _buildDetailItem("Last Name", user.lastName ?? 'Not provided'),
                  _buildDetailItem("ID", user.id?? 'Not provided'),
                  _buildDetailItem("Registration No", user.regNo ?? 'Not provided'),
                  _buildDetailItem("Phone Number", user.phoneNo ?? 'Not provided'),

                  SizedBox(height: 24.h,),
                  
                  //Edit Profile                 
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, 
                            horizontal: 24.h
                          ),
                        backgroundColor: AppColors.buttonBackgroundColor2,
                        foregroundColor: AppColors.buttonBackgroundColor1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        )
                      ),
                      onPressed: (){
                        Get.to(() => EditProfile()); 
                      }, 
                      child: Text('Edit Profile',
                      style: TextStyle(
                        fontSize: 20.h,
                        fontWeight: FontWeight.bold,
                      ),)),
                ]             
              ),
          ),
        )
    ]));
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding:EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        initialValue: value,
        enabled: false,
        style:TextStyle(
          color: AppColors.appBarColor,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: const BorderSide(
              color: AppColors.appBarColor,
            )
          ),
          filled: true,
          fillColor: AppColors.boxColor,
          )
        ),
      );
  }
}
