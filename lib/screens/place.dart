import 'package:flutter_sample/screens/geometry.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String vicinity;

  const Place(
      {required this.geometry, required this.name, required this.vicinity});

  factory Place.formJson(Map<String, dynamic> json) {
    return Place(
        geometry: Geometry.fromJson(json['geometry']),
        name: json['formatted_address'],
        vicinity: json['vicinity']);
  }
}
