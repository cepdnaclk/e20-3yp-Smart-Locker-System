import 'package:flutter/material.dart';
import 'package:secure_x/pages/create_user.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';
import 'package:secure_x/pages/log_in.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      //appBar:const CustomAppBar(),
      body:Container(
        color: AppColors.mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
                child: Container(
                  width: screenWidth*0.95,
                  height:screenHeight*0.35,
                  alignment: Alignment.center,
                  child:ClipRect(
                    child: Align(
                      alignment: Alignment.center,
                      heightFactor: 0.5,
                      widthFactor: 1,
                      child: Image.asset('assets/img/logo.png',
                      fit: BoxFit.contain,             
                    ),
                    ),
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
                            MaterialPageRoute(builder: (context) => LogIn(),));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackgroundColor2,
                          foregroundColor: AppColors.buttonBackgroundColor1,
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
                        foregroundColor: AppColors.textSecondary,
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
