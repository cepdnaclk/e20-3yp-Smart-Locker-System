import 'package:dio/dio.dart' as dio; // Import Dio for Response type with alias
import 'package:secure_x/data/api/dio_client.dart'; // Use DioClient
import 'package:secure_x/utils/app_constants.dart';

class UserRepo {
  final DioClient dioClient; // Use DioClient instead of ApiClient

  UserRepo({
    required this.dioClient, // Update the constructor to accept DioClient
  });

  Future<dio.Response<dynamic>> getUserInfo() async {
    return await dioClient.getData(AppConstants.USER_INFO_URI); // Use DioClient's getData method
  }
}