import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';

abstract class AgentLocationRepository {
  Future<List<AgentInfoEntity>> getAgentList();
}
