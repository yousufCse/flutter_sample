import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';

class AgentInfoModel extends AgentInfoEntity {
  const AgentInfoModel({
    required String id,
    required String name,
    required String details,
    required String address,
    required String hyperlink,
    required double lat,
    required double lng,
  }) : super(
          id: id,
          name: name,
          details: details,
          address: address,
          hyperlink: hyperlink,
          lat: lat,
          lng: lng,
        );

  factory AgentInfoModel.fromJson(Map<String, dynamic> map) {
    return AgentInfoModel(
        id: map['id'].toString(),
        name: map['name'],
        details: map['details'],
        address: map['address'],
        hyperlink: map['hyperlink'],
        lat: map['lat'],
        lng: map['lng']);
  }
}
