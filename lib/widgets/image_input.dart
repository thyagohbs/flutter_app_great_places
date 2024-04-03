import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final void Function(File? pickedImage) selectImage;
  const ImageInput({super.key, required this.selectImage});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  void _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ) as XFile;

    setState(() => _storedImage = File(imageFile.path));

    File savedImage = await _saveImageOnDispositive();
    widget.selectImage(savedImage);
  }

  Future<File> _saveImageOnDispositive() async {
    final Directory appDirectory =
        await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(_storedImage!.path);
    final File savedImage =
        await _storedImage!.copy('${appDirectory.path}$fileName');
    return savedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage == null
              ? const Text('Nenhuma Imagem!')
              : Image.file(
                  _storedImage!,
                  width: 200,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: IconButton(
            onPressed: () => _takePicture(),
            icon: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera),
                SizedBox(width: 10),
                Text('Tirar foto'),
              ],
            ),
          ),
        )
      ],
    );
  }
}
