import 'package:flutter/material.dart';
import 'package:tetris/GameBoard.dart';

import 'TetrisFigureInfo.dart';

class TetrisFigure
{
  TetrisFigureTypes type;
  List<int> position = [];
  int rotationState = 1;

  Color get color
  {
    return tetrisFigureColors[type] ?? Colors.white;
  }

  TetrisFigure({required this.type});

  void initializeTetrisFigure()
  {
    switch (type)
    {
      case TetrisFigureTypes.L:
        position = [
          -26, -16, -6, -5
        ];
        break;
      case TetrisFigureTypes.I:
        position = [
          -4, -5, -6, -7
        ];
        break;
      case TetrisFigureTypes.O:
        position = [
          -15, -16, -5, -6
        ];
        break;

      default:
    }
  }

  void moveFigure(Direction direction)
  {
    switch (direction)
    {
      case Direction.down:
        for (int i = 0; i < position.length; ++i)
        {
          position[i] += GameBoard.rowLength;
        }
        break;

      case Direction.left:
        for (int i = 0; i < position.length; ++i)
        {
          position[i] -= 1;
        }
        break;

      case Direction.right:
        for (int i = 0; i < position.length; ++i)
        {
          position[i] += 1;
        }
        break;

      default:
    }
  }

  void rotate()
  {
    List<int> newPosition = [];
    switch (type)
    {
      case TetrisFigureTypes.L:
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

        break;

      case TetrisFigureTypes.I:
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

        break;

      case TetrisFigureTypes.O:
      default:
        break;
    }
  }

  bool isPositionValid(int position)
  {
    int rowNumber = (position / GameBoard.rowLength).floor();
    int colNumber = position % GameBoard.rowLength;

    if (rowNumber < 0 || colNumber < 0 || GameBoard.gameBoard[rowNumber][colNumber] != null)
    {
      return false;
    }

    return true;
  }

  bool isFigurePositionValid(List<int> figurePosition)
  {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in figurePosition)
    {
      if (!isPositionValid(pos))
      {
        return false;
      }

      int colNumber = pos % GameBoard.rowLength;

      if (colNumber == 0)
      {
        firstColOccupied = true;
      }

      if (colNumber == GameBoard.rowLength - 1)
      {
        lastColOccupied = true;
      }
    }

    return !(firstColOccupied && lastColOccupied);
  }
}