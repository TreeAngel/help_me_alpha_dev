import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_mitra_alpha_ver/blocs/fetch_order/fetch_order_bloc.dart';

class FirebaseMessagingService {
  final FetchOrderBloc fetchOrderBloc;

  FirebaseMessagingService({required this.fetchOrderBloc}) {
    _initialize();
  }

  void _initialize() {
    // Dapatkan token FCM dan cetak ke console
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");
      // Simpan token ini ke backend atau tampilkan di UI sesuai kebutuhan
    });

    // Listen pesan saat aplikasi di foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Cek jika ada notifikasi
      if (message.notification != null) {
        final title = message.notification?.title ?? 'No Title';
        final body = message.notification?.body ?? 'No Body';

        // Cek jika ada data di pesan
        if (message.data.isNotEmpty) {
          final orderId = int.tryParse(message.data['order_id'] ?? '0') ?? 0;
          final problem = message.data['problem'] ?? 'No Problem Found';
          final description = message.data['description'] ?? 'No Problem Found';
          // Panggil event di FetchOrderBloc jika orderId valid
          if (orderId != 0) {
            fetchOrderBloc.add(FetchOrderNotificationEvent(problem, description));
          } else {
            // Jika tidak ada orderId, bisa handle atau log disini
            print('No valid order_id found in notification data.');
          } 
        }
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}

