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
  int currentScore = 0;

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
            disappearLines();
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

  void moveLeft()
  {
    if (!checkCollision(Direction.left))
    {
      setState(() {
        currentFigure.moveFigure(Direction.left);
      });
    }
  }

  void moveRight()
  {
    if (!checkCollision(Direction.right))
    {
      setState(() {
        currentFigure.moveFigure(Direction.right);
      });
    }
  }

  void rotateFigure()
  {
    setState(() {
      currentFigure.rotate();
    });
  }

  disappearLines()
  {
    for (int row = COL_LENGTH - 1; row >= 0; --row)
    {
      bool rowIsFull = true;

      for (int col = 0; col < ROW_LENGTH; ++col)
      {
        if (gameBoard[row][col] == null)
        {
          rowIsFull = false;
          break;
        }
      }

      if (rowIsFull)
      {
        for (int r = row; r > 0; --r)
        {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        gameBoard[0] = List.generate(row, (index) => null);
        ++currentScore;
      }
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
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
                      color: currentFigure.color,
                      child: index
                  );
                }
                else if (gameBoard[rowNumber][colNumber] != null)
                {
                  final TetrisFigureTypes? tetrisFigureType = gameBoard[rowNumber][colNumber];
                  return GridCell(color: tetrisFigureColors[tetrisFigureType], child: '');
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
          ),

          Text(
            'Score: $currentScore',
            style: TextStyle(color: Colors.white),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //left
                IconButton(
                  onPressed: moveLeft,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back_ios_new)),
                //rotate
                IconButton(
                  onPressed: rotateFigure,
                  color: Colors.white,
                  icon: Icon(Icons.rotate_right)),
                //right
                IconButton(
                  onPressed: moveRight,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}