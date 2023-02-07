import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/constants.dart';
import 'package:flutter_sample/core/location_service/location_service.dart';
import 'package:flutter_sample/core/utils/utils.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/marker_item/marker_item_tap_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'agent_location_state.dart';

class AgentLocationCubit extends Cubit<AgentLocationState> {
  final LocationService locationService;

  final MarkerItemTapCubit markerItemTapCubit;

  late Uint8List markerIcon;

  AgentLocationCubit({
    required this.locationService,
    required this.markerItemTapCubit,
  }) : super(const AgentLocationState()) {
    _setMarkerIcon();
  }

  void _setMarkerIcon() async {
    markerIcon = await getBytesFromAsset('assets/images/location-pin.png', 120);
  }

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

  List<AgentInfoEntity> get agentList => state.agentList;

  void removeMarker(String id) {
    final markerList = state.markers;
    markerList.removeWhere((marker) => marker.markerId.value == id);
    emit(state.copyWith(markers: markerList));
  }

  void addMarker(AgentInfoEntity data) async {
    final markerId = MarkerId(data.id);

    if (state.markers
        .where((element) => element.markerId.value == markerId.value)
        .isNotEmpty) {
      return;
    }

    final marker = Marker(
        markerId: markerId,
        position: LatLng(data.lat, data.lng),
        onTap: () {
          debugPrint('onMarkerTap: ${data.id}');
          markerItemTapCubit.onMarkerTap(data);
        },
        icon: BitmapDescriptor.fromBytes(markerIcon));

    final markers = [...state.markers, marker];
    emit(state.copyWith(markers: markers));
  }

  displayNearByMarkers(LatLng latLng, double defaultZoom, double currentZoom) {
    if (currentZoom < defaultZoom) {
      debugPrint('clear markers');
      clearMarkers();
      return;
    }

    for (int i = 0; i < agentList.length; i++) {
      final item = agentList[i];
      final itemLatLng = LatLng(item.lat, item.lng);

      final distance = calculateDistanceBetweenTwoPosition(latLng, itemLatLng);

      // around 1000 meters
      if (distance < 50000) {
        addMarker(item);
      } else {
        if (state.markers.length > 30 && distance > 50000) {
          removeMarker(item.id);
        }
      }
    }
  }

  void clearMarkers() {
    emit(state.copyWith(markers: []));
  }
}
