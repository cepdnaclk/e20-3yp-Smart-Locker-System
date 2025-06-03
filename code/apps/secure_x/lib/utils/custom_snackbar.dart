import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            SizedBox(width: 8),
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
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4,),
                Text(
                  message,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 14,
                  ),
                )
              ],
            ),)
            
        ],
      ),
      backgroundColor: backgroundColor ??
        (isError ? Colors.red.shade700 : Colors.green.shade700),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius:BorderRadius.circular(10), 
      ),
      margin: showAtTop ? 
        EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 12,
          right: 12,
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
}