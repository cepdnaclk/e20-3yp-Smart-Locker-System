import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/utils/appcolors.dart';

void CustomSnackBar(String? message,{bool iserror=true,String title='Error',Duration duration = const Duration(seconds: 3)}){
  Get.snackbar(title, message?? 'Something went wrong',
  titleText: Text(title,style: TextStyle(
    color: AppColors.textSecondary,
  ),
  ),
  messageText: Text(message?? 'Something went wrong', style: TextStyle(
    color: AppColors.textSecondary,
    fontWeight: FontWeight.bold
  ),
  ),
  colorText: Colors.white,
  snackPosition: SnackPosition.TOP,
  duration: duration,
  backgroundColor: AppColors.boxColor,
  );
}