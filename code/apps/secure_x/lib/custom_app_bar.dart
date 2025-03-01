import 'package:flutter/material.dart';
import 'package:secure_x/utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.iconColor,),
          onPressed: () {
          },
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