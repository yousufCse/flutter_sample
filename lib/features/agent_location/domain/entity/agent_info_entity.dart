import 'package:equatable/equatable.dart';

class AgentInfoEntity extends Equatable {
  final String id;
  final String name;
  final String details;
  final String address;
  final String hyperlink;
  final double lat;
  final double lng;

  const AgentInfoEntity(
      {required this.id,
      required this.name,
      required this.details,
      required this.address,
      required this.hyperlink,
      required this.lat,
      required this.lng});

  @override
  List<Object?> get props => [id, name, details, address, hyperlink, lat, lng];
}
