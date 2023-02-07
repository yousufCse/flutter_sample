import 'package:flutter/material.dart';
import 'package:flutter_sample/features/agent_location/data/datasource/agent_location_remote.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';
import 'package:flutter_sample/features/agent_location/domain/repository/agent_location_repository.dart';

class AgentLocationRepositoryImpl implements AgentLocationRepository {
  final AgentLocationRemote remote;

  const AgentLocationRepositoryImpl({required this.remote});

  @override
  Future<List<AgentInfoEntity>> getAgentList() async {
    final response = await remote.getAgentList();
    debugPrint('repo impl response length: ${response.data.length}');
    return response.data;
  }
}
