import 'dart:convert';

import 'package:flutter_app_great_places/constants/google_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address = '',
  });

  static Future<String> findRemoteAddress(LatLng latLng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$googleApiKey';
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    if (json["results"] == "ZERO_RESULTS") {
      throw Exception('no results found');
    }
    return json["results"][0]['formatted_address'];
  }
}
