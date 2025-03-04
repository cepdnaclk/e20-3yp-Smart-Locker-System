import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/models/login_model.dart';
import 'package:secure_x/models/response_model.dart';
import 'package:secure_x/pages/create_user.dart';
import 'package:secure_x/routes/route_helper.dart';
import 'package:secure_x/utils/custom_app_bar.dart';
import 'package:secure_x/utils/colors.dart';
import 'package:secure_x/utils/custom_snackbar.dart';
import 'package:secure_x/utils/loading_indicator.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

<<<<<<< Updated upstream
  // VALIDATE INPUT
  bool _validateInputs(String username, String password) {
    if (username.isEmpty) {
      CustomSnackBar('Type in your username',
          title: 'Username', iserror: false);
      return false;
    } else if (password.isEmpty) {
      CustomSnackBar('Type in your password',
          title: 'Password', iserror: false);
      return false;
    } else {
      return true;
    }
  }
=======
    final String endpointUrl='http://10.0.2.16:8080/api/lockerUser';
    //final String endpointUrl='http://192.168.8.185/api/lockerUser';
    final headers={'Content-Type':'application/json'};
    final Map<String,String> requestBody={
      'email':_emailController.text,
      'password':_passwordController.text,
    };
>>>>>>> Stashed changes

  // SIGN IN USER
  Future<void> _login() async {
    // hide the keyboard
    FocusScope.of(context).unfocus();

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    print('$username $password');

    // validate input
    if (_validateInputs(username, password)) {
      LoginModel loginModel = LoginModel(
        username: username,
        password: password,
      );
      ResponseModel apiResponse =
          await Get.find<AuthController>().login(loginModel.username, loginModel.password);

      if (apiResponse.isSuccess == true) {
        CustomSnackBar(apiResponse.message,
            iserror: false, title: 'Success');
        Get.offNamed(RouteHelper.getInitial());
      } else {
        CustomSnackBar(apiResponse.message, iserror: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar:const CustomAppBar(),
      body:GetBuilder<AuthController>(
        builder: (authController){
          return authController.isLoading? const LoadingIndicator(): SingleChildScrollView(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateUser(),));
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