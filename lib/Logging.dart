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

  void _addBiertje(int count) {
    setState(() {
      _biertjesCount += count;
    });
  }

  void _addSigaret(int count) {
    setState(() {
      _sigarettenCount += count;
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
                          _addBiertje(_count);
                          FirebaseFirestore.instance.collection('consumables').doc('fouten').update({
                          'biertjes': FieldValue.increment(_count)
                          });
                          Navigator.of(context).pop();

                        },
                        child: Text('Add biertje'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _addSigaret(_count);
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
    String smiley = '😊';
    if (_biertjesCount + _sigarettenCount > 10) {
      smiley = '😐';
    }
    if (_biertjesCount + _sigarettenCount > 20) {
      smiley = '😔';
    }
    if (_sigarettenCount > 30) {
      smiley = '😵';
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Text(
                  smiley,
                  style: TextStyle(fontSize: 100),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'biertjes',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$_biertjesCount',
                              style: TextStyle(fontSize: 30),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'sigaretten',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$_sigarettenCount',
                              style: TextStyle(fontSize: 30),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 340,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'stappen',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$_stepCount',
                    style: TextStyle(fontSize: 30),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetCounts,
              child: Text('Reset counts'),
            ),
          ],
        ),
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
