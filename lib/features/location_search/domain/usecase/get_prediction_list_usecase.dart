import 'package:flutter_sample/features/location_search/data/model/prediction.dart';
import 'package:flutter_sample/features/location_search/domain/repository/location_search_repository.dart';

class GetPredictionListUsecase {
  final LocationSearchRepository repository;

  const GetPredictionListUsecase({required this.repository});

  Future<List<Prediction>> call(String place) {
    return repository.getPredictionList(place);
  }
}
