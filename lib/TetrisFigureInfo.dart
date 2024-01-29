import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/TetrisFigure.dart';

const int ROW_LENGTH = 10;
const int COL_LENGTH = 15;

enum Direction {
  left,
  right,
  down
}

enum TetrisFigureTypes
{
  L,
  I,
  O,
}

const Map<TetrisFigureTypes, Color> tetrisFigureColors = {
  TetrisFigureTypes.L: Colors.orange,
  TetrisFigureTypes.I: Colors.green,
  TetrisFigureTypes.O: Colors.blue,
};