import 'package:flutter/material.dart';
import 'package:tetris/GameBoard.dart';

import 'package:tetris/TetrisFigures/TetrisFigureInfo.dart';

abstract class TetrisFigure
{
  List<int> position;
  int rotationState;
  TetrisFigureTypes type;
  Color color;

  TetrisFigure({required this.type}) : position = [], rotationState = 1, color = Colors.white;

  void initializeTetrisFigure();

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

  void rotate();

  bool isPositionValid(int position)
  {
    GameBoardPosition gameBoardPosition = GameBoard.getRowColIndexes(position);

    if (gameBoardPosition.rowNumber < 0 || gameBoardPosition.colNumber < 0 || GameBoard.gameBoard[gameBoardPosition.rowNumber][gameBoardPosition.colNumber] != null)
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

  Color getColor()
  {
    return color;
  }
}