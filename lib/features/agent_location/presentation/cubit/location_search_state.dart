part of 'location_search_cubit.dart';

abstract class LocationSearchState {}

class LocationSearchInitial extends LocationSearchState {}

class LoationSearchHasData extends LocationSearchState {
  final List<AgentInfoEntity> src;
  LoationSearchHasData(this.src);
}

class LocationSearchNoData extends LocationSearchState {}
