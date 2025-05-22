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
            : Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildReadOnlyField("Email", user.email ?? 'Not provided'),
                      _buildReadOnlyField("First Name", user.firstName ?? 'Not provided'),
                      _buildReadOnlyField("Last Name", user.lastName ?? 'Not provided'),
                      _buildReadOnlyField("ID", user.id ?? 'Not provided'),
                      _buildReadOnlyField("Registration No", user.regNo ?? 'Not provided'),
                      _buildReadOnlyField("Phone Number", user.phoneNo ?? 'Not provided'),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
