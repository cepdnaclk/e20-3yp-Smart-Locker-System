import 'dart:convert';

import 'package:get/get.dart';
import 'package:secure_x/data/api/dio_client.dart'; // Use DioClient
import 'package:secure_x/models/create_user_model.dart';
import 'package:secure_x/models/response_model.dart';
import 'package:secure_x/models/user_model.dart';
import 'package:secure_x/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient dioClient; // Use DioClient instead of ApiClient
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  // Method to check if the token has expired
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final exp = payload['exp'];
      if (exp == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      print('Token decode error: $e');
      return true;
    }
  }

  // Method to get the user token from SharedPreferences
  Future<String?> getUserToken() async {
    try {
      final token = sharedPreferences.getString(AppConstants.TOKEN);
      print('Fetched user token: $token');

      if (token == null || _isTokenExpired(token)) {
        print('Token is null or expired');
        await clearUserToken(); // Clear if invalid
        return null;
      }

      return token;
    } catch (e) {
      print('Error fetching user token: $e');
      return null;
    }
  }

  // Method to clear the user token from SharedPreferences
  Future<void> clearUserToken() async {
    await sharedPreferences.remove(AppConstants.TOKEN);
    print('Token cleared from SharedPreferences');
  }

  // Method to handle user login
  Future<ResponseModel<String>> login(String username, String password) async {
    try {
      // Prepare the request body
      final Map<String, dynamic> loginData = {
        'username': username,
        'password': password,
      };

      print('Sending login request: ${jsonEncode(loginData)}'); // Debug print

      // Send the POST request to the backend
      final response = await dioClient.postData(
        AppConstants.LOG_IN_URI,
        loginData,
      );

      // Debug print to log the response body
      print('Response body: ${response.data}'); // Add this line

      // Check the response status code
      if (response.statusCode == 200) {
        // Directly handle the response body as a Map<String, dynamic>
        final Map<String, dynamic> responseBody = response.data;

        // Extract the token from the response
        final String token = responseBody['token']; // Ensure this matches the API response structure

        // Save the token in SharedPreferences
        sharedPreferences.setString(AppConstants.TOKEN, token);

        // Update the headers in DioClient with the new token
        dioClient.updateHeader(token);

        // Return a success response
        return ResponseModel<String>(
          isSuccess: true,
          message: 'Login successful',
          data: token, // Pass the token as data
        );
      } else if (response.statusCode == 404) {
        // User not found
        return ResponseModel<String>(
          isSuccess: false,
          message: 'User not found',
        );
      } else {
        // Login failed
        return ResponseModel<String>(
          isSuccess: false,
          message: 'Login failed: ${response.data}',
        );
      }
    } catch (e) {
      print('Network error during login: $e'); // Debug print
      return ResponseModel<String>(
        isSuccess: false,
        message: 'Network error: $e',
      );
    }
  }

  // Method to handle user registration
  Future<ResponseModel<Map<String, dynamic>>> registration(CreateUserModel createUserModel) async {
    try {
      // Prepare the request body
      final Map<String, dynamic> registrationData = createUserModel.toJson();

      print('Sending registration request: ${jsonEncode(registrationData)}'); // Debug print

      // Send the POST request to the backend
      final response = await dioClient.postData(
        AppConstants.CREATE_USER_URI,
        registrationData,
      );

      print('Received registration response: ${response.statusCode} - ${response.data}'); // Debug print

      // Check the response status code
      if (response.statusCode == 200) {
        // Registration successful
        final responseData = response.data; // Decode the JSON response

        // Return a ResponseModel with the parsed data
        return ResponseModel<Map<String, dynamic>>(
          isSuccess: true,
          message: 'Registration successful',
          data: responseData,
        );
      } else {
        // Registration failed
        return ResponseModel<Map<String, dynamic>>(
          isSuccess: false,
          message: 'Registration failed: ${response.data}',
        );
      }
    } catch (e) {
      print('Network error during registration: $e'); // Debug print
      return ResponseModel<Map<String, dynamic>>(
        isSuccess: false,
        message: 'Network error: $e',
      );
    }
  }

  // Method to fetch the signed-in user's details
  Future<ResponseModel<UserModel>> getSignedInUser() async {
    try {
      // Retrieve the token from SharedPreferences
      final String? token = sharedPreferences.getString(AppConstants.TOKEN);

      if (token == null) {
        return ResponseModel<UserModel>(
          isSuccess: false,
          message: 'User not authenticated',
        );
      }

      // Update the headers in DioClient with the current token
      dioClient.updateHeader(token);

      // Send a GET request to fetch the signed-in user's details
      final response = await dioClient.getData(AppConstants.USER_INFO_URI);

      print('Received user details response: ${response.statusCode} - ${response.data}'); // Debug print

      if (response.statusCode == 200) {
        // Parse the response and return a ResponseModel
        final userData = response.data;
        return ResponseModel<UserModel>(
          isSuccess: true,
          message: 'User details fetched successfully',
          data: UserModel.fromJson(userData), // Pass user data to the data field
        );
      } else {
        // Handle errors
        return ResponseModel<UserModel>(
          isSuccess: false,
          message: 'Failed to fetch user details: ${response.data}',
        );
      }
    } catch (e) {
      print('Network error during fetching user details: $e'); // Debug print
      return ResponseModel<UserModel>(
        isSuccess: false,
        message: 'Network error: $e',
      );
    }
  }

  // Method to unlock the locker
  // Method to unlock the locker
Future<ResponseModel> unlockLocker(String token, int clusterId) async {
  try {
    // Debug: Print updating headers with token
    print('Updating headers with token: $token');

    // Update headers with the token
    dioClient.updateHeader(token);

    // Prepare request body
    final requestBody = {
      'clusterId': clusterId, // ✅ Pass the required clusterId
    };

    // Debug: Print sending POST request
    print('Sending POST request to: ${AppConstants.UNLOCK_LOCKER_URI} with body: $requestBody');

    // Send the POST request to the backend
    final response = await dioClient.postData(
      AppConstants.UNLOCK_LOCKER_URI,
      requestBody,
    );

    // Debug: Print API response
    print('Received API response: ${response.statusCode} - ${response.data}');

    if (response.statusCode == 200) {
      return ResponseModel(
        isSuccess: true,
        message: 'Locker unlocked successfully',
      );
    } else {
      return ResponseModel(
        isSuccess: false,
        message: 'Failed to unlock locker: ${response.data}',
      );
    }
  } catch (e) {
    print('Network error during unlock: $e');
    return ResponseModel(
      isSuccess: false,
      message: 'Network error: $e',
    );
  }
}
}