import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';

class ClusterIconPainter {
  const ClusterIconPainter(this.clusterSize);

  final int clusterSize;

  Future<Uint8List> getClusterIconBytes() async {
    const size = Size(150, 150);
    final recorder = PictureRecorder();

    _paintTextCountPlacemarks(
      text: clusterSize.toString(),
      size: size,
      canvas: _paintCirclePlacemark(
        size: size,
        recorder: recorder,
      ),
    );

    final image = await recorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);


    return pngBytes!.buffer.asUint8List();
  }
}

Canvas _paintCirclePlacemark({
  required Size size,
  required PictureRecorder recorder,
}) {
  final canvas = Canvas(recorder);
  final radius = size.height / 2.15;

  final fillPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  final strokePaint = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8;


  final circleOffset = Offset(size.height / 2, size.width / 2);

  canvas
    ..drawCircle(circleOffset, radius, fillPaint)
    ..drawCircle(circleOffset, radius, strokePaint);
  return canvas;
}

void _paintTextCountPlacemarks({
  required String text,
  required Size size,
  required Canvas canvas,
}) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.green,
        fontSize: 50,
        fontWeight: FontWeight.w800,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: size.width);

  final textOffset = Offset(
    (size.width - textPainter.width) / 2,
    (size.height - textPainter.height) / 2,
  );
  textPainter.paint(canvas, textOffset);
}
