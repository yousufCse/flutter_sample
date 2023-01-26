import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/constants.dart';
import 'package:flutter_sample/core/debouncer.dart';
import 'package:flutter_sample/core/service/geo_locator_service.dart';
import 'package:flutter_sample/features/agent_place/data/model/place/place_details.dart';
import 'package:flutter_sample/features/agent_place/data/model/prediction.dart';
import 'package:flutter_sample/features/agent_place/presentation/cubit/place_details_api_cubit.dart';
import 'package:flutter_sample/features/agent_place/presentation/cubit/prediction_api_cubit.dart';
import 'package:flutter_sample/features/agent_place/presentation/widgets/prediction_item.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AgentPlaceScreen extends StatefulWidget {
  const AgentPlaceScreen({super.key});

  @override
  State<AgentPlaceScreen> createState() => _AgentPlaceScreenState();
}

class _AgentPlaceScreenState extends State<AgentPlaceScreen> {
  final LatLng fixedLocation = const LatLng(23.7676351, 90.3651452);

  final TextEditingController searchFieldController = TextEditingController();

  late GoogleMapController mapController;
  late Position currentPositon;
  // late PlacesService placesService;

  final markers = <Marker>{};

  late PlaceDetailsApiCubit placeDetailsApiCubit;
  late PredictionApiCubit predictionApiCubit;

  Debouncer debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    // setCurrentLocation();

    placeDetailsApiCubit = BlocProvider.of<PlaceDetailsApiCubit>(context);
    predictionApiCubit = BlocProvider.of<PredictionApiCubit>(context);

    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location App'), centerTitle: true),
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
    List<Prediction> predictionList = [];

    final predictionState = context.watch<PredictionApiCubit>().state;
    if (predictionState is PredictionApiSuccess) {
      predictionList = predictionState.list;
    }

    return Column(
      children: [
        Container(
          height: 40,
          margin:
              const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
          padding: const EdgeInsets.only(left: 10, right: 0),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
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
                  ? IconButton(onPressed: () {}, icon: const Icon(Icons.search))
                  : IconButton(
                      onPressed: onPressClearBtn, icon: const Icon(Icons.clear))
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(zoom: 12, target: fixedLocation),
                markers: markers,
                myLocationEnabled: true,
                onMapCreated: onMapCreated,
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

  void onMapCreated(controller) {
    mapController = controller;

    for (int i = 0; i < listOfLatLng.length; i++) {
      addMarker('ID_${i + 1}', listOfLatLng[i]);
    }

    setState(() {});
  }

  setCurrentLocation() async {
    currentPositon = await GeoLocatorService().getCurrentLocation();

    setState(() {});
  }

  Future<void> gotoPlace(PlaceDetails place) async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            place.geometry.location.lat,
            place.geometry.location.lng,
          ),
          zoom: 17,
        ),
      ),
    );
  }

  void moveCameraPosition(LatLng latLng) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 12)),
    );
  }

  addMarker(String markerIdString, LatLng position) {
    final markerId = MarkerId(markerIdString);

    final marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: const InfoWindow(title: 'Title', snippet: 'Address'),
    );

    markers.add(marker);
  }
}

const List<LatLng> listOfLatLng = [
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
];
