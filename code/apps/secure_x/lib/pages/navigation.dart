/*import 'package:flutter/material.dart';
import 'package:secure_x/pages/find.dart';
import 'package:secure_x/pages/login_success.dart';
import 'package:secure_x/pages/user.dart';
import 'package:secure_x/utils/appcolors.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex=1;

  final List<Widget> _pages=[
    Find(),
    //SignIn(),
    LoginSuccess(),
    User(),
  ];
  
  void _onTabSelected(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.textTertiary,
        unselectedItemColor: AppColors.textPrimary,
      currentIndex: _selectedIndex,
      onTap: _onTabSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.travel_explore),
          label: 'Find',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'User',
        ),  
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
    )
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/navigation_controller.dart';
import 'package:secure_x/pages/find.dart';
import 'package:secure_x/pages/login_success.dart';
import 'package:secure_x/pages/user.dart';
import 'package:secure_x/routes/route_helper.dart';
import 'package:secure_x/utils/appcolors.dart';

/*class Navigation extends StatefulWidget {
  final Widget? child; // For wrapping subpages
  const Navigation({Key? key, this.child}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    Find(),
    LoginSuccess(),
    User(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If a child is provided (for subpages), show it; else show the selected tab
    return Scaffold(
      body: widget.child ?? _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.textTertiary,
        unselectedItemColor: AppColors.textPrimary,
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
            label: 'Find',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }}*/
  /*class Navigation extends StatefulWidget {
  final Widget? child;
  const Navigation({Key? key, this.child}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 1; // Store in global if you want tab persistence

  final List<Widget> _pages = [
    Find(),
    LoginSuccess(),
    User(),
  ];

  void _onTabSelected(int index) {
    if (widget.child != null) {
      // This ensures the bar always works, pops any subpage, and resets the main tab UI
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Navigation()),
        (route) => false,
      );
      // Optionally update _selectedIndex after pop if you want non-default tab
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child ?? _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.textTertiary,
        unselectedItemColor: AppColors.textPrimary,
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.travel_explore), label: 'Find'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}*/
class Navigation extends StatelessWidget {
  final Widget? child;
  const Navigation({Key? key, this.child}) : super(key: key);

  static final List<Widget> _pages = [
    Find(),
    LoginSuccess(),
    User(),
  ];

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    return Obx(() => Scaffold(
          body: child ?? _pages[navController.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: AppColors.textTertiary,
            unselectedItemColor: AppColors.textPrimary,
            currentIndex: navController.selectedIndex.value,
            onTap: (index) {
              navController.selectedIndex.value = index;
              // If you're on a subpage, go back to Navigation (core tabs)
              if (child != null) {
                Get.offAllNamed(RouteHelper.getNavigation());
              }
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.travel_explore), label: 'Find'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'User'),
            ],
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ));
  }
}




