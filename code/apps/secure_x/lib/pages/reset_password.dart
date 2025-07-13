import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/passwordReset_controller.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class ResetPassword extends StatelessWidget{
  final PasswordresetController passwordresetController=Get.find<PasswordresetController>();

  ResetPassword({Key? key}): super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppBar(),
      body: Obx(()=>Stepper(
        currentStep: passwordresetController.step.value,
        onStepContinue: () async {
          if(passwordresetController.step.value==0){
            await passwordresetController.generateOtp(context);
          //}else if(passwordresetController.step.value==1){
           // await passwordresetController.validateOtp(context);
          }else if(passwordresetController.step.value==1){
            await passwordresetController.updatePassword(context);
          }
        },
        onStepCancel: (){
          if(passwordresetController.step.value>0) passwordresetController.step.value--;
        },
        steps: [
          Step(
            title: Text('Request OTP'),
            content: TextField(
              controller:passwordresetController.identifierController,
              decoration: InputDecoration(
                labelText: 'Email'
              ),
            ),
            isActive:passwordresetController.step.value==0,
          ),
          /*Step(
            title: Text('Validate OTP'), 
            content: Column(
              children: [
                TextField(
                  controller:passwordresetController.userNameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                TextField(
                  controller: passwordresetController.otpController,
                  decoration: InputDecoration(
                    labelText: 'OTP',
                  ),
                ), 
              ],
            ),
            isActive: passwordresetController.step.value==1,
          ),*/
          Step(
            title:Text('Set New Password'), 
            content: Column(
              children: [
                TextField(
                  controller: passwordresetController.identifierController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  controller: passwordresetController.otpController,
                  decoration: InputDecoration(
                    labelText: 'OTP',
                  ),
                ),
                TextField(
                  controller: passwordresetController.newPasswordController,
                  decoration:InputDecoration(
                    labelText: 'New Password',),
                  obscureText:true,
                )
              ],
            ),
            isActive: passwordresetController.step.value==1,
          )
        ],
      )),
    );
  }

}
