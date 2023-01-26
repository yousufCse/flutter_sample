import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/constants.dart';
import 'package:flutter_sample/core/debouncer.dart';
import 'package:flutter_sample/features/agent_place/data/model/place/place_details.dart';
import 'package:flutter_sample/features/agent_place/data/model/prediction.dart';
import 'package:flutter_sample/features/agent_place/presentation/cubit/place_details_api_cubit.dart';
import 'package:flutter_sample/features/agent_place/presentation/cubit/prediction_api_cubit.dart';
import 'package:flutter_sample/features/search_location/presentation/widgets/prediction_item.dart';
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
  LatLng? userCurrentLocation;

  final markers = <Marker>{};

  late PlaceDetailsApiCubit placeDetailsApiCubit;
  late PredictionApiCubit predictionApiCubit;

  Debouncer debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    placeDetailsApiCubit = BlocProvider.of<PlaceDetailsApiCubit>(context);
    predictionApiCubit = BlocProvider.of<PredictionApiCubit>(context);

    getCurrentLocation();
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
    debugPrint('build body');
    List<Prediction> predictionList = [];

    final predictionState = context.watch<PredictionApiCubit>().state;
    if (predictionState is PredictionApiSuccess) {
      predictionList = predictionState.list;
    }

    return Column(
      children: [
        Container(
          // height: 45,
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
                  initialCameraPosition:
                      CameraPosition(zoom: 14, target: userCurrentLocation!),
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

  void onMapCreated(controller) async {
    mapController = controller;

    for (int i = 0; i < listOfLatLng.length; i++) {
      addMarker('ID_${i + 1}', listOfLatLng[i]);
    }
    debugPrint('id: ${listOfLatLng.length}');

    setState(() {});
  }

  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    debugPrint('Permisson: ${permission.name}');

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double lat = position.latitude;
      double lng = position.longitude;

      userCurrentLocation = LatLng(lat, lng);
      setState(() {});
    } else {
      userCurrentLocation = Constants.latLngDhaka;
      setState(() {});
    }
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

  void addMarker(String markerIdString, LatLng position) {
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
  LatLng(23.7566665, 90.3655222),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4565146, 91.964564),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),

  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),

  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),

  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
  LatLng(22.8170646, 89.556799),
  LatLng(21.4509227, 91.9668569),
  LatLng(23.7752681, 90.400771),
  LatLng(24.5800093, 88.2640644), // nawabganj
  LatLng(24.5879036, 88.275329), // nawabganj
  LatLng(24.5836439, 88.2659779), // nawabganj
  LatLng(23.7558982, 90.3629074),
  LatLng(23.7505693, 90.3730078),
  LatLng(24.3824967, 88.6037882),
];
