import 'package:flutter_sample/features/agent_place/data/model/place/place_details.dart';
import 'package:flutter_sample/features/agent_place/domain/repository/agent_place_repository.dart';

class GetPlaceDetailsUsecase {
  final AgentPlaceRepository repository;

  const GetPlaceDetailsUsecase({required this.repository});

  Future<PlaceDetails> call(String placeId) {
    return repository.getPlaceDetails(placeId);
  }
}
