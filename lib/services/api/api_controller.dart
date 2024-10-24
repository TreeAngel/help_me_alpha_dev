import 'package:dio/dio.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../services/api/api_exception.dart';
import '../../utils/logging.dart';

class ApiController {
  // TODO: Add base url untuk akses api saat sudah dihosting
  static const baseUrl =
      'https://e1de7e962c2e7785a1d57905fcca1396.serveo.net';
  static const socketUrl =
      'https://4052e6c6b326ff24a43cf3bbb2c32181.serveo.net';
  static String? token;

  static var dio = Dio(
    BaseOptions(
      baseUrl: '$baseUrl/api/v1/',
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
      sendTimeout: const Duration(minutes: 1),
    ),
  );

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
      return ApiErrorResponseModel.fromMap(error);
    } catch (e) {
      printError(e.toString());
      throw Exception(e);
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
      return ApiErrorResponseModel.fromMap(error);
    } catch (e) {
      printError(e.toString());
      throw Exception(e);
    }
  }
}
