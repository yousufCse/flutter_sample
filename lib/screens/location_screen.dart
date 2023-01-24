import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LatLng currentLocation = const LatLng(23.7676351, 90.3651452);

  final TextEditingController searchFieldController = TextEditingController();

  late CameraPosition cameraPosition;
  late GoogleMapController mapController;

  final markers = <Marker>{};

  @override
  void initState() {
    cameraPosition = CameraPosition(target: currentLocation, zoom: 15);

    super.initState();
  }

  onSearchPress() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location App'), centerTitle: true),
      body: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchFieldController,
                    decoration: const InputDecoration.collapsed(
                        hintText: 'Search Place'),
                  ),
                ),
                IconButton(
                    onPressed: onSearchPress, icon: const Icon(Icons.search))
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: cameraPosition,
              markers: markers,
              onMapCreated: (controller) {
                mapController = controller;
                addMarker('1', currentLocation);
                addMarker('2', const LatLng(23.7558982, 90.3629074));
                addMarker('3', const LatLng(23.7505693, 90.3730078));
              },
            ),
          )
        ],
      ),
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
