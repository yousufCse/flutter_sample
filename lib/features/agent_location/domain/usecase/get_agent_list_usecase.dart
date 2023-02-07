import 'package:flutter_sample/core/usecase/usecase.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';
import 'package:flutter_sample/features/agent_location/domain/repository/agent_location_repository.dart';

class GetAgentListUsecase extends Usecase<List<AgentInfoEntity>, NoParams> {
  final AgentLocationRepository repository;

  GetAgentListUsecase({required this.repository});

  @override
  Future<List<AgentInfoEntity>> call(NoParams params) async {
    return await repository.getAgentList();
  }
}
