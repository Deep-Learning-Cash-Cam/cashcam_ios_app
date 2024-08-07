import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'camera.dart';
import 'package:camera/camera.dart';

class WelcomeScreen extends StatefulWidget {
  final CameraDescription camera;

  WelcomeScreen({required this.camera});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _connectivityMessage = 'Checking connectivity...';
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    try {
      final response = await http.get(
        Uri.parse('http://ec2-34-236-154-199.compute-1.amazonaws.com/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['message'] == 'Welcome to CashCam!') {
          setState(() {
            _connectivityMessage = 'Server Available';
            _isConnected = true;
          });
        } else {
          setState(() {
            _connectivityMessage = 'Unexpected response from server';
            _isConnected = false;
          });
        }
      } else {
        setState(() {
          _connectivityMessage = 'Connection Failed: ${response.reasonPhrase}';
          _isConnected = false;
        });
      }
    } catch (e) {
      setState(() {
        _connectivityMessage = 'Connection Error: $e';
        _isConnected = false;
      });
    }
  }

  void _continueToApp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: widget.camera),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to CashCam'),
        backgroundColor: const Color.fromARGB(255, 0, 128, 0),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Snap and detect the value of your currency!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                _connectivityMessage,
                style: TextStyle(
                    fontSize: 18,
                    color: _isConnected ? Colors.green : Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 100,
                child: IconButton(
                  icon: Image.asset('assets/google_icon.png'),
                  onPressed: () {
                    // Future Google Sign-In logic can be added here
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isConnected ? _continueToApp : null,
                child: Text('Continue to App'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 31, 133, 31),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
