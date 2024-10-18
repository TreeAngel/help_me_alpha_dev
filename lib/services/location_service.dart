import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:help_me_client_alpha_ver/utils/logging.dart';

import '../utils/show_dialog.dart';

class LocationService {
  static double? lat;
  static double? long;

  static Future setPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Izin lokasi sangat diperlukan, berikan izin secara manual di pengaturan atau restart aplikasi';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return 'Izin lokasi sangat diperlukan, berikan izin secara manual di pengaturan atau restart aplikasi';
    }
  }

  static Future<Position> getLocation() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );
  }

  static Future<void> fetchLocation(BuildContext context) async {
    try {
      final location = await getLocation();
      lat = location.latitude;
      long = location.longitude;
    } catch (e) {
      if (context.mounted) {
        printError(e.toString());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowDialog.showAlertDialog(
            context,
            'Gagal mengakses lokasi',
            'Pastikan location dan interenet handphone kamu nyala ya!',
            null,
          );
        });
      }
    }
  }
}