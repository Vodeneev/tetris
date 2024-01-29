import 'package:flutter/material.dart';
import 'package:tetris/TetrisFigures/TetrisFigure.dart';
import 'package:tetris/TetrisFigures/TetrisFigureInfo.dart';

class OTetrisFigure extends TetrisFigure
{
  OTetrisFigure() : super(type: TetrisFigureTypes.O);

  @override
  void initializeTetrisFigure()
  {
    position = [
      -15, -16, -5, -6
    ];
    color = Colors.blue;
  }

  @override
  void rotate() {}
}
