import 'package:flutter/material.dart';

const String baseUrlFinal="https://autograph-dentistry.com/api/";
const String baseUrl="https://998e-2-56-127-47.ngrok-free.app";
const String base="http://192.168.190.4:8000";
Color buttonCard=const Color(0xFFFF7F1F);
Color background=const Color(0xFF111111);

Shader createGradient(Rect bounds) {

  if (bounds.isEmpty) {
    return const LinearGradient(colors: [Colors.transparent, Colors.transparent]).createShader(bounds);
  }
  return const LinearGradient(
    colors: [Colors.orange, Colors.red],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ).createShader(bounds);
}