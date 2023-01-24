import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sample/core/constants.dart';
import 'package:flutter_sample/core/service/geo_locator_service.dart';
import 'package:flutter_sample/core/service/places_service.dart';
import 'package:flutter_sample/screens/place.dart';
import 'package:flutter_sample/screens/place_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LatLng fixedLocation = const LatLng(23.7676351, 90.3651452);

  final TextEditingController searchFieldController = TextEditingController();
  final Client client = Client();

  late GoogleMapController mapController;
  late Position currentPositon;
  late PlacesService placesService;

  final markers = <Marker>{};

  bool isLoading = false;
  List<PlaceModel> list = [];

  @override
  void initState() {
    placesService = PlacesService(client: client);
    setCurrentLocation();

    super.initState();
  }

  onSearchPress() {
    searchPlaces(searchFieldController.text.trim());
  }

  onItemTap(String placeId) {
    getLocationByPlaceId(placeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location App'), centerTitle: true),
      body: Column(
        children: [
          Container(
            height: 40,
            margin:
                const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            padding: const EdgeInsets.only(left: 10, right: 0),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchFieldController,
                    decoration: const InputDecoration(
                        hintText: Constants.searchHint,
                        border: InputBorder.none),
                  ),
                ),
                IconButton(
                    onPressed: onSearchPress, icon: const Icon(Icons.search))
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => onItemTap('Put place Id here'),
                      child: Text('Item ${index + 1}'),
                    ),
                  ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  zoom: 14, target: fixedLocation
                  // LatLng(currentPositon.latitude, currentPositon.latitude),
                  ),
              markers: markers,
              myLocationEnabled: true,
              onMapCreated: onMapCreated,
            ),
          ),
        ],
      ),
    );
  }

  void onMapCreated(controller) {
    mapController = controller;
    addMarker('2', const LatLng(23.7558982, 90.3629074));
    addMarker('3', const LatLng(23.7505693, 90.3730078));
  }

  setCurrentLocation() async {
    currentPositon = await GeoLocatorService().getCurrentLocation();

    setState(() {});
  }

  Future<void> _gotoPlace(Place place) async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            place.geometry.location.lat,
            place.geometry.location.lng,
          ),
          zoom: 16,
        ),
      ),
    );
  }

  getLocationByPlaceId(String placeId) async {
    final selectedPlace = await placesService.getPlace(placeId);

    await _gotoPlace(selectedPlace);
  }

  searchPlaces(String text) async {
    setState(() {
      isLoading = true;
    });

    list = await PlacesService(client: client).getAutoComplete(text);
    setState(() {
      isLoading = false;
    });

    moveCameraPosition(const LatLng(23.6251919, 90.5118054));
  }

  moveCameraPosition(LatLng latLng) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)),
    );
  }

  addMarker(String markerIdString, LatLng position) {
    final markerId = MarkerId(markerIdString);

    final marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: const InfoWindow(title: 'Title', snippet: 'Address'),
    );

    setState(() {
      markers.add(marker);
    });
  }
}
