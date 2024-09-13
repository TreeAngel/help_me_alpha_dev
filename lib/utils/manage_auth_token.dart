import 'package:help_me_client_alpha_ver/utils/logging.dart';

import '../services/api/api_helper.dart';
import 'secure_storage.dart';

class ManageAuthToken {
  static void readToken() {
     SecureStorage().readSecureData('authToken').then((value) {
      if (value != null) {
        ApiHelper.token = value;
      }
    });
  }

  static void writeToken() {
    final authToken = ApiHelper.token;
    authToken != null
        ? SecureStorage().writeSecureData('authToken', authToken)
        : printError('Fail to write token');
  }

  static void deleteToken() {
    SecureStorage().deleteSecureData('authToken');
  }
}