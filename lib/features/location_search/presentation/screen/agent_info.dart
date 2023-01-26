import 'package:google_maps_flutter/google_maps_flutter.dart';

class AgentInfo {
  final String id;
  final String name;
  final String details;
  final String address;
  final String hyperlink;
  final double lat;
  final double lng;

  const AgentInfo(
      {required this.id,
      required this.name,
      required this.details,
      required this.address,
      required this.hyperlink,
      required this.lat,
      required this.lng});
}
