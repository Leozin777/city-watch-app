import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TirarFotoWidget extends StatefulWidget {
  const TirarFotoWidget({super.key});

  @override
  State<TirarFotoWidget> createState() => _TirarFotoWidgetState();
}

class _TirarFotoWidgetState extends State<TirarFotoWidget> {
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tirar Foto'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text('Selecione uma opção:'),
            ElevatedButton(
              child: const Text('Câmera'),
              onPressed: () async {
                final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  final bytes = await photo.readAsBytes();
                  final resizedImage = img.copyResize(img.decodeImage(bytes)!, width: 500);
                  final encodedImage = img.encodeJpg(resizedImage, quality: 50);
                  final base64String = base64Encode(encodedImage);
                  Navigator.of(context).pop(base64String);
                }
              },
            ),
            ElevatedButton(
              child: const Text('Galeria'),
              onPressed: () async {
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final bytes = await image.readAsBytes();
                  final resizedImage = img.copyResize(img.decodeImage(bytes)!, width: 500);
                  final encodedImage = img.encodeJpg(resizedImage, quality: 50);
                  final base64String = base64Encode(encodedImage);
                  Navigator.of(context).pop(base64String);
                }
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o popup
          },
        ),
      ],
    );
  }
}
