import 'package:flutter_sample/features/location_search/data/model/place/place_details.dart';
import 'package:flutter_sample/features/location_search/data/model/prediction.dart';

abstract class LocationSearchRepository {
  Future<List<Prediction>> getPredictionList(String place);
  Future<PlaceDetails> getPlaceDetails(String placeId);
}
