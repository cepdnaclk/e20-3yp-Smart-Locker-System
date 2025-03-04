import 'package:flutter/material.dart';
import 'package:secure_x/pages/log_in.dart';
import 'package:secure_x/pages/find.dart';
import 'package:secure_x/pages/user.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _MainScreenState();
}

class _MainScreenState extends State<Navigation> {
  int _selectedIndex=1;

  final List<Widget> _pages=[
    Find(),
    LogIn(),
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
}