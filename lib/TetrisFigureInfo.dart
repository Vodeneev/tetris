import 'package:flutter/material.dart';

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