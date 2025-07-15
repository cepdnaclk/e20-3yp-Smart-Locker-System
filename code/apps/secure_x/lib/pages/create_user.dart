import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/models/create_user_model.dart';
import 'package:secure_x/models/response_model.dart';
import 'package:secure_x/pages/log_in.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';
import 'package:secure_x/utils/custom_snackbar.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController = TextEditingController();

  final AuthController _authController = Get.find(); // Get the AuthController instance

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _regNoController.dispose();
    _mobileNoController.dispose();
    _passwordController.dispose();
    _reEnterPasswordController.dispose();
    super.dispose();
  }

  // Validate user inputs
  bool _validateInputs(String email, String firstName, String lastName, String regNo, String phoneNo, String password) {
    if (email.isEmpty) {
      //CustomSnackBar('Type in your email', title: 'Email', iserror: true);
      //CustomSnackBar.show(message: 'Type in your email');
      CustomSnackBar.show(
          context: context, 
          message: 'Type in your email',
          title: 'Email',
          isError: true,
      );
      return false;
    } else if (firstName.isEmpty) {
      //CustomSnackBar('Type in your first name', title: 'First Name', iserror: true);
      //CustomSnackBar.show(message:'Type in your first name');
      CustomSnackBar.show(
          context: context, 
          message: 'Type in your first name',
          title: 'First Name',
          isError: true,
      );
      return false;
    } else if (lastName.isEmpty) {
      //CustomSnackBar('Type in your last name', title: 'Last Name', iserror: true);
      //CustomSnackBar.show(message: 'Type in your last name');
      CustomSnackBar.show(
          context: context, 
          message: 'Type in your last name',
          title: 'Last Name',
          isError: true,
      );
      return false;
    } else if (regNo.isEmpty) {
      //CustomSnackBar('Type in your registration number', title: 'Reg No.', iserror: true);
      //CustomSnackBar.show(message: 'Type in your registration number');
      CustomSnackBar.show(
          context: context, 
          message: 'Type in your registration number',
          title: 'Reg No.',
          isError: true,
      );
      return false;
    } else if (phoneNo.isEmpty) {
      //CustomSnackBar('Type in your phone number', title: 'Phone No.', iserror: true);
      //CustomSnackBar.show(message: 'Type in your phone number');
      CustomSnackBar.show(
          context: context, 
          message: 'Type in your phone number',
          title: 'Phone No.',
          isError: true,
      );
      return false;
    } else if (password.isEmpty) {
      //CustomSnackBar('Type in your password', title: 'Password', iserror: true);
      //CustomSnackBar.show(message: 'Type in your password');
      CustomSnackBar.show(
          context: context, 
          message: 'Type in your password',
          title: 'Password',
          isError: true,
      );
      return false;
    } else if (password != _reEnterPasswordController.text) {
      //CustomSnackBar('Passwords do not match', iserror: true);
      //CustomSnackBar.show(message: 'Passwords do not match');
      CustomSnackBar.show(
          context: context, 
          message: 'Passwords do not match',
          //title: 'First Name',
          isError: true,
      );
      return false;
    } else if (!GetUtils.isEmail(email)) {
      //CustomSnackBar('Invalid email format', iserror: true);
      //CustomSnackBar.show(message: 'Invalid email format');
      CustomSnackBar.show(
          context: context, 
          message: 'Invalid email format',
          //title: 'First Name',
          isError: true,
      );
      return false;
    } else if (password.length < 6) {
      //CustomSnackBar('Password must be at least 6 characters', iserror: true);
      //CustomSnackBar.show(message: 'Password must be at least 6 characters');
      CustomSnackBar.show(
          context: context, 
          message: 'Password must be at least 6 characters',
          //title: 'First Name',
          isError: true,
      );
      return false;
    } else {
      return true;
    }
  }

  // Register user
  Future<void> _registration() async {
    final String email = _emailController.text.trim();
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String regNo = _regNoController.text.trim();
    final String phoneNo = _mobileNoController.text.trim();
    final String password = _passwordController.text.trim();

    if (_validateInputs(email, firstName, lastName, regNo, phoneNo, password)) {
      // Create a CreateUserModel
      final CreateUserModel createUserModel = CreateUserModel(
        email: email,
        firstName: firstName,
        lastName: lastName,
        regNo: regNo,
        phoneNo: phoneNo,
        password: password,
      );

      //Get.to(() => LogIn());

      // Call the registration method in AuthController
      final ResponseModel response = await _authController.registration(createUserModel,context);

      if (response.isSuccess) {
        //CustomSnackBar(response.message, iserror: false, title: 'Success');
        CustomSnackBar.show(
          context: context,
          message: 'Checking for admin approval... Try to login',
          //title: '',
          isError: false,
          icon: Icons.hourglass_top,);

          bool isApproved=false;
          int attempts=0;
          const int maxAttempts=3;

          while(!isApproved && attempts<maxAttempts){
            await Future.delayed(const Duration(seconds: 2));

            isApproved=await _authController.checkApprovalStatus(email,password);

            attempts++;
          }

          if(isApproved){
            await _authController.getOTPCode(context);

            showDialog(
              context: context, 
              builder: (context)=>AlertDialog(
                title: const Text('Approved'),
                content: Text('Your OTP Code is : ${_authController.otpCode.value}'),
                actions: [
                  TextButton(
                    onPressed: ()=>Navigator.pop(context),
                    child: const Text('OK'),
                  )
                ],
              ),
            );
          }
        Get.offAllNamed('/login'); // Navigate to the login screen after successful registration
      } else {
        CustomSnackBar.show(
          context: context,
          message: 'Admin approval pending. Try to login',
          title: 'Warning',
          isError: true,
          icon: Icons.lock_clock,
          textColor: Colors.white,
        );
        Get.offAllNamed('/login'); // Navigate to the login screen after registration
      }
      }else{
        CustomSnackBar.show(
          context: context, 
          message: 'Admin approval failed',
          title: 'Registration Failed',
          isError: true,
          icon: Icons.warning_amber_rounded,
        );
      }
      //Get.offAllNamed('/login');
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: CustomAppBar(),
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
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.02.sh),
                  child: Container(
                    height: 0.83.sh,
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
                        Colors.black.withAlpha((0.4 * 255).round()), 
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
                      Text('Name',style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 4.h,),
                      TextFormField(
                        controller: _firstNameController,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.appBarColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
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
                      SizedBox(height :4.h,),
                      TextFormField(
                        controller: _lastNameController,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.appBarColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
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
                      SizedBox(height: 6.h,),
                      Text('Registration Number',style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 6.h,),
                      TextFormField(
                        controller: _regNoController,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.appBarColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter Reg. No (e.g., EXXYYY)',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
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
                      SizedBox(height: 4.h,),
                      Text('Contact Number',style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 4.h,),
                      TextFormField(
                        controller: _mobileNoController,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.appBarColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your phone number',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
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
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 4.h,),
                      Text('Email',style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 4.h,),
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.appBarColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
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
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 6.h,),
                      Text('Password',style: TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),),
                      SizedBox(height: 6.h,),
                      TextFormField(
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter your Password',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
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
                      Text('Confirm Password',style: TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),),
                      SizedBox(height: 6.h,),
                      TextFormField(
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textPrimary,
                        ),
                        obscureText: true,
                        controller: _reEnterPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Re-enter Password',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
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
                        validator: (value) {
                          if(value!=_passwordController.text){
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 6.h,),
                      ElevatedButton(
                        onPressed:(){
                          _registration();
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
                        Text('SIGN UP',style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      Center(
                        child: RichText(text: TextSpan(
                          text: "Do you have an account? ",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: (){
                                  Get.to(()=> LogIn());
                                },
                                child: Text('Sign in',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  //decoration: TextDecoration.underline,
                                  fontSize: 12.sp,
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
            
              //SizedBox(height: 0.1.sh),
          ))]
          ),
        );
        },
      ),
  ]
    ));
  }
}