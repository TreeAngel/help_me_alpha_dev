import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> initNotification() async {
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();

    print('Token : $fcmToken');
    return fcmToken;
  }
}


// class FirebaseMessagingApi {
//   static String? fcmToken;
//   static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

//   static Future setPermission() async {
//     NotificationSettings setting =
//         await firebaseMessaging.getNotificationSettings();
//     if (setting.authorizationStatus == AuthorizationStatus.notDetermined ||
//         setting.authorizationStatus == AuthorizationStatus.denied) {
//       await firebaseMessaging.requestPermission();
//       setting = await firebaseMessaging.getNotificationSettings();
//       if (setting.authorizationStatus == AuthorizationStatus.denied) {
//         return 'Izin notifikasi dibutuhkan, berikan izin secara manual di setting atau restart aplikasi';
//       }
//     }
//   }

//   static Future<String?> getFCMToken() async {
//     final token = await firebaseMessaging.getToken();
//     return token;
//   }
// }