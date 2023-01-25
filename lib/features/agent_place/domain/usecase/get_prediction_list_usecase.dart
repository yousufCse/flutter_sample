import 'package:flutter_sample/features/agent_place/data/model/prediction.dart';
import 'package:flutter_sample/features/agent_place/domain/repository/agent_place_repository.dart';

class GetPredictionListUsecase {
  final AgentPlaceRepository repository;

  const GetPredictionListUsecase({required this.repository});

  Future<List<Prediction>> call(String place) {
    return repository.getPredictionList(place);
  }
}
