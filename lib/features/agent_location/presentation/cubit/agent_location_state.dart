part of 'agent_location_cubit.dart';

class AgentLocationState extends Equatable {
  final LatLng? userCurrentLocation;
  final List<AgentInfoEntity> agentList;

  final List<Marker> markers;

  const AgentLocationState({
    this.userCurrentLocation,
    this.agentList = const [],
    this.markers = const <Marker>[],
  });

  AgentLocationState copyWith({
    LatLng? userCurrentLocation,
    List<Marker>? markers,
    List<AgentInfoEntity>? agentList,
  }) {
    return AgentLocationState(
      userCurrentLocation: userCurrentLocation ?? this.userCurrentLocation,
      markers: markers ?? this.markers,
      agentList: agentList ?? this.agentList,
    );
  }

  @override
  List<Object?> get props => [
        userCurrentLocation,
        markers,
        agentList,
      ];
}
