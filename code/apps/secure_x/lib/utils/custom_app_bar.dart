import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/pages/locker_logs.dart';
import 'package:secure_x/pages/user.dart';
import 'package:secure_x/utils/appcolors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.buttonBackgroundColor2,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: AppColors.boxColor,),
          color: AppColors.boxColor,
          onSelected: (value) {
            if(value== 'View Profile'){
              Get.to(() => const User());
            }else if(value=='Settings'){
            }else if(value=='History'){
              Get.to(() => LockerLogs());
            }else if(value=='Log Out'){            
            }
          },
          itemBuilder: (BuildContext context)=>[
            const PopupMenuItem(
              value: 'View Profile',
              child: Row(
                children: [
                  Icon(Icons.person,color: AppColors.iconColor,),
                  SizedBox(width: 10,),
                  Text('View Profile',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'Settings',
              child: Row(
                children: [
                  Icon(Icons.settings,color: AppColors.iconColor,),
                  SizedBox(width: 10,),
                  Text('Settings',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),
                              ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'History',
              child: Row(
                children: [
                  Icon(Icons.history,color: AppColors.iconColor,),
                  SizedBox(width: 10,),
                  Text('History',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),
                              ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'Log Out',
              child: Row(
                children: [
                  Icon(Icons.logout,color: AppColors.iconColor,),
                  SizedBox(width: 10,),
                  Text('Log Out',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),
                              ),
                ],
              ),
            ),
          ],            
        ),
        title: Center(
          child: ColorFiltered(
            colorFilter:ColorFilter.mode(
              AppColors.boxColor,
              BlendMode.modulate,
            ),
            child: Image.asset(
            'assets/img/logo2.png',
            height: 100,
            width: 800,
          ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined, color: AppColors.boxColor,),
            onPressed: () {
            },
          ),
        ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}