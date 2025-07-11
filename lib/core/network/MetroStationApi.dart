import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/MetroStation.dart';

Future<List<MetroStation>> fetchMetroStations() async {
  final response = await http.get(Uri.parse('https://api.hh.ru/metro/1'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<MetroStation> stations = [];

    for (final line in data['lines']) {
      final String lineName = line['name'];
      final String hexColor = line['hex_color'];
      for (final station in line['stations']) {
        stations.add(MetroStation.fromJson(station, lineName, hexColor));
      }
    }
    return stations;

  } else {
    return [];
  }
}