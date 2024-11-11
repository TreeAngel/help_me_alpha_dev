import 'package:dio/dio.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/api_error_response/message_error_model.dart';
import '../../models/auth/auth_response_model.dart';
import '../../models/auth/login_model.dart';
import '../../models/auth/register_model.dart';
import '../../models/auth/user_mitra_model.dart';

import '../../models/auth/user_model.dart';
import '../../models/category_problem/category_model.dart';
import '../../models/misc/check_e_wallet_model.dart';
import '../../models/order/chat/chat_response_model.dart';
import '../../models/order/chat/send_chat_response_model/send_chat_response_mode.dart';
import '../../models/order/history/order_history_model.dart';
import '../../models/order/order_recieved.dart';
import '../firebase/firebase_api.dart';
import 'api_controller.dart';

class ApiHelper {
  // Misc
  static const urlCheckEWallet = 'https://api-rekening.lfourr.com/';
  static final dioCheckEWallet = Dio(
    BaseOptions(
      baseUrl: ApiHelper.urlCheckEWallet,
      sendTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );
  static Future checkBankAccount(String bankCode, String accountNumber) async {
    try {
      final response = await dioCheckEWallet.get(
        'getBankAccount',
        queryParameters: {
          'bankCode': bankCode,
          'accountNumber': accountNumber,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == true) {
          return BankResponseModel.fromMap(data['data']);
        } else {
          return ApiErrorResponseModel(
            error: MessageErrorModel(message: data['msg']),
          );
        }
      }
    } on DioException catch (e) {
      final error = ApiController.checkException(e);
      return ApiErrorResponseModel.fromMap(error);
    } catch (e) {
      throw Exception(e);
    }
  }

  // Auth
  static Future authLogin(LoginModel user) async {
    final response = await ApiController.postData(
      'auth/login?app_type=mitra',
      user.toJson(),
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return AuthResponseModel.fromMap(response);
    }
  }

  static Future authRegisterUser(RegisterUserModel user) async {
    final response = await ApiController.postData(
      'auth/register',
      user.toJson(),
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return AuthResponseModel.fromMap(response);
    }
  }

  static Future authRegisterMitra(RegisterMitraModel mitra) async {
    final response = await ApiController.postData(
      'mitras',
      mitra.toJson(),
    );
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

  static Future getUserMitra() async {
    final response = await ApiController.getData('mitras');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return UserMitraModel.fromMap(response);
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

  static Future editUserProfile(FormData request) async {
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

  static Future editMitraProfie(
      {required int mitraId, required FormData request}) async {
    final response = await ApiController.postData(
      'mitras/$mitraId',
      request,
    );
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return EditMitraResponse.fromMap(response);
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

  static Future getHelpers({required String category}) async {
    final response =
        await ApiController.getData('categories/helpers?category=$category');
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return DataCategory.fromJson(response);
    }
  }

  // Order
  static Future getAvailableOrder() async {
    String url = 'users/orders';
    final response = await ApiController.getData(url);
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      if (response is Map<String, dynamic> &&
          response.keys.contains('message')) {
        return ApiErrorResponseModel(
          error: MessageErrorModel.fromMap(response),
        );
      } else {
        List<OrderReceived> orderHistorys = [];
        for (var item in response as List<dynamic>) {
          orderHistorys.add(OrderReceived.fromMap(item));
        }
        return orderHistorys;
      }
    }
  }

  static Future getMitraHistory() async {
    String url = 'mitras/history';
    final response = await ApiController.getData(url);
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      if (response is Map<String, dynamic> &&
          response.keys.contains('message')) {
        return ApiErrorResponseModel(
          error: MessageErrorModel.fromMap(response),
        );
      } else {
        List<OrderHistoryModel> orderHistorys = [];
        for (var item in response as List<dynamic>) {
          orderHistorys.add(OrderHistoryModel.fromMap(item));
        }
        return orderHistorys;
      }
    }
  }

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
