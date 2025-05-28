import 'package:flutter/material.dart';
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
      CustomSnackBar('Type in your email', title: 'Email', iserror: true);
      return false;
    } else if (firstName.isEmpty) {
      CustomSnackBar('Type in your first name', title: 'First Name', iserror: true);
      return false;
    } else if (lastName.isEmpty) {
      CustomSnackBar('Type in your last name', title: 'Last Name', iserror: true);
      return false;
    } else if (regNo.isEmpty) {
      CustomSnackBar('Type in your registration number', title: 'Reg No.', iserror: true);
      return false;
    } else if (phoneNo.isEmpty) {
      CustomSnackBar('Type in your phone number', title: 'Phone No.', iserror: true);
      return false;
    } else if (password.isEmpty) {
      CustomSnackBar('Type in your password', title: 'Password', iserror: true);
      return false;
    } else if (password != _reEnterPasswordController.text) {
      CustomSnackBar('Passwords do not match', iserror: true);
      return false;
    } else if (!GetUtils.isEmail(email)) {
      CustomSnackBar('Invalid email format', iserror: true);
      return false;
    } else if (password.length < 6) {
      CustomSnackBar('Password must be at least 6 characters', iserror: true);
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
      final ResponseModel response = await _authController.registration(createUserModel);

      if (response.isSuccess) {
        CustomSnackBar(response.message, iserror: false, title: 'Success');
        Get.offAllNamed('/login'); // Navigate to the login screen after successful registration
      } else {
        CustomSnackBar(response.message, iserror: true);
      }
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
                  width: 1000,
                  height:200,
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
              Padding(
                padding:const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.boxColor,
                    borderRadius: BorderRadius.circular(20),
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
                      const SizedBox(height: 10,),
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
                      const SizedBox(height: 10,),
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
                      const SizedBox(height: 10,),
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
                      const SizedBox(height: 10,),
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
                      const SizedBox(height: 10,),
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
                      const SizedBox(height: 10,),
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
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: (){
                            _registration;
                            Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogIn(),));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBackgroundColor2,
                            foregroundColor: AppColors.textInverse,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          ), 
                          child: const Text('Create Account'),
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