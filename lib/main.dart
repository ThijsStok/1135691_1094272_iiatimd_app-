import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/cat_fact_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CatApi api = CatApi();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Data App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cat Data'),
        ),
        body: FutureBuilder<List<CatData>>(
          future: api.getAllData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final catDataList = snapshot.data!;
              return ListView.builder(
                itemCount: catDataList.length,
                itemBuilder: (context, index) {
                  final catData = catDataList[index];
                  return ListTile(
                    title: Text(snapshot.data![index].breed),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CatDataScreen(
                            breed: snapshot.data![index].breed,
                            country: snapshot.data![index].country,
                            coat: snapshot.data![index].coat,
                            origin: snapshot.data![index].origin,
                            pattern: snapshot.data![index].pattern,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class CatDataScreen extends StatelessWidget {
  final String breed;
  final String country;
  final String coat;
  final String origin;
  final String pattern;

  CatDataScreen({
    required this.breed,
    required this.country,
    required this.coat,
    required this.origin,
    required this.pattern,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Breed: $breed'),
            Text('Country: $country'),
            Text('Coat: $coat'),
            Text('Origin: $origin'),
            Text('Pattern: $pattern'),
          ],
        ),
      ),
    );
  }
}
