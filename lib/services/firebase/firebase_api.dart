import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingApi {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future setPermission() async {
    NotificationSettings setting =
        await firebaseMessaging.getNotificationSettings();
    if (setting.authorizationStatus == AuthorizationStatus.notDetermined ||
        setting.authorizationStatus == AuthorizationStatus.denied) {
      await firebaseMessaging.requestPermission();
      setting = await firebaseMessaging.getNotificationSettings();
      if (setting.authorizationStatus == AuthorizationStatus.denied) {
        return 'Izin notifikasi dibutuhkan, berikan izin secara manual di setting atau restart aplikasi';
      }
    }
  }

  static void getFCMToken() async {
    final String? fcmToken = await firebaseMessaging.getToken();
    if (fcmToken != null && fcmToken.isNotEmpty) {
      
    }
  }
}
