import 'package:flutter/material.dart';
import 'package:secure_x/pages/map.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class Find extends StatefulWidget {
  const Find({super.key});

  @override
  State<Find> createState() => _FindState();
}

class _FindState extends State<Find> {
  int _selectedIndex=0;
  void _onTabSelected(int index){
    setState(() {
      _selectedIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar:const CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,), 
          const Text('Locker near me', style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          ),        
          Center(
            child: Container(
              width: 400,
              height:600,
              alignment: Alignment.center,
              child:LockerMap(),         
            ),
          ),
          const SizedBox(height: 10,),
          Center(
            child: ElevatedButton(
              onPressed:(){
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ), 
              child: const Text('FIND',style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}