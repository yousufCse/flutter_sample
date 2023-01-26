import 'package:flutter_sample/features/location_search/data/model/place/geometry.dart';

class PlaceDetails {
  final Geometry geometry;
  final String name;
  final String? vicinity;

  const PlaceDetails({
    required this.geometry,
    required this.name,
    required this.vicinity,
  });

  factory PlaceDetails.formJson(Map<String, dynamic> json) {
    return PlaceDetails(
      geometry: Geometry.fromJson(json['geometry']),
      name: json['formatted_address'],
      vicinity: json['vicinity'],
    );
  }
}
