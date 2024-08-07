import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'statistics.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final String selectedCurrency;

  CameraScreen({required this.camera, required this.selectedCurrency});

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
      File correctedImage =
          await FlutterExifRotation.rotateImage(path: pickedFile.path);
      _sendImageToServer(context, correctedImage.path);
    }
  }

  Future<void> _sendImageToServer(
      BuildContext context, String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(
            'http://ec2-34-236-154-199.compute-1.amazonaws.com/api/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Image,
          'return_currency': widget.selectedCurrency, // Use selected currency
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final annotatedImageBase64 = responseBody['image'];
        final currencies = responseBody['currencies'] as Map<String, dynamic>;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StatisticsScreen(
              imagePath: imagePath,
              annotatedImageBase64: annotatedImageBase64,
              currencies: currencies,
              selectedCurrency:
                  widget.selectedCurrency, // Pass selected currency
            ),
          ),
        );
      } else {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get response from server')),
        );
      }
    } catch (e) {
      // Handle client error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
        backgroundColor: const Color.fromARGB(255, 31, 133, 31),
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
                  File correctedImage =
                      await FlutterExifRotation.rotateImage(path: image.path);
                  final path = join(
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png',
                  );
                  await correctedImage.copy(path);
                  _sendImageToServer(context, path);
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
