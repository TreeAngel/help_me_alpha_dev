import 'package:dio/dio.dart';
import 'package:help_me_client_alpha_ver/models/auth_response_model.dart';
import 'package:help_me_client_alpha_ver/models/category_model.dart';
import 'package:help_me_client_alpha_ver/models/login_model.dart';
import 'package:help_me_client_alpha_ver/models/register_model.dart';
import 'package:help_me_client_alpha_ver/services/geolocator.dart';
import 'package:help_me_client_alpha_ver/utils/logging.dart';

class ApiHelper {
  static const baseUrl = null;
  static const temporaryUrl =
      'https://e1b2-2001-448a-302c-13d2-b9d2-f6d2-22fb-ad24.ngrok-free.app/api/';

  static String token = '';

  static var dio = Dio(
    BaseOptions(
      baseUrl: temporaryUrl,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  static double lat = 0;
  static double long = 0;

  static Future<void> fetchLocation() async {
    try {
      final location = await getLocation();
      lat = location.latitude;
      long = location.longitude;
    } catch (e) {
      printWarning(e.toString());
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> _getData(String url) async {
    try {
      final response = await dio.get(
        url,
        options: token.isNotEmpty
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        printWarning(
            'Failed to fetch data: ${response.statusCode} | ${response.statusMessage}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      printWarning(e.toString());
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> _postData(
      String url, Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        url,
        data: data,
        options: token.isNotEmpty
            ? Options(headers: {
                'Authorization': 'Bearer $token',
              })
            : null,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        printWarning(
            'Failed to post data: ${response.statusCode} | ${response.statusMessage}');
        throw Exception('Failed to post data');
      }
    } catch (e) {
      printWarning(e.toString());
      throw Exception(e);
    }
  }

  static Future<DataCategory> getCategories() async {
    final response = await _getData('category/all');
    return DataCategory.fromJson(response);
  }

  // static Future<AuthResponseModel> authLogin(
  //     String username, String password) async {
  //   final response = await _postData('auth/login', {
  //     'username': username,
  //     'password': password,
  //   });
  //   return AuthResponseModel.fromMap(response);
  // }

  static Future<AuthResponseModel> authLogin(LoginModel user) async {
    Map<String, dynamic> userData = user.toJson();
    final response = await _postData('auth/login', userData);
    return AuthResponseModel.fromMap(response);
  }

  static Future<AuthResponseModel> authRegister(RegisterModel user) async {
    Map<String, dynamic> userData = user.toJson();
    final response = await _postData('auth/register', userData);
    return AuthResponseModel.fromMap(response);
  }
}
