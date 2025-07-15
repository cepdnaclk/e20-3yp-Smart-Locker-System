import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/passwordReset_controller.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class ResetPassword extends StatelessWidget{
  final PasswordresetController passwordresetController=Get.find<PasswordresetController>();

  ResetPassword({Key? key}): super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      //appBar: CustomAppBar(),
      body: Obx(()=>Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.buttonBackgroundColor2,
            onPrimary: AppColors.buttonBackgroundColor1,
            secondary: AppColors.textPrimary,
          )
        ),
        child: Stepper(
          currentStep: passwordresetController.step.value,
          onStepContinue: () async {
            if(passwordresetController.step.value==0){
              await passwordresetController.generateOtp(context);
            }else if(passwordresetController.step.value==1){
              await passwordresetController.updatePassword(context);
            }
          },
          onStepCancel: (){
            if(passwordresetController.step.value>0) passwordresetController.step.value--;
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 12.h,),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackgroundColor2, // Primary
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(color: AppColors.buttonBackgroundColor1, fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackgroundColor1,
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          steps: [
            Step(
              title: Text('Request OTP to Reset Password'),
              content: 
              /*TextField(
                controller:passwordresetController.identifierController,
                decoration: InputDecoration(
                  labelText: 'Enter your Email'
                ),
              ),*/
              TextFormField(
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.textPrimary,
                ),
                //obscureText: true,
                controller: passwordresetController.identifierController,
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15.sp,
                  ),
                  filled: true,
                  fillColor: AppColors.formFieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.transparent), // No border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.transparent), // No border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.black), // Or any color you prefer
                  ),),
                keyboardType: TextInputType.emailAddress,
              ),
              isActive:passwordresetController.step.value==0,
            ),
            Step(
              title:Text('Set New Password'), 
              content: Column(
                children: [
                  /*TextField(
                    controller: passwordresetController.identifierController,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Email',
                    ),
                  ),*/
                  TextFormField(
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.textPrimary,
                    ),
                    //obscureText: true,
                    controller: passwordresetController.identifierController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Email',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15.sp,
                      ),
                      filled: true,
                      fillColor: AppColors.formFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.transparent), // No border
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.transparent), // No border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.black), // Or any color you prefer
                      ),),
                    keyboardType: TextInputType.text,
              ),
                  /*TextField(
                    controller: passwordresetController.otpController,
                    decoration: InputDecoration(
                      labelText: 'OTP',
                    ),
                  ),*/
                  SizedBox(height: 6.h,),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.textPrimary,
                    ),
                    //obscureText: true,
                    controller: passwordresetController.otpController,
                    decoration: InputDecoration(
                      hintText: 'OTP',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15.sp,
                      ),
                      filled: true,
                      fillColor: AppColors.formFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.transparent), // No border
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.transparent), // No border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.black), // Or any color you prefer
                      ),),
                    keyboardType: TextInputType.text,),
                  /*TextField(
                    controller: passwordresetController.newPasswordController,
                    decoration:InputDecoration(
                      labelText: 'New Password',),
                    obscureText:true,
                  )*/
                  SizedBox(height: 6.h,),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.textPrimary,
                    ),
                    obscureText: true,
                    controller: passwordresetController.newPasswordController,
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15.sp,
                      ),
                      filled: true,
                      fillColor: AppColors.formFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.transparent), // No border
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.transparent), // No border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.black), // Or any color you prefer
                      ),),
                    keyboardType: TextInputType.text,),
                ],
              ),
            
              isActive: passwordresetController.step.value==1,
            )
          ],
        ),
      )),
    );
  }

}
