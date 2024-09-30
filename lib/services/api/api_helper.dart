import 'package:dio/dio.dart';

import '../../models/order_history_model.dart';
import 'api_controller.dart';
import '../../models/order_response_model/order_response_model.dart';
import '../../models/problem_model.dart';
import '../../models/user_model.dart';
import '../../models/auth_response_model.dart';
import '../../models/category_model.dart';
import '../../models/login_model.dart';
import '../../models/register_model.dart';
import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/api_error_response/message_error_model.dart';

class ApiHelper {
  // Auth
  static Future authLogin(LoginModel user) async {
    final userData = user.toJson();
    final response =
        await ApiController.postData('auth/login?app_type=user', userData);
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

  static Future<ApiErrorResponseModel> authLogout() async {
    final response = await ApiController.postData('auth/logout');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return ApiErrorResponseModel(error: MessageErrorModel.fromMap(response));
    }
  }

  static Future getUseProfile() async {
    final response = await ApiController.getData('auth/me');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return DataUser.fromJson(response);
    }
  }

  // Verify account & manage password
  static Future<ApiErrorResponseModel> requestVerification(
      String phoneNumber) async {
    final response = await ApiController.postData(
      'auth/verification',
      {'phone_number': phoneNumber},
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return ApiErrorResponseModel(error: MessageErrorModel.fromMap(response));
    }
  }

  static Future<ApiErrorResponseModel> verifyOTP(
    String phoneNumber,
    String otp,
  ) async {
    final response = await ApiController.postData(
      'auth/verify',
      {
        'phone_number': phoneNumber,
        'verification_code': otp,
      },
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return ApiErrorResponseModel(error: MessageErrorModel.fromMap(response));
    }
  }

  Future<ApiErrorResponseModel> forgotPassword(String phoneNumber) async {
    final response = await ApiController.postData(
      'auth/forgot-password',
      {'phone_number': phoneNumber},
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return ApiErrorResponseModel(error: MessageErrorModel.fromMap(response));
    }
  }

  Future<ApiErrorResponseModel> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final response = await ApiController.postData(
      'auth/change-password',
      {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      },
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return ApiErrorResponseModel(error: MessageErrorModel.fromMap(response));
    }
  }

  // Problem & Category
  static Future getCategories() async {
    final response = await ApiController.getData('categories');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return DataCategory.fromJson(response);
    }
  }

  static Future getProblems(String problemName) async {
    final response = await ApiController.getData(
        'categories/problems?category=$problemName');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      List<ProblemModel> problems = [];
      for (var item in response as List<dynamic>) {
        problems.add(ProblemModel.fromMap(item));
      }
      return problems;
    }
  }

  // Order
  static Future postOrder(FormData request) async {
    final response = await ApiController.postData(
      'users/orders',
      request,
      Headers.multipartFormDataContentType,
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return OrderResponseModel.fromMap(response);
    }
  }

  static Future getOrderHistory(String status) async {
    String url = 'users/orders';
    status.isNotEmpty ? url += '?status=$status' : null;
    final response = await ApiController.getData(url);
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      List<OrderHistoryModel> orderHistorys = [];
      for (var item in response as List<dynamic>) {
        orderHistorys.add(OrderHistoryModel.fromMap(item));
      }
      return orderHistorys;
    }
  }
}
