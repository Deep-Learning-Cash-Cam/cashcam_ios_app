import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/welcome.dart';

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
      title: 'CashCam',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color.fromARGB(255, 217, 245, 198),
      ),
      home: WelcomeScreen(camera: camera),
      debugShowCheckedModeBanner: false,
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
        scaffoldBackgroundColor: const Color.fromARGB(255, 217, 245, 198),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.jpeg'),
              SizedBox(height: 20),
              Text('No camera is available on this device.'),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
