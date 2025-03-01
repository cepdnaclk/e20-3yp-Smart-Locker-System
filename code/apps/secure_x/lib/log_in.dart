import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:secure_x/create_user.dart';
import 'package:secure_x/custom_app_bar.dart';
import 'package:secure_x/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  bool _isLoading=false;
  String? _errorMsg;

  Future<void> _login() async{
    setState(() {
      _isLoading=true;
      _errorMsg=null;
    });

    final String endpointUrl='';
    final headers={'Content-Type':'application/json'};
    final Map<String,String> requestBody={
      'email':_emailController.text,
      'password':_passwordController.text,
    };

    try{
      final response=await http.post(
        Uri.parse(endpointUrl), 
        headers : headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode==200){
        final responses=jsonDecode(response.body);
        String token=responses['token'];

        SharedPreferences preferences=await SharedPreferences.getInstance();
        await preferences.setString('authentication_token', token);
        print('Login successful! Token: $token');
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => MainScreen(),));
      }else{
        print('Login failed: $response');
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
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar:const CustomAppBar(),
      body:SingleChildScrollView(
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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'User Name or Email',
                        filled: true,
                        fillColor: Colors.white,
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
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    ElevatedButton(
                      onPressed:(){
                        _isLoading? null: _login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ), 
                      child: _isLoading? const CircularProgressIndicator():
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
                        foregroundColor: Colors.blue,
                      ),
                      child: const Text('CREATE ACCOUNT')
                    ),
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