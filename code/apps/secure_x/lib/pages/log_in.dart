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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and password are required'),
        backgroundColor: Colors.red.shade700,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
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
      body: Stack(
        fit: StackFit.expand,
  children: [
    Positioned.fill(
      child: Image.asset(
        'assets/img/backpattern.jpg', 
        fit: BoxFit.cover,
      ),
    ),
      GetBuilder<AuthController>(
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
                      heightFactor: 0.8,
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
                  padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.02.sh),
              child: Container(
                height: 0.45.sh,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        image:const DecorationImage(
                          image: AssetImage('assets/img/loginPattern.png'),
                          fit: BoxFit.cover,
                          
                          
                        ),
                      ),
                    ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withAlpha((0.7 * 255).round()), // Top color
                        Colors.black.withAlpha((0.3 * 255).round()), 
                        //Colors.transparent,             // Middle (transparent)
                        Colors.black.withAlpha((0.7 * 255).round()), // Bottom color
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(0.05.sw),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.stretch,
                    children: [
                      Text('Username',style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 6.h,),
                      TextFormField(
                        controller: _usernameController,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.appBarColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15.sp,
                          ),
                          filled: true,
                          fillColor: AppColors.formFieldColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.transparent), // No border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: AppColors.textTertiary), // No border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.black), // Or any color you prefer
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height :15.h,),
                      Text('Password',style: TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),),
                      SizedBox(height: 6.h,),
                      TextFormField(
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.textPrimary,
                        ),
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter your Password',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15.sp,
                          ),
                          filled: true,
                          fillColor: AppColors.formFieldColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.transparent), // No border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.transparent), // No border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.black), // Or any color you prefer
                          ),),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 3.h,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){

                          }, 
                          child: Text('Forgot Password?',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16.sp,
                          ),
                          )),
                      ),
                      SizedBox(height: 3.h,),
                      ElevatedButton(
                        onPressed:(){
                          _login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textPrimary,
                          foregroundColor: AppColors.buttonBackgroundColor1,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h, 
                            horizontal: 24.h
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ), 
                        child: 
                        Text('SIGN IN',style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      Center(
                        child: RichText(text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: (){
                                  Get.to(()=> CreateUser());
                                },
                                child: Text('Sign Up',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                ),),
                              ))
                          ]

                        )),
                     )
                      
                    ],
                  ),
                ),
                ]
              ),
          ))]
          ),
        );
        },
      ),
  ]
    ));
  }
}