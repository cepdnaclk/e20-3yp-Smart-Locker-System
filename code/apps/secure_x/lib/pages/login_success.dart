import 'package:flutter/material.dart';
import 'package:secure_x/pages/find.dart';
import 'package:secure_x/pages/navigation.dart';
import 'package:secure_x/pages/unlock.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class LoginSuccess extends StatelessWidget {
  const LoginSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar:const CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20,), 
          const Center(
            child: Text('Welcome!', style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),        
          Center(
            child: Container(
              width: 800,
              height:350,
              alignment: Alignment.center,
              child:ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 0.5,
                  child: Image.asset('assets/img/logo.png',
                  fit: BoxFit.cover,             
                ),
                ),
              )             
            ),
          ),
          const SizedBox(height: 10,),
          Center(
            child: TextButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Unlock(),));
                  //builder: (context) => const Navigation(selectedIndex: 3),
                //));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            child: const Text('Unlock my Locker' ,style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),)
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Find(),));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            child: const Text('Search a Locker' ,style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),)
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}