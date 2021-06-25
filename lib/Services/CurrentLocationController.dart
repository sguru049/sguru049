import 'package:beauty_spin/Services/location_js.dart';
import 'package:beauty_spin/Utilities/LatLng/LatLng.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:js/js.dart';
import 'dart:math';

class CurrentLocationController extends GetxController {
  LatLng currentLatLong = LatLng(0.0, 0.0);
  RxBool hasCurrentLatLong = false.obs;

  @override
  void onInit() {
    _getCurrentLocation();
    super.onInit();
  }

  _getCurrentLocation() {
    if (kIsWeb) {
      getCurrentPosition(allowInterop((pos) => success(pos)));
    }
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places) as double;
    return ((value * mod).round().toDouble() / mod);
  }

  Function success(GeolocationPosition pos) {
    try {
      final double lat = roundDouble(pos.coords.latitude, 7);
      final double long = roundDouble(pos.coords.longitude, 7);
      currentLatLong = LatLng(lat, long);
      hasCurrentLatLong.value = true;
    } catch (ex) {
      print("Exception thrown : " + ex.toString());
    }
    return () {};
  }
}
