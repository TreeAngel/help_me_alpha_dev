import 'package:dio/dio.dart';
import 'package:help_me_client_alpha_ver/models/api_error_response/api_error_response_model.dart';
import 'package:help_me_client_alpha_ver/models/api_error_response/message_error_model.dart';
import 'package:help_me_client_alpha_ver/models/auth_response_model.dart';
import 'package:help_me_client_alpha_ver/models/category_model.dart';
import 'package:help_me_client_alpha_ver/models/login_model.dart';
import 'package:help_me_client_alpha_ver/models/register_model.dart';
import 'package:help_me_client_alpha_ver/services/api/api_exception.dart';
import 'package:help_me_client_alpha_ver/services/geolocator.dart';
import 'package:help_me_client_alpha_ver/utils/logging.dart';

class ApiHelper {
  static const baseUrl = null;
  static const temporaryUrl = 'http://192.168.1.13:8080/api/';
  static String? token;

  static var dio = Dio(
    BaseOptions(
      baseUrl: temporaryUrl,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 50),
      sendTimeout: const Duration(seconds: 50),
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
      printError(e.toString());
      throw Exception(e);
    }
  }

  static Map<String, dynamic> checkException(DioException error) {
    ApiException exception = ApiException();
    return exception.apiException(error);
  }

  static Future _getData(String url) async {
    try {
      final response = await dio.get(
        url,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return response.data;
      } else {
        printWarning(
            'Failed to fetch data: ${response.statusCode} | ${response.statusMessage}');
        throw Exception('Failed to load data');
      }
    } on DioException catch (e) {
      final error = checkException(e);
      printError(e.toString());
      return ApiErrorResponseModel(
          error: MessageErrorModel.fromMap(error));
    } catch (e) {
      printError(e.toString());
      throw Exception(e);
    }
  }

  static Future _postData(String url, [Map<String, dynamic>? data]) async {
    try {
      final response = await dio.post(
        url,
        data: data,
        options: token != null
            ? Options(headers: {
                'Authorization': 'Bearer $token',
              })
            : null,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return response.data;
      } else {
        printWarning(
            'Failed to post data: ${response.statusCode} | ${response.statusMessage}');
        throw Exception('Failed to post data');
      }
    } on DioException catch (e) {
      final error = checkException(e);
      printError(e.toString());
      return ApiErrorResponseModel(
          error: MessageErrorModel.fromMap(error));
    } on TypeError catch(_) {
      // final error = checkException(e);
      return const MessageErrorModel(
          message: 'Error, maybe you are not authorized? 😅');
    } catch (e) {
      printError(e.toString());
      throw Exception(e);
    }
  }

  static Future getCategories() async {
    final response = await _getData('category/all');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return DataCategory.fromJson(response);
    }
  }

  static Future authLogin(LoginModel user) async {
    Map<String, dynamic> userData = user.toJson();
    final response = await _postData('auth/login', userData);
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return AuthResponseModel.fromMap(response);
    }
  }

  static Future authRegister(RegisterModel user) async {
    Map<String, dynamic> userData = user.toJson();
    final response = await _postData('auth/register', userData);
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return AuthResponseModel.fromMap(response);
    }
  }

  static Future<ApiErrorResponseModel> authLogout() async {
    final response = await _postData('auth/logout');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return ApiErrorResponseModel(error: MessageErrorModel.fromMap(response));
    }
  }
}
