import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:secure_x/utils/custom_app_bar.dart';
import 'package:secure_x/pages/log_in.dart';
import 'package:secure_x/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isLoading=false;
  String? _errorMsg;

  Future<void> _createUser() async{
    setState(() {
      _isLoading=true;
      _errorMsg=null;
    });

    final String endpointUrl='http://10.0.2.2:8080//api/newUsers';
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
    }
  }

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
                      obscureText: true,
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
                      obscureText: true,
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
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: (){
                        _createUser;
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LogIn(),));
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