import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedometer/pedometer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<int>? _subscription;
  int _stepCount = 0;
  late Timer _timer;
  late SharedPreferences _prefs;
  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
    _startTimer();
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

  void _startTimer() {
    _timer = Timer.periodic(Duration(hours: 24), (timer) {
      setState(() {
        _stepCount = 0;
      });

      FirebaseFirestore.instance
          .collection('consumables')
          .doc('fouten')
          .update({'biertjes': 0});
      FirebaseFirestore.instance
          .collection('consumables')
          .doc('fouten')
          .update({'sigaretten': 0});
    });
  }

  void _storeStepCount(int stepCount) {
    _prefs.setInt('stepCount', stepCount);
    FirebaseFirestore.instance
        .collection('step_counter')
        .doc('steps')
        .update({'steps': FieldValue.increment(_stepCount)});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  void _initPedometer() async {
    _prefs = await SharedPreferences.getInstance();
    int lastStepCount = _prefs.getInt('stepCount') ?? 0;
    int lastBootTime =
        _prefs.getInt('bootTime') ?? DateTime.now().millisecondsSinceEpoch;

    Pedometer.stepCountStream.listen((StepCount stepCountEvent) {
      setState(() {
        _stepCount = stepCountEvent.steps - lastStepCount;
      });
      _storeStepCount(stepCountEvent.steps);

      int currentBootTime = DateTime.now().millisecondsSinceEpoch;
      if (_isDifferentDay(lastBootTime, currentBootTime)) {
        _resetStepCount();
        _prefs.setInt('bootTime', currentBootTime);
      }
    }).onError((error) {
      print('Error: $error');
    });
  }

  bool _isDifferentDay(int timestamp1, int timestamp2) {
    DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timestamp1);
    DateTime date2 = DateTime.fromMillisecondsSinceEpoch(timestamp2);
    return date1.year != date2.year ||
        date1.month != date2.month ||
        date1.day != date2.day;
  }

  void _resetStepCount() {
    setState(() {
      _stepCount = 0;
    });
    FirebaseFirestore.instance
        .collection('step_counter')
        .doc('steps')
        .update({'steps': 0});
  }

  void _resetCounts() {
    setState(() {
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
                          FirebaseFirestore.instance
                              .collection('consumables')
                              .doc('fouten')
                              .update(
                                  {'biertjes': FieldValue.increment(_count)});
                          Navigator.of(context).pop();
                        },
                        child: Text('Add biertje'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('consumables')
                              .doc('fouten')
                              .update(
                                  {'sigaretten': FieldValue.increment(_count)});
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
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

              String emoji;
              if (total*1000 - _stepCount <= 1000) {
                emoji = '😄';
              } else if (total*1000 - _stepCount <= 4000) {
                emoji = '😐';
              } else {
                emoji = '😔';
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: emoji,
                          style: TextStyle(
                            fontFamily: 'EmojiOne',
                            fontSize: 120,
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
                  SizedBox(height: 16),
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
                          'Stappen',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$_stepCount',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: orientation == Orientation.portrait
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.end,
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
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
