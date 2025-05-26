import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/models/user_model.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class UserDetails extends StatelessWidget {
  UserDetails({super.key});

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final UserModel? user = _authController.userModel.value;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user == null
            ? const Center(child: Text('No user data available'))
            : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //User Image
                  ClipOval(
                    child: Image.asset('assets/img/userImage.png',
                    width:160,
                    height:160,
                    fit:BoxFit.cover,),
                  ),
              
                  SizedBox(height: 24,),

                  _buildDetailItem("Email", user.email ?? 'Not provided'),
                  _buildDetailItem("First Name", user.firstName ?? 'Not provided'),
                  _buildDetailItem("Last Name", user.lastName ?? 'Not provided'),
                  _buildDetailItem("ID", user.id?? 'Not provided'),
                  _buildDetailItem("Registration No", user.regNo ?? 'Not provided'),
                  _buildDetailItem("Phone Number", user.phoneNo ?? 'Not provided'),

                  SizedBox(height: 24,),
                  
                  //Edit Profile
                  SizedBox(
                    width: 120,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackgroundColor2,
                        foregroundColor: AppColors.buttonBackgroundColor1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                      ),
                      onPressed: (){}, 
                      child: const Text('Edit Profile')),
                  )
                ],
              ),
      ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: 
      //Text("$title: $value", style: const TextStyle(fontSize: 16)),
      TextFormField(
        initialValue: value,
        enabled: false,
        style:const TextStyle(
          color: AppColors.appBarColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: AppColors.appBarColor,
            )
          ),
          filled: true,
          fillColor: AppColors.boxColor,
          )
        ),
      );
  }
}
