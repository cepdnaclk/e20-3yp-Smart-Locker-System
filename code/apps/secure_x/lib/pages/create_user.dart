import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/models/create_user_model.dart';
import 'package:secure_x/models/response_model.dart';
import 'package:secure_x/routes/route_helper.dart';
import 'package:secure_x/utils/custom_app_bar.dart';
import 'package:secure_x/utils/colors.dart';
import 'package:secure_x/utils/custom_snackbar.dart';
import 'package:secure_x/utils/loading_indicator.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> { 
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _userNameController=TextEditingController();
  final TextEditingController _mobileNoController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _reEnterPasswordController=TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _userNameController.dispose();
    _mobileNoController.dispose();
    _passwordController.dispose();
    _reEnterPasswordController.dispose();
    super.dispose();
  }

<<<<<<< Updated upstream
  // VALIDATE INPUT
  bool _validateInputs(String email, String username,String phoneno, String password) {
    if (email.isEmpty) {
      CustomSnackBar('Type in your email', title: 'Email', iserror: false);
      return false;
    } else if (username.isEmpty) {
      CustomSnackBar('Type in your username',
          title: 'Username', iserror: false);
      return false;
    } else if (password.isEmpty) {
      CustomSnackBar('Type in your password',
          title: 'Password', iserror: false);
      return false;
    } else if (!GetUtils.isEmail(email)) {
      CustomSnackBar('Invalid Email');
      return false;
    } else if (username.length < 3 || username.length > 20) {
      CustomSnackBar('Username must be at least 3 characters.');
      return false;
    } else if (password.length < 6 || password.length > 20) {
      CustomSnackBar('Password must be at least 6 characters.');
      return false;
    } else {
      return true;
=======
    const String endpointUrl='http://10.0.2.16:8080/api/newUsers/register';
    final headers={'Content-Type':'application/json'};

    final Map<String,String> userData={
      'email':_emailController.text,
      'userName':_userNameController.text,
      'mobileNo':_mobileNoController.text,
      'password':_passwordController.text,
      'reEnterPassword':_reEnterPasswordController.text,
    };

    try{
      final response=await http.post(
        Uri.parse(endpointUrl), 
        headers : headers,
        body: jsonEncode(userData),
      );

      if (response.statusCode==200){
        final responses=jsonDecode(response.body);
        String token=responses['token'];

        SharedPreferences preferences=await SharedPreferences.getInstance();
        await preferences.setString('authentication_token', token);
        print('User created successfully! Token: $token');
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => LogIn(),));
      }else{
        print('Failed to create user: $response');
        final responses=jsonDecode(response.body);
        setState(() {
          _errorMsg=responses['message'];
        });

      }


      }catch(e){
        print('Error:$e');
      }finally{
        setState(() {
          _isLoading=false;
        });
>>>>>>> Stashed changes
    }
  }

  // REGISTER USER
  Future<void> _registration() async {
    // hide the keyboard
    FocusScope.of(context).unfocus();

    String email = _emailController.text.trim();
    String username = _userNameController.text.trim();
    String phoneNo = _mobileNoController.text.trim();
    String password = _passwordController.text.trim();
    print('$email $username $phoneNo $password');

    // validate input
    if (_validateInputs(email, username,phoneNo,password)) {
      CreateUserModel createUserModel = CreateUserModel(
        email: email,
        userName: username,
        phoneNo: phoneNo,
        password: password,
      );
      ResponseModel apiResponse =
          await Get.find<AuthController>().registraion(createUserModel);

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
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar:const CustomAppBar(),
      body:GetBuilder<AuthController>(
        builder: (authController){
          return authController.isLoading? LoadingIndicator():
         SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                        controller: _userNameController,
                        decoration:const InputDecoration(
                          hintText: 'User Name',
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
                          hintText: 'Mobile No.',
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
<<<<<<< Updated upstream
                      const SizedBox(height: 10,),
                      ElevatedButton(
                        onPressed: (){
                          _registration();
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
=======
                      keyboardType: TextInputType.text,
                      validator: (value){
                        if(value!=_passwordController.text){
                          return'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: (){
                        _createUser();
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
>>>>>>> Stashed changes
                        ),
                      ),
                      const SizedBox(height: 10,),
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