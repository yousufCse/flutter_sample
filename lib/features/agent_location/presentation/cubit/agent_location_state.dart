part of 'agent_location_cubit.dart';

class AgentLocationState extends Equatable {
  final String searchInput;
  final LatLng? userCurrentLocation;
  final List<AgentInfoEntity> agentList;

  final List<Marker> markers;

  const AgentLocationState({
    this.searchInput = '',
    this.userCurrentLocation,
    this.agentList = const [],
    this.markers = const <Marker>[],
  });

  AgentLocationState copyWith({
    String? searchValue,
    LatLng? userCurrentLocation,
    List<Marker>? markers,
    List<AgentInfoEntity>? agentList,
  }) {
    return AgentLocationState(
      searchInput: searchValue ?? searchInput,
      userCurrentLocation: userCurrentLocation ?? this.userCurrentLocation,
      markers: markers ?? this.markers,
      agentList: agentList ?? this.agentList,
    );
  }

  @override
  List<Object?> get props => [
        searchInput,
        userCurrentLocation,
        markers,
        agentList,
      ];
}
