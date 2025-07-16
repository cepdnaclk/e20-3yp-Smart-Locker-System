import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/pages/locker_logs.dart';
import 'package:secure_x/pages/notifications.dart';
import 'package:secure_x/pages/settings.dart';
import 'package:secure_x/pages/user.dart';
import 'package:secure_x/utils/appcolors.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  static Widget _leftMenuTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(icon, size: 26, color: color),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
      horizontalTitleGap: 12,
    );
  }

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final AuthController authController = Get.find<AuthController>();
  bool isNotificationOpen = false;

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Log Out',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonBackgroundColor1,
              foregroundColor: AppColors.buttonForegroundColor1,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              //Navigator.of(context, rootNavigator: true).pop();
              await authController.logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonBackgroundColor2,
              foregroundColor: AppColors.buttonBackgroundColor1,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void showLeftSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Menu",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: AppColors.boxColor,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 18,
                    offset: Offset(4, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Obx(() {
                      final user = authController.userModel.value;
                      final image = authController.profileImagebytes.value;
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundImage: image != null
                              ? MemoryImage(image)
                              : const AssetImage('assets/img/userImage.png') as ImageProvider,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      );
                    }),
                    const Divider(height: 32, thickness: 1.2),
                    CustomAppBar._leftMenuTile(
                      icon: Icons.person,
                      label: 'View Profile',
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const User());
                      },
                      color: AppColors.textHighlight,
                    ),
                    CustomAppBar._leftMenuTile(
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => Settings());
                      },
                      color: AppColors.textHighlight,
                    ),
                    CustomAppBar._leftMenuTile(
                      icon: Icons.history,
                      label: 'History',
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => LockerLogs());
                      },
                      color: AppColors.textHighlight,
                    ),
                    CustomAppBar._leftMenuTile(
                      icon: Icons.logout,
                      label: 'Log Out',
                      onTap: () {
                        Navigator.pop(context);
                        _showLogoutDialog(context);
                      },
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(-1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  void _toggleNotification(BuildContext context) {
  if (isNotificationOpen) {
    Navigator.of(context, rootNavigator: true).pop();
    setState(() => isNotificationOpen = false);
  } else {
    setState(() => isNotificationOpen = true);
    Get.to(() => Notifications())?.then((_) {
      if (mounted) setState(() => isNotificationOpen = false);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/img/backpatten-wb.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
      backgroundColor: AppColors.appBarColor,
      elevation: 6.h,
      toolbarHeight: 60.h,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
        child: GestureDetector(
          onTap: () => showLeftSheet(context),
          child: Icon(Icons.menu, color: AppColors.mainColor,)),),
      title: Text(
        'Secure X',
        style: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5.w,
          color: AppColors.mainColor,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.message_outlined, color: AppColors.boxColor),
          onPressed: () => 
          _toggleNotification(context),
          //Get.to(() => Notifications()),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
