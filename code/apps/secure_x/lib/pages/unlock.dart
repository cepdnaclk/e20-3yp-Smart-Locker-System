import 'package:flutter/material.dart';
import 'package:secure_x/pages/login_success.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class Unlock extends StatelessWidget {
  const Unlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: const CustomAppBar(),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [         
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
          ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(
                    side: BorderSide(color: Colors.black,width:3.0),
                  ),
                  padding: const EdgeInsets.all(60),
                ),
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginSuccess(),));
                },
                child: const Text('Unlock', style: TextStyle(
                  fontSize: 22)),
          ),
          const SizedBox(height: 30),
          Container(
            padding:const EdgeInsets.all(20),
            margin:const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child:const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text('Location : xxxxxxxx ', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                 Text('Access Time : xx:xx:xx ', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                 Text('Locker No : xxx ', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            )
          ),
        ],
        ),
    );
  }
}