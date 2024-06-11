import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DisplayPicture extends StatelessWidget {
  final Uint8List? imagePath;

  const DisplayPicture({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture')),
      body: Image.memory (
                   imagePath!,
                   fit: BoxFit.cover,
               ),
    );
  }
}