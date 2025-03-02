import 'package:flutter/material.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar:const CustomAppBar(),
      body:Container(
        color: Colors.blue[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),            
              child:Center(
                child: CircleAvatar(
                  radius:80,
                  backgroundColor:Colors.white,
                  child:ClipOval(
                    child: Image.asset('assets/img/userImage.png',
                    width:160,
                    height:160,
                    fit:BoxFit.cover,
                    )
                  )
                ),
              )
            ),
            const SizedBox(height: 20,),
            Padding(
                padding:const EdgeInsets.symmetric(horizontal: 20,),
                child: Container(
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('XX/XX/XXX',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 20,),
                      TextButton.icon(
                        onPressed: (){
                      }, 
                      icon: const Icon(
                        Icons.person_4_outlined,
                        color: Colors.black,
                      ),
                      label: const Text('User Detail',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),)
                      ),
                      const SizedBox(height: 20,),
                      TextButton.icon(
                        onPressed: (){
                      }, 
                      icon: const Icon(
                        Icons.history,
                        color: Colors.black,
                      ),
                      label: const Text('User History',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),)
                      ),
                      const SizedBox(height: 20,),
                      TextButton.icon(
                        onPressed: (){
                      }, 
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      label: const Text('Settings',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),)
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20,)   
          ],
        ),      
      ),
    );    
  }
}
