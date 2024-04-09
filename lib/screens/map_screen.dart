import 'package:flutter/material.dart';
import 'package:flutter_app_great_places/models/place_location.dart';
import 'package:flutter_app_great_places/models/place_location_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocationMap inititalPlacelocationMap;
  bool isReadonly = false;

  MapScreen({
    this.inititalPlacelocationMap = const PlaceLocationMap(
      placeLocation: PlaceLocation(
        latitude: 37.422131, // Localização da Sede do google
        longitude: -122.084801, // Localização da Sede do google
      ),
    ),
    this.isReadonly = false,
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _latLng;
  /* Set = é um tipo que não aceita repetição */
  Set<Marker> positions = {};

  @override
  void initState() {
    super.initState();
    _selectPosition(
      LatLng(
        widget.inititalPlacelocationMap.placeLocation.latitude,
        widget.inititalPlacelocationMap.placeLocation.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione a posição'),
        actions: [
          if (!widget.isReadonly)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                onPressed: _finishPosition,
                icon: const Icon(Icons.check),
              ),
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.inititalPlacelocationMap.placeLocation.latitude,
            widget.inititalPlacelocationMap.placeLocation.longitude,
          ),
          zoom: widget.inititalPlacelocationMap.zoom,
        ),
        onTap: _selectPosition,
        markers: positions,
      ),
    );
  }

  void _selectPosition(LatLng latLng) {
    setState(() {
      _latLng = latLng;
    });

    setState(() {
      positions = {
        Marker(
          markerId: const MarkerId('p1'),
          position: latLng,
        ),
      };
    });
  }

  void _finishPosition() {
    Navigator.of(context).pop(_latLng);
  }
}
