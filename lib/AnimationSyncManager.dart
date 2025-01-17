import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class AnimationSyncManager with ChangeNotifier {
  double _progress = 0.0;
  late final AnimatedMeshGradientController _controller;
  late Timer _timer;
  double get progress => _progress;
  AnimatedMeshGradientController get controller => _controller;
  AnimationSyncManager() {
    //_startAnimation();
    _controller=AnimatedMeshGradientController();
    _controller.start();
  }
  // void _startAnimation() {
  //   _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
  //     _progress += 0.01;
  //     notifyListeners();
  //   });
  // }
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}

final animationSyncManager = AnimationSyncManager();
