import 'dart:developer';

import 'package:dio/dio.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../services/api/api_exception.dart';
import '../../utils/logging.dart';

class ApiController {
  // TODO: Add base url untuk akses api saat sudah dihosting
  static const baseUrl = 'https://e249e5482307a05ed073b16cfd9a3222.serveo.net';
  static String? token;

  static var dio = Dio(
    BaseOptions(
      baseUrl: '$baseUrl/api/v1/',
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
    ),
  );

  // static double lat = 0;
  // static double long = 0;

  // static Future<void> fetchLocation() async {
  //   try {
  //     final location = await getLocation();
  //     lat = location.latitude;
  //     long = location.longitude;
  //   } catch (e) {
  //     printError(e.toString());
  //     throw Exception(e);
  //   }
  // }


  static Map<String, dynamic> checkException(DioException error) {
    ApiException exception = ApiException();
    return exception.apiException(error);
  }

  static Future getData(String url) async {
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
      log(e.response.toString());
      return ApiErrorResponseModel.fromMap(error);
    } catch (e) {
      printError(e.toString());
      throw Exception(e);
    }
  }

   Future<Map<String, dynamic>> getOrder() async {
    try {
      return await getData('orders/44'); // Memanggil getData() untuk mendapatkan order dengan ID 44
    } catch (e) {
      throw Exception('Failed to load order');
    }
  }

  static Future postData(
    String url, [
    dynamic data,
    String? extraHeaders,
  ]) async {
    try {
      final response = await dio.post(
        url,
        data: data,
        options: token != null
            ? Options(headers: {
                'Authorization': 'Bearer $token',
              }, contentType: extraHeaders ?? Headers.jsonContentType)
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
      log(e.response.toString());
      return ApiErrorResponseModel.fromMap(error);
    } catch (e) {
      printError(e.toString());
      throw Exception(e);
    }
  }
}