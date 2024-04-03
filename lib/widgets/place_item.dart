import 'package:flutter/material.dart';
import 'package:flutter_app_great_places/models/place.dart';
import 'package:flutter_app_great_places/routes.dart';

class PlaceItem extends StatelessWidget {
  final Place place;

  const PlaceItem({required this.place, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.placeDetails, arguments: place),
      leading: CircleAvatar(backgroundImage: FileImage(place.image)),
      title: Text(
        place.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            place.location.address,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '${place.location.latitude}, ${place.location.longitude}',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
