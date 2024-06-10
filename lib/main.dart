import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_camera_example/display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Camera(
        camera: firstCamera,
      ),
    ),
  );
}

class Camera extends StatefulWidget {
  final CameraDescription camera;

  const Camera({
    super.key,
    required this.camera,
  });

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

Future<Uint8List?> cameraGetPicture() async {
  XFile? file = await _controller.takePicture();

  return await file.readAsBytes(); // convert into Uint8List.
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final Uint8List? image = await cameraGetPicture();
            if (image != null) {
              final path = image;
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPicture(imagePath: path),
              ),
            );
            } 

            
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}