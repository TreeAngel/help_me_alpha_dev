import 'dart:developer';

import 'package:help_me_mitra_alpha_ver/models/order_response_model.dart';

import 'api_controller.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';
import '../../models/auth_response_model.dart';
import '../../models/category_model.dart';
import '../../models/login_model.dart';
import '../../models/register_model.dart';
import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/api_error_response/message_error_model.dart';

class ApiHelper {
  static Future getCategories() async {
    final response = await ApiController.getData('category/all');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return DataCategory.fromJson(response);
    }
  }

  static Future authLogin(LoginModel user) async {
    Map<String, dynamic> userData = user.toJson();
    final response = await ApiController.postData('auth/login?app_type=mitra', userData,);
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return AuthResponseModel.fromMap(response);
    }
  }

  static Future authRegister(RegisterModel user) async {
    final userData = user.toJson();
    final response = await ApiController.postData('auth/register', userData);
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return AuthResponseModel.fromMap(response);
    }
  }

  static Future authForgotPassword(String phoneNumber) async {
    print('Sending forgot password request for phone number: $phoneNumber');
    final response = await ApiController.postData(
      'auth/forgot-password',
      {'phone_number': phoneNumber},
    );
    print('Response received: $response');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return AuthResponseModel.fromMap(response);
    }
  }


  static Future<ApiErrorResponseModel> authLogout({required String fcmToken}) async {
    final response = await ApiController.postData(
      'auth/logout',
      {'fcmToken': fcmToken},
    );

    // Handle response
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return ApiErrorResponseModel(error: MessageErrorModel.fromMap(response));
    }
  }

  static Future<List<OrderModel>> getOrders() async {
    final response = await ApiController.getData('users/orders');
    
    if (response is ApiErrorResponseModel) {
      throw Exception(response.message);
    }
    
    final List<dynamic> data = response;
    return data.map((orderJson) => OrderModel.fromJson(orderJson)).toList();
  }

  static Future<OrderModel> getOrderDetail(int orderId) async {
    final response = await ApiController.getData('users/orders/$orderId');
    
    if (response is ApiErrorResponseModel) {
      throw Exception(response.message);
    }
    
    return OrderModel.fromJson(response);
  }

  // static Stream getOrderFromClient(int orderId) async* {
  //   yield* Stream.periodic(const Duration(seconds: 10)).asyncMap((_) async {
  //     final response = await ApiController.getData('users/orders/$orderId');
  //     log(response.toString());
  //     if (response is ApiErrorResponseModel) {
  //       return response;
  //     } else {
  //       if (response['message'] != null) {
  //         return OrderResponseModel(data: <OrderModel>[]);
  //       } else {
  //         return OrderResponseModel.fromMap(response);
  //       }
  //     }
  //   });
  // }

  // Future<Map<String, dynamic>> fetchOrder(int orderId) async {
  //   final response = await http.get(Uri.parse('$baseUrl/orders/$orderId'));

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to load order');
  //   }
  // }


  static Future getUseProfile() async {
    final response = await ApiController.getData('auth/me');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return DataUser.fromJson(response);
    }
  }
}
