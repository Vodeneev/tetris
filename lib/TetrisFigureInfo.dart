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
  J,
  I,
  O,
  S,
  Z,
  T,
}

const Map<TetrisFigureTypes, Color> tetrisFigureColors = {
  TetrisFigureTypes.L: Colors.orange,
  TetrisFigureTypes.J: Colors.blue,
  TetrisFigureTypes.I: Colors.pink,
  TetrisFigureTypes.O: Colors.yellow,
  TetrisFigureTypes.S: Colors.green,
  TetrisFigureTypes.Z: Colors.red,
  TetrisFigureTypes.T: Colors.purple,
};