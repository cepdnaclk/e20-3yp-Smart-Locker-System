import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/pages/locker_logs.dart';
import 'package:secure_x/pages/notifications.dart';
import 'package:secure_x/pages/settings.dart';
import 'package:secure_x/pages/sign_in.dart';
import 'package:secure_x/pages/user.dart';
import 'package:secure_x/utils/appcolors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key});

  final AuthController authController = Get.find<AuthController>();

  void _menuSelectionHandler(String value, BuildContext context){
    switch(value){
      case 'View Profile':
        Get.to(() => const User());
        break;
      case 'Settings':
        Get.to(()=> Settings());
        break;  
      case 'History':
        Get.to(()=> LockerLogs());
        break;
      case 'Log Out':
        Get.defaultDialog(
          title: 'Log Out',
          middleText: 'Are you sure you want to log out?',
          textConfirm: 'Yes',
          textCancel: 'Cancel',
          confirmTextColor: AppColors.boxColor,
          onConfirm: () async{
            //Get.back();
            await authController.logout(context);
          },
          onCancel: () {
            Get.back();
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Stack(
    fit: StackFit.expand,
    children: [
      Image.asset(
        'assets/img/backpatten-wb.png', // Your background image
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(0.6), // Black overlay, 50% opacity
        // You can adjust the color and opacity as needed
      ),
    ],
  ),
      backgroundColor : AppColors.appBarColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            //bottomLeft: Radius.circular(20.h),
            //bottomRight: Radius.circular(20.h),
          ),
        ),
        toolbarHeight: 60.h,
      elevation: 6.h,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: AppColors.mainColor,),
          color: AppColors.boxColor,
          onSelected: (value) => _menuSelectionHandler(value, context),
          itemBuilder: (BuildContext context)=>[
            _buildMenuItem(Icons.person, 'View Profile'),
            const PopupMenuDivider(),
            _buildMenuItem(Icons.settings, 'Settings'),
            const PopupMenuDivider(),
            _buildMenuItem(Icons.history, 'History'),
            const PopupMenuDivider(),
            _buildMenuItem(Icons.logout, 'Log Out'),
          ],
        ), 
        title: Text(
          'Secure X',
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5.w,
            color: AppColors.mainColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined, color: AppColors.boxColor,),
            onPressed: () => Get.to(() => Notifications()), 
              //Get.snackbar('Messages', 'You have no new messages');
          ),
        ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String text){
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(
            icon, 
            color:AppColors.mainColor,),
            SizedBox(width: 10.h,),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}