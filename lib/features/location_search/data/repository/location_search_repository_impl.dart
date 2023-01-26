import 'package:flutter_sample/features/location_search/data/datasource/location_search_remote.dart';
import 'package:flutter_sample/features/location_search/data/model/place/place_details.dart';
import 'package:flutter_sample/features/location_search/data/model/prediction.dart';
import 'package:flutter_sample/features/location_search/domain/repository/location_search_repository.dart';

class LocationSearchRepositoryImpl implements LocationSearchRepository {
  final LocationSearchRemote remote;

  const LocationSearchRepositoryImpl({required this.remote});

  @override
  Future<List<Prediction>> getPredictionList(String place) {
    return remote.fetchPredictionList(place);
  }

  @override
  Future<PlaceDetails> getPlaceDetails(String placeId) {
    return remote.fetchPlaceDetails(placeId);
  }
}
