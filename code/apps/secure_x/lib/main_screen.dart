import 'package:flutter/material.dart';
import 'package:secure_x/custom_navigation_bar.dart';
import 'package:secure_x/find.dart';
import 'package:secure_x/home.dart';
import 'package:secure_x/user.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex=1;

  final List<Widget> _pages=[
    Find(),
    Home(),
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
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex, 
        onTabSelected: _onTabSelected
      ),
    );
  }
}