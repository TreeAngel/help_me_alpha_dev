import 'package:dio/dio.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/api_error_response/message_error_model.dart';
import 'api_exception.dart';
import '../geolocator.dart';
import '../../utils/logging.dart';

class ApiController {
  static const baseUrl = null;
  static const temporaryUrl =
      'https://aba8a4b18ffd55030bdb926614075a10.serveo.net';
  static String? token;

  static var dio = Dio(
    BaseOptions(
      baseUrl: '$temporaryUrl/api/v1/',
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
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
      return ApiErrorResponseModel(error: MessageErrorModel.fromMap(error));
    } catch (e) {
      printError(e.toString());
      throw Exception(e);
    }
  }

  static Future postData(String url, {Map<String, dynamic>? data}) async {
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
      if (e.response != null) {
        //respons dari server ada
        // print('DioException response: ${e.response?.data}');
        final error = checkException(e);
        return ApiErrorResponseModel(error: MessageErrorModel.fromMap(error));
      } else {
        // jika tidak ada respons dari server (mungkin masalah koneksi)
        printError('Request failed: ${e.message}');
        return const MessageErrorModel(message: 'Failed to reach server');
      }
    } on TypeError catch (_) {
      //final error = checkException(e);
      return const MessageErrorModel(
          message: 'Error, maybe you are not authorized? 😅');
    } catch (e) {
      printError(e.toString());
      throw Exception(e);
    }
  }
}
