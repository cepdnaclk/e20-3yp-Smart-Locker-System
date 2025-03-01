import 'package:flutter/material.dart';
import 'package:secure_x/custom_app_bar.dart';
import 'package:secure_x/utils/colors.dart';

class CreateUser extends StatelessWidget {
  const CreateUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar:const CustomAppBar(),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
            Padding(
              padding:const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.boxColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: AppColors.formFieldColor,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      obscureText: true,
                      decoration:const InputDecoration(
                        hintText: 'User Name',
                        filled: true,
                        fillColor: AppColors.formFieldColor,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      obscureText: true,
                      decoration:const InputDecoration(
                        hintText: 'Mobile No.',
                        filled: true,
                        fillColor: AppColors.formFieldColor,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      obscureText: true,
                      decoration:const InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: AppColors.formFieldColor,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      obscureText: true,
                      decoration:const InputDecoration(
                        hintText: 'Re enter Password',
                        filled: true,
                        fillColor: AppColors.formFieldColor,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed:(){
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackgroundColor1,
                        foregroundColor: AppColors.buttonForegroundColor2,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ), 
                      child: const Text('CREATE',style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}