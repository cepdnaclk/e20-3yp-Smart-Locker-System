import 'package:flutter/material.dart';
import 'package:secure_x/create_user.dart';
import 'package:secure_x/custom_app_bar.dart';
import 'package:secure_x/log_in.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

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
            const Padding(
              padding:EdgeInsets.all(10),
              child:Text('XX/XX/XXX',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 50,),
            Padding(
                padding:const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LogIn(),));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ), 
                        child: const Text('SIGN IN',style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Text('or'),
                      TextButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateUser(),));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      child: const Text('CREATE ACCOUNT')
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
