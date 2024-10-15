import 'logging.dart';
import 'secure_storage.dart';
import '../services/api/api_controller.dart';

class ManageAuthToken {
  static void readToken() {
    SecureStorage()
        .readSecureData('authToken')
        .then((value) => ApiController.token = value);
  }

  static void writeToken() {
    ApiController.token != null
        ? SecureStorage().writeSecureData(
            'authToken',
            ApiController.token!,
          )
        : printError('Fail to write authToken');
  }

  static void deleteToken() {
    SecureStorage().deleteSecureData('authToken');
    ApiController.token = null;
  }
}

class ManageSnapToken {
  static Future<String?> readToken() async {
    final value = await SecureStorage().readSecureData('snapToken');
    return value;
  }

  static void writeToken(String? snapToken) {
    snapToken != null
        ? SecureStorage().writeSecureData(
            'snapToken',
            snapToken,
          )
        : printError('Fail to write snapToken');
  }

  static void deleteToken() {
    SecureStorage().deleteSecureData('snapToken');
  }
}
