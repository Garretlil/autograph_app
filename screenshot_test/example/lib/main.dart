import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:screenshot_test/screenshot_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _screenshotCount = 'Unknown';  // Используем строку для отображения числа скриншотов
  final _screenshotTestPlugin = ScreenshotTest();

  @override
  void initState() {
    super.initState();
    initScreenshotCount();
  }

  // Асинхронная инициализация для получения количества скриншотов
  Future<void> initScreenshotCount() async {
    String screenshotCount;
    try {
      // Получаем количество скриншотов
      screenshotCount = (await ScreenshotTest.getScreenshotCount()).toString();
    } on PlatformException {
      screenshotCount = 'Failed to get screenshot count.';
    }

    if (!mounted) return;

    setState(() {
      _screenshotCount = screenshotCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Количество скриншотов: $_screenshotCount\n'),
        ),
      ),
    );
  }
}
