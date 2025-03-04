import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/utils/colors.dart';

void CustomSnackBar(String message,{bool iserror=true,String title='Error'}){
  Get.snackbar(title, message,
  titleText: Text(title,style: TextStyle(
    color: AppColors.textColor1
  ),
  ),
  messageText: Text(message, style: TextStyle(
    color: AppColors.textColor1,
    fontWeight: FontWeight.bold
  ),
  ),
  colorText: Colors.white,
  snackPosition: SnackPosition.TOP,
  backgroundColor: AppColors.boxColor,
  );
}