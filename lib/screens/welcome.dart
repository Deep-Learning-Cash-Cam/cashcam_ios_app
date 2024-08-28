import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'camera.dart';
import 'gallery.dart'; // Import the gallery page
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
  String _selectedCurrency = 'NIS';
  String? _userName;
  String? _userEmail;
  String? _userPhotoUrl;
  String? _accessToken;
  String? _tokenType;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    try {
      final response = await http.get(
        Uri.parse('http://ec2-54-197-155-194.compute-1.amazonaws.com'),
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

  Future<void> _handleGoogleSignIn() async {
    print('Attempting Google sign-in...');
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        String idToken = googleAuth.idToken!;

        setState(() {
          _userName = googleUser.displayName;
          _userEmail = googleUser.email;
          _userPhotoUrl = googleUser.photoUrl;
        });

        print('Google sign-in successful!');
        print('User Email: $_userEmail');
        print('Display Name: $_userName');
        print('ID Token: $idToken');

        await _sendIdTokenToBackend(idToken);
      }
    } catch (error) {
      print('Google sign-in failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed')),
      );
    }
  }

  Future<void> _sendIdTokenToBackend(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://ec2-54-197-155-194.compute-1.amazonaws.com/auth/google-signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token_id': idToken}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        _accessToken = responseBody['access_token'];
        _tokenType = responseBody['token_type'];

        print('Server login response: ${response.body}');
      } else {
        print('Server error: ${response.body}');
      }
    } catch (e) {
      print('Failed to connect to backend: $e');
    }
  }

  void _continueToApp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          camera: widget.camera,
          selectedCurrency: _selectedCurrency,
          accessToken: _accessToken!,
          tokenType: _tokenType!,
        ),
      ),
    );
  }

  void _openGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryScreen(
          accessToken: _accessToken!, // Pass access token to the gallery screen
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CashCam'),
        backgroundColor: const Color.fromARGB(255, 0, 128, 0),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.jpeg',
                height: 100,
              ),
              SizedBox(height: 20),
              if (_userName != null)
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: _userPhotoUrl != null
                              ? NetworkImage(_userPhotoUrl!)
                              : AssetImage('assets/default_user.png')
                                  as ImageProvider,
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome $_userName',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$_userEmail',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                "Snap and detect the value of your currency!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54),
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
              if (_userName != null)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Select Currency: ',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 10),
                        DropdownButton<String>(
                          value: _selectedCurrency,
                          items:
                              <String>['NIS', 'USD', 'EUR'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCurrency = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              if (_userName == null)
                Column(
                  children: [
                    Text(
                      "Press the Google logo to sign in",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: _handleGoogleSignIn,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Image.asset('assets/google_icon.png'),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              if (_userName != null)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _isConnected ? _continueToApp : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Capture'),
                          SizedBox(width: 8),
                          Icon(Icons.camera_alt),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 31, 133, 31),
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isConnected ? _openGallery : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Gallery'),
                          SizedBox(width: 18),
                          Icon(Icons.photo_library),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 31, 133, 31),
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
