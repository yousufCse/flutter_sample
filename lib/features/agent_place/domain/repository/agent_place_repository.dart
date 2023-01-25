import 'package:flutter_sample/features/agent_place/data/model/place/place_details.dart';
import 'package:flutter_sample/features/agent_place/data/model/prediction.dart';

abstract class AgentPlaceRepository {
  Future<List<Prediction>> getPredictionList(String place);
  Future<PlaceDetails> getPlaceDetails(String placeId);
}
