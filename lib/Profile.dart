import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (_currentUser != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(_currentUser!.uid).get();
      setState(() {
        _userData = snapshot.data() as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentUser != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('First Name: ${_userData?['firstName'] ?? 'N/A'}'),
                  Text('Last Name: ${_userData?['lastName'] ?? 'N/A'}'),
                  Text('Email: ${_userData?['email'] ?? 'N/A'}'),
                  // Add more Text widgets to display other user fields
                ],
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
