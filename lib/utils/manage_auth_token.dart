import 'logging.dart';
import 'secure_storage.dart';

import '../services/api/api_controller.dart';

class ManageAuthToken {
  static void readToken() {
    SecureStorage().readSecureData('authToken').then((value) {
      if (value != null) {
        ApiController.token = value;
      }
    });
  }

  static void writeToken() {
    final authToken = ApiController.token;
    authToken != null
        ? SecureStorage().writeSecureData('authToken', authToken)
        : printError('Fail to write token');
  }

  static void deleteToken() {
    SecureStorage().deleteSecureData('authToken');
    ApiController.token = null;
  }
}
