/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/utils/appcolors.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    String title = 'Error',
    bool isError = true,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    bool showAtTop=true,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar= SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor ?? Colors.white),
            SizedBox(width: 8.sw),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.h,
                  ),
                ),
                SizedBox(height: 4.h,),
                Text(
                  message,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 14.h,
                  ),
                )
              ],
            ),)
            
        ],
      ),
      backgroundColor: backgroundColor ??
        (isError ? AppColors.textPrimary : AppColors.textSecondary),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius:BorderRadius.circular(10.r), 
      ),
      margin: showAtTop ? 
        EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 0.5.h,
          left: 12.sw,
          right: 12.sw,
        )
        : EdgeInsets.all(12),
      action: SnackBarAction(
        label: 'Dismiss', 
        onPressed:(){
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        } 
        ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
}*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:secure_x/utils/appcolors.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    String title = 'Error',
    bool isError = true,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    bool showAtTop = true,
  }) {
    Flushbar(
      titleText: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.h,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 14.h,
        ),
      ),
      icon: icon != null ? Icon(icon, color: textColor ?? Colors.white) : null,
      backgroundColor: backgroundColor ??
          (isError ? AppColors.textPrimary : AppColors.textSecondary),
      duration: duration,
      flushbarPosition: showAtTop ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
      margin: EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(10.r),
      mainButton: TextButton(
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        child: Text('Dismiss', style: TextStyle(color: textColor ?? Colors.white)),
      ),
    ).show(context);
  }
}
