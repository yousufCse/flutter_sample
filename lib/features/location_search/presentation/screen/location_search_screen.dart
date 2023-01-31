import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/constants.dart';
import 'package:flutter_sample/core/debouncer.dart';
import 'package:flutter_sample/core/utils/utils.dart';
import 'package:flutter_sample/features/location_search/data/model/place/place_details.dart';
import 'package:flutter_sample/features/location_search/data/model/prediction.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/place_details_api_cubit.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/prediction_api_cubit.dart';
import 'package:flutter_sample/features/location_search/presentation/screen/agent_info.dart';
import 'package:flutter_sample/features/location_search/presentation/widgets/agent_info_bottom_sheet.dart';
import 'package:flutter_sample/features/location_search/presentation/widgets/prediction_item.dart';
import 'package:geolocator/geolocator.dart';
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

  Debouncer debouncer = Debouncer(milliseconds: 500);

  late Uint8List markerIcon;

  List<AgentInfo> agentInfoList = [];

  @override
  void initState() {
    placeDetailsApiCubit = BlocProvider.of<PlaceDetailsApiCubit>(context);
    predictionApiCubit = BlocProvider.of<PredictionApiCubit>(context);
    agentInfoList = generateAgentList();

    _getCurrentLocation();

    setMarkerIcon();

    super.initState();
  }

  void setMarkerIcon() async {
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
    debugPrint('onChange called: $value');

    debouncer.run(() {
      predictionApiCubit.getPredictinList(value.trim());

      debugPrint('Debouncer run called.');
    });
  }

  void onItemTap(Prediction item) {
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
        ],
        child: _body(),
      ),
    );
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
    List<Prediction> predictionList = [];

    final predictionState = context.watch<PredictionApiCubit>().state;

    if (predictionState is PredictionApiSuccess) {
      predictionList = predictionState.list;
    }

    return Column(
      children: [
        Container(
          margin:
              const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 10),
          padding: const EdgeInsets.only(left: 10, right: 0),
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(25)),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchFieldController,
                  onChanged: onChangeSearchField,
                  decoration: const InputDecoration(
                      hintText: Constants.searchHint, border: InputBorder.none),
                ),
              ),
              searchFieldController.text.trim().isEmpty
                  ? const IconButton(onPressed: null, icon: Icon(Icons.search))
                  : IconButton(
                      onPressed: onPressClearBtn, icon: const Icon(Icons.clear))
            ],
          ),
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
              if (predictionList.isNotEmpty)
                ListView.builder(
                    itemCount: predictionList.length,
                    itemBuilder: (context, index) {
                      final item = predictionList[index];
                      return PredictionItem(
                          prediction: item, onItemTap: () => onItemTap(item));
                    }),
            ],
          ),
        ),
      ],
    );
  }

  void _onCameraMove(CameraPosition position) {
    currentZoom = position.zoom;
    debugPrint('current zoom lavel: $currentZoom');

    debouncer.run(() {
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
      return;
    }

    var count = 0;
    for (int i = 0; i < agentInfoList.length; i++) {
      final item = agentInfoList[i];
      final itemLatLng = LatLng(item.lat, item.lng);

      final distance = calculateDistanceBetweenTwoPosition(latLng, itemLatLng);

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
          zoom: currentZoom,
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

  List<AgentInfo> generateAgentList() {
    List<AgentInfo> list = [];

    for (int i = 0; i < 2000; i++) {
      final id = '${i + 1}';

      var random = Random();

      final mainLat = 23.7275664 + (random.nextInt(2000) / 10000);
      final mainLng = 90.2990201 + (random.nextInt(2000) / 10000);

      list.add(AgentInfo(
          id: id,
          name: 'Agent Name $id',
          details: 'Agent Details $id',
          address: '#$id House, Road A, Location, Dhaka',
          hyperlink: 'https://jsonplaceholder.typicode.com/todos/$id',
          lat: mainLat,
          lng: mainLng));
    }

    return list;
  }
}
