import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/debouncer.dart';
import 'package:flutter_sample/core/utils/utils.dart';
import 'package:flutter_sample/features/location_search/data/model/place/place_details.dart';
import 'package:flutter_sample/features/location_search/data/model/prediction.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/agent_info_api_cubit.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/place_details_api_cubit.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/prediction_api_cubit.dart';
import 'package:flutter_sample/features/location_search/presentation/screen/agent_info.dart';
import 'package:flutter_sample/features/location_search/presentation/widgets/agent_info_bottom_sheet.dart';
import 'package:flutter_sample/features/location_search/presentation/widgets/location_search_field.dart';
import 'package:flutter_sample/features/location_search/presentation/widgets/prediction_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController searchFieldController = TextEditingController();

  late GoogleMapController mapController;
  final double defaultZoom = 13.0;
  double currentZoom = 0;
  LatLng? userCurrentLocation;

  final Set<Marker> markers = <Marker>{};

  late PlaceDetailsApiCubit placeDetailsApiCubit;
  late PredictionApiCubit predictionApiCubit;
  late AgentInfoApiCubit agenInfoApiCubit;

  Debouncer debouncer = Debouncer(milliseconds: 500);

  late Uint8List markerIcon;

  List<AgentInfo> agentInfoList = [];

  @override
  void initState() {
    placeDetailsApiCubit = BlocProvider.of<PlaceDetailsApiCubit>(context);
    predictionApiCubit = BlocProvider.of<PredictionApiCubit>(context);
    agenInfoApiCubit = BlocProvider.of<AgentInfoApiCubit>(context)
      ..getAgentInfos();

    _getCurrentLocation();

    _setMarkerIcon();

    super.initState();
  }

  void _setMarkerIcon() async {
    markerIcon = await getBytesFromAsset('assets/images/location-pin.png', 120);
  }

  _getCurrentLocation() async {
    userCurrentLocation = await getCurrentLocation();
    setState(() {});
  }

  void onPressClearBtn() {
    predictionApiCubit.removePredictionList();
    searchFieldController.text = '';
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onChangeSearchField(String value) {
    debouncer.run(() {
      predictionApiCubit.getPredictinList(value.trim());
    });
  }

  void onListItemTap(Prediction item) {
    FocusManager.instance.primaryFocus?.unfocus();
    placeDetailsApiCubit.getPlaceDetails(item.placeId);
    searchFieldController.text = item.description;
    markers.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Location App',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PlaceDetailsApiCubit, PlaceDetailsApiState>(
            listener: _listenToPlaceDetailsApi,
          ),
          BlocListener<PredictionApiCubit, PredictionApiState>(
            listener: _listenToPredictionApi,
          ),
          BlocListener<AgentInfoApiCubit, AgentInfoApiState>(
            listener: _listenToAgentInfoApi,
          ),
        ],
        child: _body(),
      ),
    );
  }

  void _listenToAgentInfoApi(context, state) {
    if (state is AgentInfoApiSuccess) {
      agentInfoList = state.src;
      setState(() {});
    }
  }

  void _listenToPredictionApi(context, state) {}

  void _listenToPlaceDetailsApi(context, state) async {
    if (state is PlaceDetailsApiSuccess) {
      await gotoPlace(state.place);
      predictionApiCubit.removePredictionList();
    }
  }

  Widget _body() {
    debugPrint('build body === markers: ${markers.length}');

    return Column(
      children: [
        LocationSearchField(
          controller: searchFieldController,
          onChanged: onChangeSearchField,
          onTapClear: onPressClearBtn,
        ),
        Expanded(
          child: Stack(
            children: [
              if (userCurrentLocation == null)
                const CircularProgressIndicator(),
              if (userCurrentLocation != null)
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      zoom: defaultZoom, target: userCurrentLocation!),
                  markers: markers,
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                ),
              PredictionList(onListItemTap: onListItemTap)
            ],
          ),
        ),
      ],
    );
  }

  void _onCameraMove(CameraPosition position) {
    currentZoom = position.zoom;

    debouncer.run(() {
      debugPrint('current zoom lavel: $currentZoom');
      final currentLatLng =
          LatLng(position.target.latitude, position.target.longitude);

      _loadNearbyMarker(currentLatLng);
    });
  }

  void _onMapCreated(controller) async {
    mapController = controller;

    final mapStyle = await getJsonFile('assets/jsons/map_style.json');

    mapController.setMapStyle(mapStyle);
  }

  _loadNearbyMarker(LatLng latLng) {
    if (currentZoom < defaultZoom) {
      debugPrint('clear markers');
      markers.clear();
      setState(() {});
      return;
    }

    var count = 0;
    for (int i = 0; i < agentInfoList.length; i++) {
      final item = agentInfoList[i];
      final itemLatLng = LatLng(item.lat, item.lng);

      final distance = calculateDistanceBetweenTwoPosition(latLng, itemLatLng);

      // around 1000 meters
      if (distance < 1000) {
        addMarker(item);

        count++;
      } else {
        if (markers.length > 30 && distance > 3000) {
          removeMarker(item.id);
        }
      }
    }
    setState(() {});

    debugPrint('NearByMarkerCount: $count');
  }

  Future<void> gotoPlace(PlaceDetails place) async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            place.geometry.location.lat,
            place.geometry.location.lng,
          ),
          zoom: defaultZoom,
        ),
      ),
    );
  }

  void onMarkerTap(AgentInfo data) async {
    debugPrint('marker on tap ress');

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return AgentInfoBottomSheet(
          data: data,
        );
      },
    );
  }

  void removeMarker(String id) {
    markers.removeWhere((marker) => marker.markerId.value == id);
  }

  void addMarker(AgentInfo data) async {
    if (markers
        .where((element) => element.markerId.value == data.id)
        .isNotEmpty) {
      return;
    }

    final markerId = MarkerId(data.id);

    final marker = Marker(
      markerId: markerId,
      position: LatLng(data.lat, data.lng),
      onTap: () => onMarkerTap(data),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    );

    markers.add(marker);
  }
}
