import 'package:flutter_sample/features/agent_place/data/datasource/agent_place_remote.dart';
import 'package:flutter_sample/features/agent_place/data/model/place/place_details.dart';
import 'package:flutter_sample/features/agent_place/data/model/prediction.dart';
import 'package:flutter_sample/features/agent_place/domain/repository/agent_place_repository.dart';

class AgentPlaceRepositoryImpl implements AgentPlaceRepository {
  final AgentPlaceRemote remote;

  const AgentPlaceRepositoryImpl({required this.remote});

  @override
  Future<List<Prediction>> getPredictionList(String place) {
    return remote.fetchPredictionList(place);
  }

  @override
  Future<PlaceDetails> getPlaceDetails(String placeId) {
    return remote.fetchPlaceDetails(placeId);
  }
}
