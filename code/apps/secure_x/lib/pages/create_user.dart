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

      // Call the registration method in AuthController
      final ResponseModel response = await _authController.registration(createUserModel,context);

      if (response.isSuccess) {
        //CustomSnackBar(response.message, iserror: false, title: 'Success');
        CustomSnackBar.show(
          context: context,
          message: 'Checking for admin approval...',
          //title: '',
          isError: false,
          icon: Icons.hourglass_top,);

          bool isApproved=false;
          int attempts=0;
          const int maxAttempts=12;

          while(!isApproved && attempts<maxAttempts){
            await Future.delayed(const Duration(seconds: 5));

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
          message: 'Admin approval pending. Try again later.',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: const CustomAppBar(),
      body: GetBuilder<AuthController>(
        builder: (authController) {
          return authController.isLoading.value // Access the value of RxBool
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [         
              Center(
                child: Container(
                  width: 1.sw,
                  height:250.h,
                  alignment: Alignment.center,
                  child:ClipRect(
                    child: Align(
                      alignment: Alignment.center,
                      heightFactor: 0.5,
                      //widthFactor: 1,
                      child: Image.asset('assets/img/logo.png',
                      fit: BoxFit.cover,             
                    ),
                    ),
                  )             
                ),
              ),
              Padding(
                padding:EdgeInsets.symmetric(horizontal: 5.h),
                child: Container(
                  padding: EdgeInsets.all(20.h),
                  decoration: BoxDecoration(
                    color: AppColors.boxColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                    child: Column(
                      children: [
                        TextFormField(
                        controller: _emailController,
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
                      SizedBox(height: 10.h,),
                      TextFormField(
                        controller: _firstNameController,
                        decoration:const InputDecoration(
                          hintText: 'First Name',
                          filled: true,
                          fillColor: AppColors.formFieldColor,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10.h,),
                      TextFormField(
                        controller: _lastNameController,
                        decoration:const InputDecoration(
                          hintText: 'Last Name',
                          filled: true,
                          fillColor: AppColors.formFieldColor,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10.h,),
                      TextFormField(
                        controller: _regNoController,
                        decoration:const InputDecoration(
                          hintText: 'Registration Number',
                          filled: true,
                          fillColor: AppColors.formFieldColor,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10.h,),
                      TextFormField(
                        controller: _mobileNoController,
                        decoration:const InputDecoration(
                          hintText: 'Phone Number',
                          filled: true,
                          fillColor: AppColors.formFieldColor,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 10.h,),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
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
                      SizedBox(height: 10.h,),
                      TextFormField(
                        controller: _reEnterPasswordController,
                        obscureText: true,
                        decoration:const InputDecoration(
                          hintText: 'Re enter Password',
                          filled: true,
                          fillColor: AppColors.formFieldColor,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value){
                          if(value!=_passwordController.text){
                            return'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: (){
                            _registration();
                           /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogIn(),));*/
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBackgroundColor2,
                            foregroundColor: AppColors.textInverse,
                            padding: EdgeInsets.symmetric(
                              vertical: 12.h, 
                              horizontal: 24.w),
                          ), 
                          child: Text('Create Account',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ),
          );
        },
      ),
    );
  }
}