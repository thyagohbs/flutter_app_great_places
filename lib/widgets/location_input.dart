import 'package:flutter/material.dart';
import 'package:flutter_app_great_places/messages/snackbar.dart';
import 'package:flutter_app_great_places/models/place_location.dart';
import 'package:flutter_app_great_places/models/place_location_map.dart';
import 'package:flutter_app_great_places/screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final void Function(LatLng? latLng) selectPosition;
  const LocationInput({required this.selectPosition, super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  LatLng? _latLngSelected;

  _LocationInputState() {
    _getCurrentUserLocation();
  }

  void _getCurrentUserLocation() {
    try {
      Location().getLocation().then((location) {
        if (location.latitude == null || location.longitude == null) {
          return;
        }
        final PlaceLocationMap placeLocationMap = PlaceLocationMap(
          placeLocation: PlaceLocation(
            latitude: location.latitude!,
            longitude: location.longitude!,
          ),
        );

        setState(() {
          _previewImageUrl = placeLocationMap.generateLocationPreviewImage();
        });
      });
    } catch (ex) {
      SnackCustom.snack(
          context: context,
          message: 'Não é possível obter a localização sem permissão!');
    }
  }

  Future<void> _selectOnMap() async {
    Widget builder = _latLngSelected != null
        ? MapScreen(
            inititalPlacelocationMap: PlaceLocationMap(
              placeLocation: PlaceLocation(
                latitude: _latLngSelected!.latitude,
                longitude: _latLngSelected!.longitude,
              ),
            ),
          )
        : MapScreen();

    final LatLng? latLngSelected = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => builder,
      ),
    );

    if (latLngSelected == null) {
      return;
    } else {
      widget.selectPosition(latLngSelected);
      setState(() {
        _latLngSelected = latLngSelected;
        final PlaceLocationMap placeLocationMap = PlaceLocationMap(
          placeLocation: PlaceLocation(
            latitude: latLngSelected.latitude,
            longitude: latLngSelected.longitude,
          ),
        );
        _previewImageUrl = placeLocationMap.generateLocationPreviewImage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.red),
          ),
          child: _previewImageUrl == null
              ? const CircularProgressIndicator()
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _getCurrentUserLocation,
              icon: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 10),
                  Text('Localização Atual'),
                ],
              ),
            ),
            IconButton(
              onPressed: _selectOnMap,
              icon: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map),
                  SizedBox(width: 10),
                  Text('Selecione no mapa'),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
