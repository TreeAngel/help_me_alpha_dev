import 'api_controller.dart';
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
    final response = await ApiController.postData('auth/login?app_type=mitra', userData);
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return AuthResponseModel.fromMap(response);
    }
  }

  static Future authRegister(RegisterModel user) async {
    Map<String, dynamic> userData = user.toJson();
    final response = await ApiController.postData('auth/register', userData);
    if (response is ApiErrorResponseModel) {
      return response;
    } else {
      return AuthResponseModel.fromMap(response);
    }
  }

  // static Future authForgotPassword(String email) async {
  //   final response = await ApiController.postData('auth/forgot-password', {'email': email});
  //   if (response is ApiErrorResponseModel) {
  //     return response;
  //   } else {
  //     return AuthResponseModel.fromMap(response);
  //   }
  // }

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
}
