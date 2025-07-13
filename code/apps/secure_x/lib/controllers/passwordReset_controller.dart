import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:secure_x/data/repository/passwordResetRepo.dart';
import 'package:secure_x/pages/log_in.dart';
import 'package:secure_x/utils/custom_snackbar.dart';

class PasswordresetController extends GetxController{
  final PasswordResetRepo passwordResetRepo;

  PasswordresetController({required this.passwordResetRepo});

  var isLoading=false.obs;
  var step=0.obs;

  //user input fields
  final identifierController= TextEditingController();
  //final userNameController= TextEditingController();
  final otpController=TextEditingController();
  final newPasswordController=TextEditingController();

  //Generate otp
  Future<void> generateOtp(BuildContext context) async {
    isLoading.value=true;
    try{
      final response=await passwordResetRepo.generateOtp(identifierController.text.trim());
      print('Success : ${response.data}');
      CustomSnackBar.show(
        context: context, 
        title: 'Success',
        message: 'OTP sent to your email',
        isError: false,
      );
      step.value=1;
    }catch(e){
      print('Error in generating otp : $e');
      CustomSnackBar.show(
        context: context, 
        title: 'Error',
        message: 'Failed to generate OTP',
        isError: true,
      );
    }finally{
      isLoading.value=false;
    }
  }

  /*//validate otp
  Future<void> validateOtp(BuildContext context) async{
    isLoading.value=true;
    try{
      final response=await passwordResetRepo.validateOtp(
        userNameController.text.trim(), 
        otpController.text.trim(),
      );
      if(response.data==true){
        print('Success : ${response.data}');
        CustomSnackBar.show(
          context: context, 
          title: 'Success',
          message: 'OTP validated. Please enter new password',
          isError: false,
        );
        step.value=2;
      }else{
        CustomSnackBar.show(
          context: context, 
          title: 'Error',
          message: 'Invalid OTP',
          isError: true,
        );
      }
      }catch(e){
        print('Validate password error : $e');
        CustomSnackBar.show(
          context: context, 
          title: 'Error',
          message: 'Invalid OTP',
          isError: true,
        );
      }finally{
        isLoading.value=false;
      }
    }*/

    //update password with otp
    Future<void> updatePassword(BuildContext context) async{
      isLoading.value=true;
      try{
        final payload={
          'usernameOrEmail': identifierController.text.trim(),
          'newPassword': newPasswordController.text.trim(),
          'otp':otpController.text.trim(),
        };
        print('Password update payloaf :$payload');
        await passwordResetRepo.updatePassword(
          usernameOrEmail: identifierController.text.trim(), 
          newPassword: newPasswordController.text.trim(), 
          otp: otpController.text.trim(),
        );
        CustomSnackBar.show(
          context: context, 
          title: 'Success',
          message: 'Password updated successfully',
          isError: false,
        );
        print('Password updated successfully');
        Get.to(()=>LogIn());
      }catch(e){
        print('Updating password error: $e');
        CustomSnackBar.show(
          context: context, 
          title: 'Error',
          message: 'Failed to update password',
          isError: true,
        );
      }finally{
        isLoading.value=false;
      }

      @override
      void onClose(){
        identifierController.dispose();
        //userNameController.dispose();
        otpController.dispose();
        newPasswordController.dispose();
        super.onClose();
      }
    }
}

