import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/pages/create_user.dart';
import 'package:secure_x/utils/appcolors.dart';

class LogIn extends StatefulWidget {
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthController _authController = Get.find(); 
 // Get the AuthController instance
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    print('User entered username: $username'); // Debug print
    print('User entered password: $password'); // Debug print

    if (username.isEmpty || password.isEmpty) {
      print('Username or password is empty'); // Debug print
      //CustomSnackBar('Username and password are required', iserror: true);
      //CustomSnackBar.show(message: 'Username and password are required');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and password are required'),
        backgroundColor: Colors.red.shade700,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),)
        
      );
      return;
    }

    Future.delayed(Duration(milliseconds: 100),(){
      _authController.login(username, password,context); // Call the login method
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      //appBar: CustomAppBar(),
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
                  width: 0.9.sw,
                  height:0.35.sh,
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
              SizedBox(height: 10.h,),
              Padding(
                padding:EdgeInsets.symmetric(horizontal: 0.05.sh),
                child: Container(
                  padding: EdgeInsets.all(0.05.sw),
                  decoration: BoxDecoration(
                    color: AppColors.boxColor,
                    borderRadius: BorderRadius.circular(30.r),
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
                      SizedBox(height :15.h,),
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
                      SizedBox(height: 15.h,),
                      ElevatedButton(
                        onPressed:(){
                          _login();
                          //Get.to(() => Unlock());
                          //Get.to(()=>Navigation());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackgroundColor2,
                          foregroundColor: AppColors.textInverse,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h, 
                            horizontal: 24.h),
                        ), 
                        child: //_isLoading? const CircularProgressIndicator():
                        Text('LOG IN',style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                     
                      Text('or', style: TextStyle(
                        fontSize: 18.sp,
                        )
                        ,),
                      TextButton(onPressed: (){
                        Get.to(() => CreateUser());        
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                        ),
                        child: Text('CREATE ACCOUNT',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),)
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