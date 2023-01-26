import 'package:flutter_sample/features/location_search/data/model/place/location.dart';

class Geometry {
  final Location location;

  const Geometry({required this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(location: Location.fromJson(json['location']));
  }
}
