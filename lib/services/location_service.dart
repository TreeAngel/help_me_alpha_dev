import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../ui/widgets/custom_dialog.dart';

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

  static Stream<Position> trackLocation() async* {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomDialog.showAlertDialog(
            context,
            'Gagal mengakses lokasi',
            'Pastikan location dan interenet handphone kamu nyala ya!',
            null,
          );
        });
      }
    }
  }

  static Future<List<Placemark>> fromLatLong(
      {required double lat, required double long}) async {
    return await placemarkFromCoordinates(lat, long);
  }

  static Future<List<Location>> fromAddress({required String address}) async {
    return await locationFromAddress(address);
  }
}
