import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:tetris/GameBoard.dart';
import 'package:tetris/TetrisFigures/LTetrisFigure.dart';
import 'package:tetris/TetrisFigures/TetrisFigure.dart';
import 'package:tetris/TetrisFigures/TetrisFigureFactory.dart';
import 'package:tetris/TetrisFigures/TetrisFigureInfo.dart';

class GameEngine
{
  TetrisFigureFactory tetrisFigureFactory = TetrisFigureFactory();
  TetrisFigure currentFigure = LTetrisFigure();
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
      GameBoardPosition gameBoardPosition = GameBoard.getRowColIndexes(currentFigure.position[i]);
      switch (direction)
      {
        case Direction.left:
          gameBoardPosition.colNumber -= 1;
          break;
        case Direction.right:
          gameBoardPosition.colNumber += 1;
          break;
        case Direction.down:
          gameBoardPosition.rowNumber += 1;
          break;
      }

      if (gameBoardPosition.rowNumber >= GameBoard.colLength || gameBoardPosition.colNumber < 0 || gameBoardPosition.colNumber >= GameBoard.rowLength)
      {
        return true;
      }

      if (gameBoardPosition.rowNumber >= 0 && gameBoardPosition.colNumber >= 0)
      {
        if (GameBoard.gameBoard[gameBoardPosition.rowNumber][gameBoardPosition.colNumber] != null)
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
        GameBoardPosition gameBoardPosition = GameBoard.getRowColIndexes(currentFigure.position[i]);

        if(gameBoardPosition.rowNumber >= 0 && gameBoardPosition.colNumber >= 0)
        {
          GameBoard.gameBoard[gameBoardPosition.rowNumber][gameBoardPosition.colNumber] = currentFigure.type;
        }
      }

      createNewFigure();
    }
  }

  void createNewFigure()
  {
    Random random = Random();

    TetrisFigureTypes randomType = TetrisFigureTypes.values[random.nextInt(TetrisFigureTypes.values.length)];
    currentFigure = tetrisFigureFactory.createTetrisFigure(randomType);
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