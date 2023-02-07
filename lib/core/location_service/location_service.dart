import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationService {
  Future<LatLng> getCurrentLocation();
}

class LocationServiceImpl implements LocationService {
  LocationServiceImpl();

  @override
  Future<LatLng> getCurrentLocation() async {
    if (await _hasLocationPermission()) {
      Position position = await Geolocator.getCurrentPosition();

      return LatLng(position.latitude, position.longitude);
    } else {
      throw Exception();
    }
  }

  Future<bool> _hasLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
