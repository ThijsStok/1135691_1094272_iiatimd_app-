import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _biertjesCount = 0;
  int _sigarettenCount = 0;

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
    });
  }

  void _showAddDialog(String title) {
    int _count = 1;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          _addBiertje(_count);
                          Navigator.of(context).pop();
                        },
                        child: Text('Add biertje'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _addSigaret(_count);
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
              ),
            );
          },
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
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Column(
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
                        color: Colors.green,
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
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'stappen',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetCounts,
            child: Text('Reset counts'),
          ),
        ],
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
