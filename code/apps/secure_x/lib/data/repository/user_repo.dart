import 'package:secure_x/data/api/api_client.dart';
import 'package:secure_x/utils/app_constants.dart';
import 'package:get/get.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({
    required this.apiClient,
  });

  Future<Response> getUserInfo()async {
    return await apiClient.getData(AppConstants.USER_INFO_URI);
  }
  
}