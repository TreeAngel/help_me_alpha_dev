import 'package:dio/dio.dart';
import 'package:help_me_alpha_dev/services/geolocator.dart';
import 'package:help_me_alpha_dev/utils/logging.dart';

class ApiHelper {
  static const baseUrl = null;
  static const temporaryUrl =
      'https://helpme.smkn2smi.sch.id/api/v1'; 

  static String token = '';

  static var dio = Dio(
    BaseOptions(
        baseUrl: temporaryUrl,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json),
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

  static Future<Map<String, dynamic>> _fetchData(String url) async {
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

  static Future<Map<String, dynamic>> _postData(String url, Map<String, dynamic> data) async {
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
            'Failed to fetch data: ${response.statusCode} | ${response.statusMessage}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      printWarning(e.toString());
      throw Exception(e);
    }
  }
}
