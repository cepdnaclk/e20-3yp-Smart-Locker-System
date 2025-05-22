import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/models/user_model.dart';
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem("Email", user.email ?? 'Not provided'),
                  _buildDetailItem("First Name", user.firstName ?? 'Not provided'),
                  _buildDetailItem("Last Name", user.lastName ?? 'Not provided'),
                  _buildDetailItem("ID", user.id?? 'Not provided'),
                  _buildDetailItem("Registration No", user.regNo ?? 'Not provided'),
                  _buildDetailItem("Phone Number", user.phoneNo ?? 'Not provided'),
                ],
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
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.grey,
            )
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          )
        ),
      );
  }
}
