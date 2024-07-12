import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  if (cameras.isEmpty) {
    runApp(NoCameraApp());
  } else {
    final firstCamera = cameras.first;
    runApp(MyApp(camera: firstCamera));
  }
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  MyApp({required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinCam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CameraScreen(camera: camera),
    );
  }
}

class NoCameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'No Camera Available',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('No camera is available on this device.'),
        ),
      ),
    );
  }
}
