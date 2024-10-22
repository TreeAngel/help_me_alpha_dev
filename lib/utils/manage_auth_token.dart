import 'logging.dart';
import 'secure_storage.dart';

import '../services/api/api_controller.dart';
// import '../services/firebase/firebase_api.dart';


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

// class ManageFCMToken {
//   static Future<String?> readToken() async {
//     final value = await SecureStorage().readSecureData('fcmToken').then(
//           (value) => FirebaseMessagingApi.fcmToken == null
//               ? FirebaseMessagingApi.fcmToken = value
//               : null,
//         );
//     return value;
//   }

//   static void writeToken(String? fcmToken) async {
//     fcmToken != null
//         ? await SecureStorage().writeSecureData(
//             'fcmToken',
//             fcmToken,
//           )
//         : printError('Fail to write fcmToken');
//   }

//   static void deleteToken() async {
//     await SecureStorage().deleteSecureData('fcmToken');
//   }
// }
