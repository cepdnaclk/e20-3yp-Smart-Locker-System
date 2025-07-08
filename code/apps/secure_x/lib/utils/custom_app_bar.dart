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
      backgroundColor: AppColors.buttonBackgroundColor2,
      elevation: 6.h,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: AppColors.boxColor,),
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
          'SecureX',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2.w,
            color: AppColors.boxColor,
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
            color:AppColors.iconColor,),
            SizedBox(width: 10.h,),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}