import 'package:flutter/material.dart';
import 'package:tetris/GridCell.dart';

class GameBoard extends StatefulWidget
{
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
{
  int rowLength = 10;
  int colLength = 15;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
        itemCount: rowLength * colLength,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: rowLength),
        itemBuilder: (context, index) => Center(
          child: GridCell(
              color: Colors.grey[900],
              child: index,
          ),
        ),
      ),
    );
  }
}