import 'package:flutter/material.dart';
import 'package:flutter_app_great_places/models/place.dart';
import 'package:flutter_app_great_places/models/place_location_map.dart';
import 'package:flutter_app_great_places/screens/map_screen.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Place place = ModalRoute.of(context)?.settings.arguments as Place;
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            place.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.black54),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(204, 68, 137, 255),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => MapScreen(
                  isReadonly: true,
                  inititalPlacelocationMap: PlaceLocationMap(
                    placeLocation: place.location,
                  ),
                ),
              ));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, color: Colors.black),
                SizedBox(
                  width: 15,
                ),
                Text('Ver no mapa',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
