import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedometer/pedometer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _biertjesCount = 0;
  int _sigarettenCount = 0;
  StreamSubscription<int>? _subscription;
  int _stepCount = 0;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _initPedometer();
    } else {
      _requestPermissions();
    }
  }

  Future<void> _requestPermissions() async {
    List<Permission> permissions = [
      Permission.activityRecognition,
      Permission.location,
    ];

    Map<Permission, PermissionStatus> permissionStatuses =
        await permissions.request();

    if (permissionStatuses[Permission.activityRecognition]!.isGranted) {
      _initPedometer();
    } else {
      // Handle the case where permissions are denied by the user.
      // You can display an error message or take appropriate action.
      // For simplicity, this example does not handle the denied case.
    }
  }

  void _storeStepCount(int stepCount) {
    FirebaseFirestore.instance.collection('step_counter').add({
      'timestamp': DateTime.now(),
      'stepCount': stepCount,
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _initPedometer() {
    Pedometer.stepCountStream.listen((StepCount stepCountEvent) {
      setState(() {
        _stepCount = stepCountEvent.steps;
      });
      _storeStepCount(stepCountEvent.steps);
    }).onError((error) {
      print('Error: $error');
    });
  }

  void _resetCounts() {
    setState(() {
      _biertjesCount = 0;
      _sigarettenCount = 0;
      _stepCount = 0;
    });
  }

  void _showAddDialog(String title) {
    int _count = 1;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('consumables').doc('fouten').update({
                          'biertjes': FieldValue.increment(_count)
                          });
                          Navigator.of(context).pop();

                        },
                        child: Text('Add biertje'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('consumables').doc('fouten').update({
                          'sigaretten': FieldValue.increment(_count)
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text('Add sigaret'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (_count > 1) {
                              _count--;
                            }
                          });
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text(
                        '$_count',
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _count++;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('consumables').doc('fouten').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          int total = data['biertjes'] + data['sigaretten'];

          IconData icon;
          Color color;
          if (total <= 10) {
            icon = Icons.sentiment_very_satisfied;
            color = Colors.green;
          } else if (total <= 20) {
            icon = Icons.sentiment_neutral;
            color = Colors.yellow;
          } else {
            icon = Icons.sentiment_very_dissatisfied;
            color = Colors.red;
          }

          String emoji;
          if (total <= 10) {
            emoji = '😄';
          } else if (total <= 20) {
            emoji = '😐';
          } else {
            emoji = '😔';
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: emoji,
                            style: TextStyle(
                              fontFamily: 'EmojiOne',
                              fontSize: 64,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Biertjes',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${data['biertjes']}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sigaretten',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${data['sigaretten']}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                _showAddDialog('Add item');
              },
              tooltip: 'Add item',
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}