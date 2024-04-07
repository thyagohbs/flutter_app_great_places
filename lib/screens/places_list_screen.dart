import 'package:flutter/material.dart';
import 'package:flutter_app_great_places/providers/great_places.dart';
import 'package:flutter_app_great_places/routes.dart';
import 'package:flutter_app_great_places/widgets/place_item.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          title: const Text(
            'Lugares',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.placeForm);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
        /* Responsável em gerir a visualização das listas*/
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _renderWaiting();
            }

            return _renderListViewGreatPlaces();
          },
        ));
  }

  Consumer<GreatPlaces> _renderListViewGreatPlaces() {
    return Consumer<GreatPlaces>(
      child: const Center(
        child: Text(
          'Nenhum lugar cadastrado',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
      ),
      builder: (context, greatPlaces, child) {
        if (greatPlaces.itemsCount == 0) {
          return child!;
        }

        return ListView.builder(
          itemCount: greatPlaces.itemsCount,
          itemBuilder: (context, index) {
            return PlaceItem(place: greatPlaces.items[index]);
          },
        );
      },
    );
  }

  Center _renderWaiting() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
