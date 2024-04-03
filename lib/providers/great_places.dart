import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_great_places/models/place.dart';
import 'package:flutter_app_great_places/models/place_location.dart';
import 'package:flutter_app_great_places/repositories/places_sqlite.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  loadPlaces() async {
    final placesList = await PlacesSqlite.getData();
    _items = placesList.map((place) {
      return Place(
        id: place['id'] as String,
        title: place['title'] as String,
        image: File(place['image'] as String),
        location: PlaceLocation(
          latitude: place['location_lat'] as double,
          longitude: place['location_lng'] as double,
          address: place['location_address'] as String,
        ),
      );
    }).toList();
    notifyListeners();
  }

  /* No método Get, é importante sempre retornar um clone(...) da lista. */

  /* Motivo de não retornar a referência: Evitar a manipulação da mesma 
  sem que os Providers fiquem sabendo! */

  List<Place> get items => [..._items];

  int get itemsCount => _items.length;

  Place itemByIndex(int index) {
    return _items[index];
  }

  Future<bool> addPlaces(String place, File image, LatLng latlng) async {
    bool itsCorrect = false;
    String address = "";

    try {
      address = await PlaceLocation.findRemoteAddress(latlng);
    } catch (ex) {
      return itsCorrect;
    }

    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: place,
      location: PlaceLocation(
        latitude: latlng.latitude,
        longitude: latlng.longitude,
        address: address,
      ),
      image: image,
    );

    _items.add(newPlace);

    await PlacesSqlite.insert({
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'location_address': newPlace.location.address,
      'location_lat': newPlace.location.latitude,
      'location_lng': newPlace.location.longitude,
    });
    notifyListeners();
    itsCorrect = true;

    return itsCorrect;
  }
}
