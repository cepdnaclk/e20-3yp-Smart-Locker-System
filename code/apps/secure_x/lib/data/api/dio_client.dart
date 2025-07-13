import 'package:dio/dio.dart';
import 'package:secure_x/utils/app_constants.dart';

class DioClient {
  final Dio _dio = Dio();

  Dio get dio=> _dio;

  DioClient() {
    // Set base URL and default headers
    _dio.options.baseUrl = AppConstants.BASE_URL;
    _dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  void printHeaders() {
  _dio.options.headers.forEach((key, value) {
    print('$key: $value');
  });
}

  // Method to update headers with the new token
  void updateHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Method to handle POST requests
  Future<Response> postData(String uri, dynamic body, {bool requireAuth=false}) async {
    try {
      print('Sending POST request to: $uri'); // Debug print
      print('Request headers: ${_dio.options.headers}'); // Debug print
      print('Request body: $body'); // Debug print

      final response = await _dio.post(uri, data: body);

      print('Received response: ${response.statusCode} - ${response.data}'); // Debug print

      return response;
    } catch (e) {
      print('Error during POST request: $e'); // Debug print
      rethrow;
    }
  }

  // Method to handle GET requests
  Future<Response> getData(String uri, {Map<String, dynamic>? queryParameters}) async {
    try {
      print('Sending GET request to: $uri'); // Debug print
      print('Request headers: ${_dio.options.headers}'); // Debug print

      final response = await _dio.get(uri, queryParameters: queryParameters);

      print('Received response: ${response.statusCode} - ${response.data}'); // Debug print

      return response;
    } catch (e) {
      print('Error during GET request: $e'); // Debug print
      rethrow;
    }
  }

  //Method to handle PUT requests
  Future<Response> putData(String uri,dynamic body) async{
    try{
      print('Sending PUT request to: $uri'); // Debug print
      print('Request headers: ${_dio.options.headers}'); // Debug print
      print('Request body: $body'); // Debug print

      final response = await _dio.put(uri, data: body);

      print('Received response: ${response.statusCode} - ${response.data}'); // Debug print

      return response;
    } catch (e) {
      print('Error during PUT request: $e'); // Debug print
      rethrow;
    }
  }

  //Method to handle PATCH requests
  Future<Response> patchData(String uri,dynamic body) async{
    try{
      print('Sending PATCH request to: $uri'); 
      print('Request headers: ${_dio.options.headers}'); 
      print('Request body: $body'); 

      final response = await _dio.patch(uri, data: body);

      print('Received response: ${response.statusCode} - ${response.data}'); // Debug print

      return response;
    } catch (e) {
      print('Error during PATCH request: $e'); 
      rethrow;
    }
  }
}