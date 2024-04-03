import 'package:flutter_app_great_places/constants/google_api.dart';
import 'package:flutter_app_great_places/models/place_location.dart';

class PlaceLocationMap {
  final PlaceLocation placeLocation;
  final double zoom;
  final int sizeX;
  final int sizeY;

  const PlaceLocationMap({
    required this.placeLocation,
    this.zoom = 13,
    this.sizeX = 600,
    this.sizeY = 300,
  });

  String generateLocationPreviewImage() {
    return """https://maps.googleapis.com/maps/api/staticmap?center=${placeLocation.latitude},${placeLocation.longitude}&zoom=$zoom&size=${sizeX}x$sizeY&maptype=roadmap&markers=color:red%7Clabel:A%7C${placeLocation.latitude},${placeLocation.longitude}&key=$googleApiKey""";
  }
}
