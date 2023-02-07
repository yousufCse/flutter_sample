import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/debouncer.dart';
import 'package:flutter_sample/core/utils/utils.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/agent_location_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/api/agent_location_api_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/location_search_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/widgets/agent_info_bottom_sheet.dart';
import 'package:flutter_sample/features/agent_location/presentation/widgets/location_search_list.dart';
import 'package:flutter_sample/features/agent_location/presentation/widgets/location_search_textfield.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AgentLocationScreen extends StatefulWidget {
  const AgentLocationScreen({super.key});

  @override
  State<AgentLocationScreen> createState() => _AgentLocationScreenState();
}

class _AgentLocationScreenState extends State<AgentLocationScreen> {
  late AgentLocationApiCubit agenInfoApiCubit;
  late LocationSearchCubit locationSearchCubit;
  late AgentLocationCubit agentLocationCubit;

  late GoogleMapController mapController;
  late Uint8List markerIcon;

  final Debouncer debouncer = Debouncer(milliseconds: 500);
  final double defaultZoom = 13.0;
  double currentZoom = 0;

  @override
  void initState() {
    agenInfoApiCubit = BlocProvider.of<AgentLocationApiCubit>(context)
      ..getAgentInfos();

    locationSearchCubit = BlocProvider.of<LocationSearchCubit>(context);
    agentLocationCubit = BlocProvider.of<AgentLocationCubit>(context)
      ..getCurrentUserLocation();

    _setMarkerIcon();

    super.initState();
  }

  void _setMarkerIcon() async {
    markerIcon = await getBytesFromAsset('assets/images/location-pin.png', 120);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _appbar(),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AgentLocationApiCubit, AgentLocationApiState>(
              listener: _listenToAgentInfoApi,
            )
          ],
          child: _body(),
        ));
  }

  PreferredSizeWidget _appbar() {
    return AppBar(
        elevation: 0,
        title:
            const Text('Location App', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white);
  }

  Widget _body() {
    final state = context.watch<AgentLocationCubit>().state;
    debugPrint('build body === markers: ${state.markers.length}');

    return Column(
      children: [
        LocationSearchTextField(
          onChanged: _onChangeSearchValue,
          onTapClear: _onPressClearBtn,
        ),
        Expanded(
            child: Stack(
          children: [
            if (state.userCurrentLocation == null || state.agentList.isEmpty)
              const CircularProgressIndicator(),
            if (state.userCurrentLocation != null && state.agentList.isNotEmpty)
              GoogleMap(
                  initialCameraPosition: CameraPosition(
                      zoom: defaultZoom, target: state.userCurrentLocation!),
                  markers: Set.of(state.markers),
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove),
            LocationSearchList(onListItemTap: _onListItemTap)
          ],
        ))
      ],
    );
  }

  void _listenToAgentInfoApi(context, state) {
    if (state is AgentLocationApiSuccess) {
      agentLocationCubit.addAgentList(state.src);
    }
  }

  void _onMapCreated(controller) async {
    mapController = controller;

    final mapStyle = await getJsonFile('assets/jsons/map_style.json');

    mapController.setMapStyle(mapStyle);
  }

  void _onCameraMove(CameraPosition position) {
    currentZoom = position.zoom;

    debouncer.run(() {
      _loadNearbyMarker(
          LatLng(position.target.latitude, position.target.longitude));
    });
  }

  _onChangeSearchValue(value) {
    agentLocationCubit.changeText(value);
    debouncer.run(() {
      locationSearchCubit.searchLocation(value, agentLocationCubit.agentList);
    });
  }

  void _onPressClearBtn() {
    FocusManager.instance.primaryFocus?.unfocus();
    agentLocationCubit.changeText('');
    locationSearchCubit.setToInitialState();
  }

  void _onListItemTap(AgentInfoEntity item) async {
    FocusManager.instance.primaryFocus?.unfocus();
    agentLocationCubit.changeText(item.address);
    locationSearchCubit.setToInitialState();
    agentLocationCubit.clearMarkers();

    await gotoPlace(LatLng(item.lat, item.lng));
  }

  _loadNearbyMarker(LatLng latLng) {
    // if (currentZoom < defaultZoom) {
    //   debugPrint('clear markers');
    //   agentLocationCubit.clearMarkers();
    //   return;
    // }

    var count = 0;
    for (int i = 0; i < agentLocationCubit.agentList.length; i++) {
      final item = agentLocationCubit.agentList[i];
      final itemLatLng = LatLng(item.lat, item.lng);

      final distance = calculateDistanceBetweenTwoPosition(latLng, itemLatLng);

      // around 1000 meters
      if (distance < 50000) {
        _addMarker(item);

        count++;
      } else {
        if (agentLocationCubit.state.markers.length > 30 && distance > 100000) {
          agentLocationCubit.removeMarker(item.id);
        }
      }
    }

    debugPrint('NearByMarkerCount: $count');
  }

  Future<void> gotoPlace(LatLng location) async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: defaultZoom,
        ),
      ),
    );
  }

  void onMarkerTap(AgentInfoEntity data) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return AgentInfoBottomSheet(data: data);
      },
    );
  }

  void _addMarker(AgentInfoEntity data) async {
    final markerId = MarkerId(data.id);

    final marker = Marker(
      markerId: markerId,
      position: LatLng(data.lat, data.lng),
      onTap: () => onMarkerTap(data),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    );

    agentLocationCubit.addMarker(marker);
  }
}
