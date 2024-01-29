import 'package:flutter/material.dart';
import 'package:tetris/GameBoard.dart';
import 'package:tetris/TetrisFigures/TetrisFigure.dart';
import 'package:tetris/TetrisFigures/TetrisFigureInfo.dart';

class ITetrisFigure extends TetrisFigure
{
  ITetrisFigure() : super(type: TetrisFigureTypes.I);

  @override
  void initializeTetrisFigure()
  {
    position = [
      -4, -5, -6, -7
    ];
    color = Colors.green;
  }

  @override
  void rotate()
  {
    List<int> newPosition = [];
    switch (rotationState)
    {
      case 0:
        newPosition = [
          position[1] - 1,
          position[1],
          position[1] + 1,
          position[1] + 2,
        ];

        break;

      case 1:
        newPosition = [
          position[1] - GameBoard.rowLength,
          position[1],
          position[1] + GameBoard.rowLength,
          position[1] + 2 * GameBoard.rowLength,
        ];

        break;

      case 2:
        newPosition = [
          position[1] + 1,
          position[1],
          position[1] - 1,
          position[1] - 2,
        ];

        break;

      case 3:
        newPosition = [
          position[1] + GameBoard.rowLength,
          position[1],
          position[1] - GameBoard.rowLength,
          position[1] - 2 * GameBoard.rowLength,
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
