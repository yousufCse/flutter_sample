import 'package:flutter_sample/features/location_search/data/model/place/place_details.dart';
import 'package:flutter_sample/features/location_search/domain/repository/location_search_repository.dart';

class GetPlaceDetailsUsecase {
  final LocationSearchRepository repository;

  const GetPlaceDetailsUsecase({required this.repository});

  Future<PlaceDetails> call(String placeId) {
    return repository.getPlaceDetails(placeId);
  }
}
