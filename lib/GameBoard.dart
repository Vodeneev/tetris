import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris/GridCell.dart';
import 'package:tetris/TetrisFigure.dart';
import 'package:tetris/TetrisFigureInfo.dart';

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
            currentFigure.moveFigure(Direction.down);
          });
        });
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
          if (currentFigure.position.contains(index))
          {
            return GridCell(
                color: Colors.yellow,
                child: index
            );
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