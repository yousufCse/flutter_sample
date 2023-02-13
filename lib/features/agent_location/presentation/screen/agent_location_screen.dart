import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/debouncer.dart';
import 'package:flutter_sample/core/utils/map_util.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/agent_location_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/api/agent_location_api_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/location_search_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/marker_item/marker_item_tap_cubit.dart';
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
      ..getAgentList();

    locationSearchCubit = BlocProvider.of<LocationSearchCubit>(context);
    agentLocationCubit = BlocProvider.of<AgentLocationCubit>(context)
      ..getCurrentUserLocation();

    super.initState();
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
            ),
            BlocListener<MarkerItemTapCubit, MarkerItemTapState>(
              listener: (context, state) {
                debugPrint('onMarkerItem Listen: ${state.props}');

                if (state is MarkerItemTapFired) {
                  showBottomSheet(state.entity);
                }
              },
              child: Container(),
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
    final mapStyle = await getJsonFile('assets/json/map_style.json');
    mapController.setMapStyle(mapStyle);
  }

  void _onCameraMove(CameraPosition position) {
    currentZoom = position.zoom;

    debouncer.run(() {
      agentLocationCubit.displayNearByMarkers(
          LatLng(position.target.latitude, position.target.longitude),
          defaultZoom,
          currentZoom);
    });
  }

  _onChangeSearchValue(value) {
    agentLocationCubit.onChangedSearchValue(value);
    debouncer.run(() {
      locationSearchCubit.searchLocation(value, agentLocationCubit.agentList);
    });
  }

  void _onPressClearBtn() {
    FocusManager.instance.primaryFocus?.unfocus();
    agentLocationCubit.onChangedSearchValue('');
    locationSearchCubit.setToInitialState();
  }

  void _onListItemTap(AgentInfoEntity item) async {
    FocusManager.instance.primaryFocus?.unfocus();
    agentLocationCubit.onChangedSearchValue(item.address);
    locationSearchCubit.setToInitialState();
    agentLocationCubit.clearMarkers();

    await gotoPlace(LatLng(item.lat, item.lng));
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

  void showBottomSheet(AgentInfoEntity data) async {
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
}
