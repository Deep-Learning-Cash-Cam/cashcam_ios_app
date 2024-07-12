import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'statistics.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  CameraScreen({required this.camera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StatisticsScreen(imagePath: pickedFile.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonSize = screenWidth * 0.3;

    return Scaffold(
      appBar: AppBar(
        title: Text('CashCam'),
        backgroundColor: const Color.fromARGB(255, 217, 245, 198),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 16.0,
            bottom: 16.0,
            child: FloatingActionButton(
              child: Icon(Icons.photo_library),
              onPressed: () => _pickImage(context),
              heroTag: 'gallery',
              foregroundColor: Color.fromARGB(255, 29, 30, 29),
              backgroundColor: const Color.fromARGB(255, 217, 245, 198),
            ),
          ),
          Positioned(
            bottom: 16.0,
            child: GestureDetector(
              onTap: () async {
                try {
                  await _initializeControllerFuture;
                  final image = await _controller.takePicture();
                  final path = join(
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png',
                  );
                  await image.saveTo(path);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatisticsScreen(imagePath: path),
                    ),
                  );
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo.jpeg'),
                    fit: BoxFit.cover,
                  ),
                  //shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
