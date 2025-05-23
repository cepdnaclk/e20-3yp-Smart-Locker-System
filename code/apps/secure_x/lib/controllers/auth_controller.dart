import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:secure_x/data/repository/auth_repo.dart';
import 'package:secure_x/models/create_user_model.dart';
import 'package:secure_x/models/response_model.dart';
import 'package:secure_x/models/user_model.dart';
import 'package:secure_x/pages/login_success.dart';
import 'package:secure_x/pages/navigation.dart';
import 'package:secure_x/utils/app_constants.dart';
import 'package:secure_x/data/api/dio_client.dart';
import 'package:secure_x/utils/custom_snackbar.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;
  final DioClient dioClient = DioClient(); // Add this line

  AuthController({required this.authRepo});

  var isLoading = false.obs; // Observable for loading state
  var userModel = UserModel().obs; // Observable for user data
  var userToken = ''.obs; // Observable to store the token

  // Method to handle user login
  Future<void> login(String username, String password) async {
    isLoading.value = true; // Start loading
    print('User entered username: $username'); // Debug print
    print('User entered password: $password'); // Debug print
    print('Attempting to login with username: $username'); // Debug print

    try {
      // Call the login method in AuthRepo
      final ResponseModel<String> response = await authRepo.login(username, password);

      if (response.isSuccess) {
        // Extract the token from the response
        final String token = response.data!; // Assuming data contains the token
        userToken.value = token; // Store the token

        print('Login successful: ${response.message}'); // Debug print
        print('Token: $token'); // Debug print
        //Get.snackbar('Success', response.message); // Show a success message
        CustomSnackBar(response.message, iserror: false, title: 'Login successful', duration: Duration(seconds: 4));
        
        // Fetch the signed-in user's details
        await getSignedInUser();
        // Navigate to the LoginSuccess page
        //Get.offAll(() => LoginSuccess());
        Get.offAll(() => Navigation());
      } else {
        print('Login failed: ${response.message}'); // Debug print
        Get.snackbar('Error', response.message); // Show an error message
      }
    } catch (e) {
      print('An unexpected error occurred during login: $e'); // Debug print
      Get.snackbar('Error', 'An unexpected error occurred: $e'); // Show an error message
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // Method to handle user registration
  Future<ResponseModel<Map<String, dynamic>>> registration(CreateUserModel createUserModel) async {
    try {
      final Map<String, dynamic> registrationData = createUserModel.toJson();

      final response = await dioClient.postData(
        AppConstants.CREATE_USER_URI,
        registrationData,
      );

      print('Registration Response: ${response.statusCode} - ${response.data}');

      switch (response.statusCode) {
        case 200:
          return ResponseModel<Map<String, dynamic>>(
            isSuccess: true,
            message: 'Registration successful',
            data: response.data,
          );
        case 400:
          return ResponseModel<Map<String, dynamic>>(
            isSuccess: false,
            message: 'Invalid input: ${response.data}',
          );
        case 409:
          return ResponseModel<Map<String, dynamic>>(
            isSuccess: false,
            message: 'Registration conflict: ${response.data}',
          );
        case 403:
          return ResponseModel<Map<String, dynamic>>(
            isSuccess: false,
            message: 'Access forbidden: ${response.data}',
          );
        default:
          return ResponseModel<Map<String, dynamic>>(
            isSuccess: false,
            message: 'Unexpected error: ${response.statusCode}',
          );
      }
    } on DioException catch (dioError) {
      print('Dio Error: ${dioError.response?.statusCode} - ${dioError.response?.data}');
      return ResponseModel<Map<String, dynamic>>(
        isSuccess: false,
        message: 'Network Error: ${dioError.message}',
      );
    }
  }

  // Method to get the signed-in user's details
  Future<void> getSignedInUser() async {
    isLoading.value = true; // Start loading
    print('Fetching signed-in user details...'); // Debug print

    try {
      // Fetch the token first
      final token = await authRepo.getUserToken();

      if (token == null) {
        print('No valid token found or token expired. Please log in again.');
        Get.snackbar('Error', 'Session expired. Please log in again.');
        return; // Token is null, do not continue with fetching user details.
      }

      final ResponseModel response = await authRepo.getSignedInUser();

      if (response.isSuccess) {
        // Update userModel with the fetched data
        userModel.value = response.data; // Assuming data contains UserModel
        print('Fetched user details: ${userModel.value}'); // Debug print
        Get.snackbar('Success', 'User details fetched successfully'); // Show a success message
      } else {
        print('Failed to fetch user details: ${response.message}'); // Debug print
        Get.snackbar('Error', response.message); // Show an error message
      }
    } catch (e) {
      print('An unexpected error occurred while fetching user details: $e'); // Debug print
      Get.snackbar('Error', 'An unexpected error occurred: $e'); // Show an error message
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // Method to get the user token
  Future<String?> getUserToken() async {
    print('Fetching user token...'); // Debug print

    try {
      // Assuming the token is stored in AuthRepo or somewhere accessible
      final token = await authRepo.getUserToken(); // Call the corresponding method in AuthRepo
      print('Fetched user token: $token'); // Debug print
      return token;
    } catch (e) {
      print('Error fetching user token: $e'); // Debug print
      return null;
    }
  }

  // Method to unlock the locker
  // Method to unlock the locker
Future<ResponseModel> unlockLocker(String token, int clusterId) async {
  isLoading.value = true; // Start loading
  try {
    print('Sending unlock request to backend for cluster $clusterId...');

    final response = await authRepo.unlockLocker(token, clusterId);

    print('API Response: ${response.message}');

    if (response.isSuccess) {
      return ResponseModel(
        isSuccess: true,
        message: 'Locker unlocked successfully',
      );
    } else {
      return ResponseModel(
        isSuccess: false,
        message: 'Failed to unlock locker: ${response.message}',
      );
    }
  } catch (e) {
    print('Unexpected error during unlock: $e');
    return ResponseModel(
      isSuccess: false,
      message: 'An unexpected error occurred: $e',
    );
  } finally {
    isLoading.value = false; // Stop loading
  }
}

}
