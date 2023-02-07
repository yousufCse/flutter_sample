import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/constants.dart';
import 'package:flutter_sample/core/location_service/location_service.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'agent_location_state.dart';

class AgentLocationCubit extends Cubit<AgentLocationState> {
  final LocationService locationService;

  AgentLocationCubit({required this.locationService})
      : super(const AgentLocationState());

  void changeText(String value) {
    emit(state.copyWith(searchValue: value));
  }

  void getCurrentUserLocation() async {
    try {
      final LatLng currentLocaton = await locationService.getCurrentLocation();
      emit(state.copyWith(userCurrentLocation: currentLocaton));
    } catch (e) {
      emit(state.copyWith(userCurrentLocation: Constants.latLngDhaka));
    }
  }

  void addAgentList(List<AgentInfoEntity> agentList) {
    emit(state.copyWith(agentList: agentList));
  }

  void addMarkers(List<Marker> markers) {
    emit(state.copyWith(markers: markers));
  }

  List<AgentInfoEntity> get agentList => state.agentList;

  void addMarker(Marker marker) {
    if (state.markers
        .where((element) => element.markerId.value == marker.markerId.value)
        .isNotEmpty) {
      return;
    }

    final markers = [...state.markers, marker];
    emit(state.copyWith(markers: markers));
  }

  void removeMarker(String id) {
    final markerList = state.markers;
    markerList.removeWhere((marker) => marker.markerId.value == id);
    emit(state.copyWith(markers: markerList));
  }

  void clearMarkers() {
    emit(state.copyWith(markers: []));
  }
}
