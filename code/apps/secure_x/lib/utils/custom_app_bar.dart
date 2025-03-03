import 'package:flutter/material.dart';
import 'package:secure_x/utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarColor,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: AppColors.iconColor,),
          color: AppColors.boxColor,
          onSelected: (value) {
            if(value== 'View Profile'){
            }else if(value=='Settings'){
            }else if(value=='History'){
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
              Colors.grey[400]!,
              BlendMode.modulate ,
            ),
            child: Image.asset(
            'assets/img/logo.png',
            height: 100,
            width: 800,
          ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined, color: AppColors.iconColor,),
            onPressed: () {
            },
          ),
        ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}