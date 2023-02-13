part of 'location_search_cubit.dart';

class LocationSearchState {
  final String searchValue;
  final SearchState searchState;

  LocationSearchState({required this.searchValue, required this.searchState});

  factory LocationSearchState.initial() {
    return LocationSearchState(
      searchValue: '',
      searchState: SearchStateInitial(),
    );
  }

  LocationSearchState copyWith({
    String? searchValue,
    SearchState? searchState,
  }) {
    return LocationSearchState(
      searchValue: searchValue ?? this.searchValue,
      searchState: searchState ?? this.searchState,
    );
  }
}

abstract class SearchState extends Equatable {}

class SearchStateInitial extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchStateHasData extends SearchState {
  final List<AgentInfoEntity> list;
  SearchStateHasData(this.list);

  @override
  List<Object?> get props => [list];
}

class SearchStateNoData extends SearchState {
  @override
  List<Object?> get props => [];
}
