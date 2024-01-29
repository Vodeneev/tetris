import 'package:flutter/material.dart';
import 'package:tetris/GameBoard.dart';
import 'package:tetris/TetrisFigures/TetrisFigure.dart';
import 'package:tetris/TetrisFigures/TetrisFigureInfo.dart';

class LTetrisFigure extends TetrisFigure
{
  LTetrisFigure() : super(type: TetrisFigureTypes.L);

  @override
  void initializeTetrisFigure()
  {
    position = [
      -26, -16, -6, -5
    ];
    color = Colors.orange;
  }

  @override
  void rotate()
  {
    List<int> newPosition = [];
    switch (rotationState)
    {
      case 0:
        newPosition = [
          position[1] - GameBoard.rowLength,
          position[1],
          position[1] + GameBoard.rowLength,
          position[1] + GameBoard.rowLength + 1,
        ];
        break;

      case 1:
        newPosition = [
          position[1] - 1,
          position[1],
          position[1] + 1,
          position[1] + GameBoard.rowLength - 1,
        ];
        break;

      case 2:
        newPosition = [
          position[1] + GameBoard.rowLength,
          position[1],
          position[1] - GameBoard.rowLength,
          position[1] - GameBoard.rowLength - 1,
        ];
        break;

      case 3:
        newPosition = [
          position[1] - GameBoard.rowLength + 1,
          position[1],
          position[1] + 1,
          position[1] - 1,
        ];
        break;
    }

    if (isFigurePositionValid(newPosition))
    {
      position = newPosition;
      rotationState = (rotationState + 1) % 4;
    }
  }
}
