import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/pages/create_user.dart';
import 'package:secure_x/utils/colors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';
import 'package:secure_x/utils/custom_snackbar.dart';

class LogIn extends StatelessWidget {
  final AuthController _authController = Get.find(); // Get the AuthController instance

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    print('User entered username: $username'); // Debug print
    print('User entered password: $password'); // Debug print

    if (username.isEmpty || password.isEmpty) {
      print('Username or password is empty'); // Debug print
      CustomSnackBar('Username and password are required', iserror: true);
      return;
    }

    _authController.login(username, password); // Call the login method
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: CustomAppBar(),
      body: GetBuilder<AuthController>(
        builder: (authController) {
          return authController.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
              SizedBox(height: 0.01*screenHeight,),
              Padding(
                padding:EdgeInsets.symmetric(horizontal: screenHeight*0.02),
                child: Container(
                  padding: EdgeInsets.all(screenHeight*0.03),
                  decoration: BoxDecoration(
                    color: AppColors.boxColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          hintText: 'User Name or Email',
                          filled: true,
                          fillColor: AppColors.formFieldColor,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: screenHeight*0.01,),
                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration:const InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: AppColors.formFieldColor,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: screenHeight*0.01,),
                      ElevatedButton(
                        onPressed:(){
                          _login();
                          //Get.to(() => Unlock());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackgroundColor1,
                          foregroundColor: AppColors.buttonForegroundColor2,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ), 
                        child: //_isLoading? const CircularProgressIndicator():
                        const Text('LOG IN',style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight*0.01,),
                      const Text('or'),
                      TextButton(onPressed: (){
                        Get.to(() => CreateUser());        
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textColor2,
                        ),
                        child: const Text('CREATE ACCOUNT')
                      ),
                    ],
                  ),
                ),
              )
            ]
          ),
        );
        },
      ),
    );
  }
}