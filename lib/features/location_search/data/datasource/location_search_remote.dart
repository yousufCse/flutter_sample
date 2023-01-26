import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sample/core/constants.dart';
import 'package:flutter_sample/features/agent_place/data/model/place/place_details.dart';
import 'package:flutter_sample/features/agent_place/data/model/prediction.dart';
import 'package:http/http.dart';

abstract class LocationSearchRemote {
  Future<List<Prediction>> fetchPredictionList(String place);
  Future<PlaceDetails> fetchPlaceDetails(String placeId);
}

class LocationSearchRemoteImpl implements LocationSearchRemote {
  final Client client;

  const LocationSearchRemoteImpl({required this.client});

  @override
  Future<List<Prediction>> fetchPredictionList(String place) async {
    // &language=bn
    // &types=(cities)
    // dhaka lat lng 23.7807777,90.3492415

    var url =
        '${Constants.baseUrl}/place/autocomplete/json?input=$place&location=23.7807777,90.3492415&radius=500&key=${Constants.mapApiKey}';

    final response = await client.get(Uri.parse(url));
    var jsonString = json.decode(response.body);

    debugPrint('response: ${response.body}');

    var jsonResult = jsonString['predictions'] as List;
    return jsonResult.map((e) => Prediction.fromJson(e)).toList();
  }

  @override
  Future<PlaceDetails> fetchPlaceDetails(String placeId) async {
    var url =
        '${Constants.baseUrl}/place/details/json?place_id=$placeId&key=${Constants.mapApiKey}';

    final response = await client.get(Uri.parse(url));
    final jsonString = json.decode(response.body);

    debugPrint('response: ${response.body}');
    final jsonResult = jsonString['result'];
    return PlaceDetails.formJson(jsonResult);
  }
}
