import 'dart:io';

import 'package:flutter_app_great_places/models/place_location.dart';

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  Place({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
  });

  static Place init() {
    return Place(
      id: '',
      title: '',
      location: const PlaceLocation(latitude: 0, longitude: 0, address: ''),
      image: File(''),
    );
  }
}
