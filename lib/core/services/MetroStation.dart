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
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse(hex, radix: 16));
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


