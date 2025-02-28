import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[400],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black,),
          onPressed: () {
          },
        ),
        title: ColorFiltered(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined, color: Colors.black,),
            onPressed: () {
            },
          ),
        ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}