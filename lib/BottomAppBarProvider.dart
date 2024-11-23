
import 'package:flutter/material.dart';

class IconState {
  int index;
  Color color;

  IconState({required this.index, required this.color});
}

class BottomAppBarState {
  var home = IconState(index: 0, color: Colors.deepOrange);
  var cart = IconState(index: 1, color: Colors.white);
  var profile = IconState(index: 2, color: Colors.white);
  var current = 0;

  void changeState(int indexButton) {
    current = indexButton;
    home.color = (indexButton == 0) ? Colors.deepOrange : Colors.white;
    cart.color = (indexButton == 1) ? Colors.deepOrange : Colors.white;
    profile.color = (indexButton == 2) ? Colors.deepOrange : Colors.white;
  }
}
