import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MetroStation {
  final String name;
  final String line;
  final Color color;

  const MetroStation({
    required this.name,
    required this.line,
    required this.color,
  });

  factory MetroStation.fromJson(Map<String, dynamic> json, String lineName, String hexColor) {
    return MetroStation(
      name: json['name'],
      line: lineName,
      color: _hexToColor(hexColor),
    );
  }


  static Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex"; // add alpha
    return Color(int.parse(hex, radix: 16));
  }
}
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
    // for (final station in stations){
    //   print(station.name);
    // }
    return stations;
  } else {
    throw Exception('Failed to load metro stations');
  }
}

List<MetroStation> getMatchingStations(List<MetroStation> stationsList, String targetStation){
  List<MetroStation> outputStations=[];
  for (var station in stationsList){
    if (targetStation.contains(station.name)){
      outputStations.add(station);
    }
  }
  return outputStations;

}


