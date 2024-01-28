import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/GridCell.dart';
import 'package:tetris/TetrisFigure.dart';
import 'package:tetris/TetrisFigureInfo.dart';

List<List<TetrisFigureTypes?>> gameBoard = List.generate(
    COL_LENGTH,
    (i) => List.generate(
      ROW_LENGTH,
      (j) => null,
    ),
);

class GameBoard extends StatefulWidget
{
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  TetrisFigure currentFigure = TetrisFigure(type: TetrisFigureTypes.L);

  @override
  void initState()
  {
    super.initState();

    startGame();
  }

  void startGame()
  {
    currentFigure.initializeTetrisFigure();

    Duration frameRate = const Duration(milliseconds: 400);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate)
  {
    Timer.periodic(
        frameRate,
        (timer) {
          setState(() {
            checkLanding();
            currentFigure.moveFigure(Direction.down);
          });
        });
  }

  bool checkCollision(Direction direction)
  {
    for (int i = 0; i < currentFigure.position.length; ++i)
    {
      int rowNumber = (currentFigure.position[i] / ROW_LENGTH).floor();
      int colNumber = currentFigure.position[i] % ROW_LENGTH;

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

      if (rowNumber >= COL_LENGTH || colNumber < 0 || colNumber >= ROW_LENGTH)
      {
        return true;
      }

      if (rowNumber >= 0 && colNumber >= 0)
      {
        if (gameBoard[rowNumber][colNumber] != null)
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
        int rowNumber = (currentFigure.position[i] / ROW_LENGTH).floor();
        int colNumber = currentFigure.position[i] % ROW_LENGTH;

        if(rowNumber >= 0 && colNumber >= 0)
        {
          gameBoard[rowNumber][colNumber] = currentFigure.type;
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
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
        itemCount: ROW_LENGTH * COL_LENGTH,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ROW_LENGTH),
        itemBuilder: (context, index) {
          int rowNumber = (index / ROW_LENGTH).floor();
          int colNumber = index % ROW_LENGTH;
          
          if (currentFigure.position.contains(index))
          {
            return GridCell(
                color: Colors.yellow,
                child: index
            );
          }
          else if (gameBoard[rowNumber][colNumber] != null)
          {
            return GridCell(color: Colors.pink, child: '');
          }
          else
          {
            return GridCell(
                color: Colors.grey[900],
                child: index
            );
          }
        },
        ),
    );
  }
}