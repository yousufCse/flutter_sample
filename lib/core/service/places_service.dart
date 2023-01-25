import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sample/core/constants.dart';
import 'package:flutter_sample/screens/place.dart';
import 'package:flutter_sample/screens/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class PlacesService {
  final Client client;

  PlacesService({required this.client});

  Future<List<PlaceModel>> getAutoComplete(String text) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&types=(cities)&key=${Constants.mapApiKey}';

    final response = await client.get(Uri.parse(url));

    var jsonString = json.decode(response.body);

    debugPrint('response: ${response.body}');

    var jsonResult = jsonString['predictions'] as List;

    return jsonResult.map((e) => PlaceModel.fromJson(e)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Constants.mapApiKey}';

    final response = await client.get(Uri.parse(url));

    final jsonString = json.decode(response.body);

    debugPrint('response: ${response.body}');

    final jsonResult = jsonString['result'];

    return Place.formJson(jsonResult);
  }
}
