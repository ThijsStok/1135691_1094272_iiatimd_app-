import 'package:flutter/material.dart';

class Rapports extends StatefulWidget {
  const Rapports({super.key});

  @override
  State<Rapports> createState() => _RapportsState();
}

class _RapportsState extends State<Rapports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Rapports',
          style: TextStyle(fontSize: 72),
        ),
      ),
    );
  }
}
