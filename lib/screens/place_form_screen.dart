import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_great_places/messages/snackbar.dart';
import 'package:flutter_app_great_places/providers/great_places.dart';
import 'package:flutter_app_great_places/widgets/image_input.dart';
import 'package:flutter_app_great_places/widgets/location_input.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({super.key});

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();

  File? _pickedImage;
  LatLng? _latLng;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  void _submitForm() {
    if (!validForm(context)) {
      return;
    }

    Provider.of<GreatPlaces>(context, listen: false)
        .addPlaces(_titleController.text, _pickedImage!, _latLng!)
        .then((added) {
      if (!added) {
        SnackCustom.snack(
          context: context,
          message: 'Houve um problema. Tente adicionar a posição mais tarde.',
          secondsDuration: 4,
        );
      } else {
        Navigator.of(context).pop();
      }
    }).catchError((onError) {
      SnackCustom.snack(
        context: context,
        message:
            'Houve um problema inesperado. Tente adicionar a posição mais tarde.',
        secondsDuration: 4,
      );
    });
  }

  bool validForm(BuildContext context) {
    String message = "";

    if (_titleController.text.isEmpty) {
      message = "Adicione um título!";
    } else if (_pickedImage == null) {
      message = "Adicione um imagem!";
    } else if (_latLng == null) {
      message = "Adicione um localização!";
    }

    if (message.isNotEmpty) {
      SnackCustom.snack(context: context, message: message, secondsDuration: 2);
      return false;
    }

    return true;
  }

  void _selectImage(File? pickedImage) {
    setState(() => _pickedImage = pickedImage);
  }

  void _selectPosition(LatLng? latLng) {
    setState(() => _latLng = latLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Novo Lugar!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Título'),
              controller: _titleController,
              autofocus: true,
            ),
          ),
          ImageInput(selectImage: _selectImage),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LocationInput(selectPosition: _selectPosition),
          ),
          const Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero),
              ),
            ),
            onPressed: _submitForm,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Adicionar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
