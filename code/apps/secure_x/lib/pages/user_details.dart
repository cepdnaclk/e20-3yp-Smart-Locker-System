import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/models/user_model.dart';

class UserDetails extends StatelessWidget {
  UserDetails({super.key});

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final UserModel? user = _authController.userModel.value;

    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user == null
            ? const Center(child: Text('No user data available'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem("Email", user.email ?? 'Not provided'),
                  _buildDetailItem("First Name", user.username ?? 'Not provided'),
                  _buildDetailItem("ID", user.id?.toString() ?? 'Not provided'),
                  _buildDetailItem("Registration No", user.regNo ?? 'Not provided'),
                  _buildDetailItem("Phone Number", user.phoneNo?.toString() ?? 'Not provided'),
                ],
              ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text("$title: $value", style: const TextStyle(fontSize: 16)),
    );
  }
}
