import 'package:http/http.dart' as http;
import 'dart:convert';

class CatData {
  final String breed;
  final String country;
  final String origin;
  final String coat;
  final String pattern;

  CatData({
    required this.breed,
    required this.country,
    required this.origin,
    required this.coat,
    required this.pattern
  });

  factory CatData.fromJson(Map<String, dynamic> json) {
    return CatData(
      breed: json['breed'],
      country: json['country'],
      origin: json['origin'],
      coat: json['coat'],
      pattern: json['pattern'],
    );
  }
}

class CatApi {
  static const baseUrl = 'https://catfact.ninja';
  static const factsEndpoint = '/breeds';

  Future<List<CatData>> getAllData() async {
    final response = await http.get(Uri.parse('$baseUrl$factsEndpoint'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final dataList = jsonResponse['data'] as List<dynamic>;
      return dataList.map((json) => CatData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch cat data');
    }
  }
}
