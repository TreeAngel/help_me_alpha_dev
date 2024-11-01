import 'package:dio/dio.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/api_error_response/message_error_model.dart';
import '../../models/auth/auth_response_model.dart';
import '../../models/auth/login_model.dart';
import '../../models/auth/register_model.dart';
import '../../models/auth/user_model.dart';
import '../../models/category_problem/category_model.dart';
import '../../models/order/chat/chat_response_model.dart';
import '../../models/order/chat/send_chat_response_model/send_chat_response_mode.dart';
import '../firebase/firebase_api.dart';
import 'api_controller.dart';

class ApiHelper {
  // Auth
  static Future authLogin(LoginModel user) async {
    final userData = user.toJson();
    final response = await ApiController.postData(
      'auth/login?app_type=mitra',
      userData,
    );
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

  static Future authLogout() async {
    final response = await ApiController.postData(
      'auth/logout',
      {'fcm_token': FirebaseMessagingApi.fcmToken},
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return AuthResponseModel.fromMap(response);
    }
  }

  static Future getUserProfile() async {
    final response = await ApiController.getData('auth/me');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return DataUser.fromJson(response);
    }
  }

  static Future<ApiErrorResponseModel> requestOTP(String phoneNumber) async {
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

  static Future<ApiErrorResponseModel> forgotPassword(
      String phoneNumber) async {
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

  static Future<ApiErrorResponseModel> changePassword(
    String oldPassword,
    String newPassword,
    String newConfirmPassword,
  ) async {
    final response = await ApiController.postData(
      'auth/change-password',
      {
        'current_password': oldPassword,
        'new_password': newPassword,
        'new_password_confirmation': newConfirmPassword,
      },
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return ApiErrorResponseModel(error: MessageErrorModel.fromMap(response));
    }
  }

  static Future editProfile(FormData request) async {
    final response = await ApiController.postData(
      'users/profile',
      request,
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return EditUserResponse.fromJson(response);
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

  // static Future getProblems(String problemName) async {
  //   final response = await ApiController.getData(
  //       'categories/problems?category=$problemName');
  //   if (response is ApiErrorResponseModel) {
  //     return response;
  //   } else {
  //     List<ProblemModel> problems = [];
  //     for (var item in response as List<dynamic>) {
  //       problems.add(ProblemModel.fromMap(item));
  //     }
  //     return problems;
  //   }
  // }

  // Order
  // TODO: Order api here

  // Chat
  static Future getChatRoomCode(int orderId) async {
    final response = await ApiController.postData(
      'users/chats',
      {'order_id': orderId},
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return response['code_room'];
    }
  }

  static Future sendChatMessage(FormData request) async {
    final response = await ApiController.postData(
      'users/chats/messages',
      request,
      Headers.multipartFormDataContentType,
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return SendChatMessageResponseModel.fromMap(response);
    }
  }

  static Future getChatMessagesHistory(String roomCode) async {
    final response = await ApiController.getData(
      'users/chats/$roomCode/messages',
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      List<ChatResponseModel> messages = [];
      if (response is List<dynamic>) {
        for (var value in response) {
          messages.add(ChatResponseModel.fromMap(value));
        }
      }
      return messages;
    }
  }
}
