import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ColorGenerator {
  List<Color> _availableColors = [];
  final Random _random = Random();
  List<Color> colors = Colors.primaries;

  ColorGenerator() {
    _availableColors = List.from(colors)..shuffle(_random);
  }

  Color getRandomColor() {
    if (_availableColors.isEmpty) _availableColors = List.from(_availableColors)..shuffle(_random);
    return _availableColors.isEmpty ? kPrimaryColor : _availableColors.removeLast();
  }
}
