import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    _checkAndGetFcmToken();
  }

  Future<void> _checkAndGetFcmToken() async {
    // Ambil instance SharedPreferences untuk memeriksa local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Cek apakah token sudah ada di local storage
    fcmToken = prefs.getString('fcm_token');

    if (fcmToken == null) {
      // Jika token tidak ditemukan, ambil token baru dari Firebase
      fcmToken = await FirebaseMessaging.instance.getToken();

      // Simpan token baru di local storage
      if (fcmToken != null) {
        await prefs.setString('fcm_token', fcmToken!);
        print('FCM Token stored in local storage: $fcmToken');
      }
    } else {
      print('FCM Token retrieved from local storage: $fcmToken');
    }

    // Update UI untuk menampilkan token
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FCM Token Example')),
      body: Center(
        child: Text(fcmToken != null ? 'FCM Token: $fcmToken' : 'Fetching FCM Token...'),
      ),
    );
  }
}
