import 'package:get/get.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late Map<String, String> _mainHeaders;

  // CONSTRUCTOR
  ApiClient({required this.appBaseUrl}) {
    super.baseUrl = appBaseUrl;
    super.timeout = const Duration(seconds: 50);
    token = '';
    _mainHeaders = {
      'content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }

  // GET METHOD
  Future<Response> getData(String uri,
      {Map<String, String>? queryParameters}) async {
    try {
      print(uri);
      print(baseUrl);
      Response response =
          await get(uri, query: queryParameters ?? {}, headers: _mainHeaders);
      print(response.statusCode);
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // POST METHOD
  Future<Response> postData(String uri, dynamic body) async {
    try {
      print(uri);
      print(baseUrl);
      Response response = await post(uri, body, headers: _mainHeaders);
      print(response.statusCode);
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // PUT METHOD
  Future<Response> putData(String uri, dynamic body) async {
    try {
      print(uri);
      print(baseUrl);
      Response response = await put(uri, body, headers: _mainHeaders);
      print(response.statusCode);
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // PUT FORMDATA
  Future<Response> putFormData(String uri, dynamic formData) async {
    try {
      print(uri);
      print(baseUrl);

      var headers = {'Authorization': 'Bearer $token'};

      Response response = await put(uri, formData, headers: headers);
      print(response.statusCode);
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // DELETE METHOD
  Future<Response> deleteData(String uri) async {
    try {
      print(uri);
      print(baseUrl);
      Response response = await delete(uri, headers: _mainHeaders);
      print(response.statusCode);
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
