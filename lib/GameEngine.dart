import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:tetris/GameBoard.dart';
import 'package:tetris/TetrisFigure.dart';
import 'package:tetris/TetrisFigureInfo.dart';

class GameEngine
{
  TetrisFigure currentFigure = TetrisFigure(type: TetrisFigureTypes.L);
  int currentScore = 0;
  bool gameOver = false;

  List<VoidCallback> updateListeners = [];
  List<VoidCallback> gameOverListeners = [];

  GameEngine._privateConstructor();
  static GameEngine instance = GameEngine._privateConstructor();

  void startGame()
  {
    currentFigure.initializeTetrisFigure();

    gameOver = false;
    currentScore = 0;

    createNewFigure();

    Duration frameRate = const Duration(milliseconds: 400);
    instance.gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate)
  {
    Timer.periodic(
      frameRate,
          (timer) {
            disappearLines();
            checkLanding();

            notifyUpdateListeners();

            if (gameOver == true)
            {
              timer.cancel();
            }

            currentFigure.moveFigure(Direction.down);
        });
  }

  bool checkCollision(Direction direction)
  {
    for (int i = 0; i < currentFigure.position.length; ++i)
    {
      int rowNumber = (currentFigure.position[i] / GameBoard.rowLength).floor();
      int colNumber = currentFigure.position[i] % GameBoard.rowLength;

      switch (direction)
      {
        case Direction.left:
          colNumber -= 1;
          break;
        case Direction.right:
          colNumber += 1;
          break;
        case Direction.down:
          rowNumber += 1;
          break;
      }

      if (rowNumber >= GameBoard.colLength || colNumber < 0 || colNumber >= GameBoard.rowLength)
      {
        return true;
      }

      if (rowNumber >= 0 && colNumber >= 0)
      {
        if (GameBoard.gameBoard[rowNumber][colNumber] != null)
        {
          return true;
        }
      }
    }

    return false;
  }

  void checkLanding()
  {
    if (checkCollision(Direction.down))
    {
      for (int i = 0; i < currentFigure.position.length; ++i)
      {
        int rowNumber = (currentFigure.position[i] / GameBoard.rowLength).floor();
        int colNumber = currentFigure.position[i] % GameBoard.rowLength;

        if(rowNumber >= 0 && colNumber >= 0)
        {
          GameBoard.gameBoard[rowNumber][colNumber] = currentFigure.type;
        }
      }

      createNewFigure();
    }
  }

  void createNewFigure()
  {
    Random random = Random();

    TetrisFigureTypes randomType = TetrisFigureTypes.values[random.nextInt(TetrisFigureTypes.values.length)];
    currentFigure = TetrisFigure(type: randomType);
    currentFigure.initializeTetrisFigure();

    if (instance.isGameOver())
    {
      setGameOverState(true);
    }
  }

  void disappearLines()
  {
    for (int row = GameBoard.colLength - 1; row >= 0; --row)
    {
      bool rowIsFull = true;

      for (int col = 0; col < GameBoard.rowLength; ++col)
      {
        if (GameBoard.gameBoard[row][col] == null)
        {
          rowIsFull = false;
          break;
        }
      }

      if (rowIsFull)
      {
        for (int r = row; r > 0; --r)
        {
          GameBoard.gameBoard[r] = List.from(GameBoard.gameBoard[r - 1]);
        }

        GameBoard.gameBoard[0] = List.generate(row, (index) => null);
        ++currentScore;
      }
    }
  }

  bool isGameOver()
  {
    for (int col = 0; col < GameBoard.rowLength; ++col)
    {
      if (GameBoard.gameBoard[0][col] != null)
      {
        return true;
      }
    }

    return false;
  }
  
  void setGameOverState(bool gameOverState)
  {
    gameOver = gameOverState;
    if (gameOver)
    {
      notifyGameOverListeners();
    }
  }

  TetrisFigure getCurrentFigure()
  {
    return currentFigure;
  }

  void addUpdateListener(VoidCallback listener) {
    updateListeners.add(listener);
  }

  void addGameOverListener(VoidCallback listener) {
    gameOverListeners.add(listener);
  }

  void removeUpdateListener(VoidCallback listener) {
    updateListeners.remove(listener);
  }

  void removeGameOverListener(VoidCallback listener) {
    gameOverListeners.remove(listener);
  }

  void notifyUpdateListeners()
  {
    for (var listener in updateListeners) {
      listener();
    }
  }

  void notifyGameOverListeners()
  {
    for (var listener in gameOverListeners) {
      listener();
    }
  }


}