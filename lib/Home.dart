import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _checkLoginStatus() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        // User is not logged in, navigate to the login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // User is logged in, navigate to the main app screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainAppScreen()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // ...
}
