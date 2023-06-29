import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Logging.dart';
import 'package:flutter_application_1/Profile.dart';
import 'package:flutter_application_1/Rapports.dart';
import 'Login.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen(this.user);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final screens = [
    MyHomePage(),
    FitnessJournalPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.blue.shade400,
              labelTextStyle: MaterialStateProperty.all(const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white))),
          child: NavigationBar(
            height: 70,
            selectedIndex: index,
            onDestinationSelected: (index) =>
                setState(() => this.index = index),
            backgroundColor: const Color.fromARGB(255, 44, 44, 44),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_filled, color: Colors.white),
                  label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.assignment, color: Colors.white),
                  label: 'Rapports'),
              NavigationDestination(
                  icon: Icon(Icons.person, color: Colors.white),
                  label: 'Account')
            ],
          )),
    );
  }
}
