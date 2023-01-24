import 'package:flutter_sample/screens/location.dart';

class Geometry {
  final Location location;

  const Geometry({required this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry.fromJson(json['location']);
  }
}
