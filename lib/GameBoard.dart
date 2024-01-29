import 'package:flutter/material.dart';
import 'package:tetris/GameEngine.dart';
import 'package:tetris/GridCell.dart';
import 'package:tetris/TetrisFigureInfo.dart';

class GameBoard extends StatefulWidget
{
  static const int rowLength = 10;
  static const int colLength = 15;
  static List<List<TetrisFigureTypes?>> gameBoard = List.generate(
    colLength,
        (i) => List.generate(
          rowLength,
            (j) => null,
    ),
  );

  const GameBoard._privateConstructor();
  static GameBoard instance = const GameBoard._privateConstructor();
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
{
  GameEngine gameEngine = GameEngine.instance;

  @override
  void initState()
  {
    super.initState();

    gameEngine.addUpdateListener(update);
    gameEngine.addGameOverListener(showGameOverDialog);
    gameEngine.startGame();
  }

  @override
  void dispose() {
    gameEngine.removeUpdateListener(update);
    gameEngine.removeGameOverListener(showGameOverDialog);
    super.dispose();
  }

  void update()
  {
    setState(() { });
  }

  void showGameOverDialog()
  {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game over'),
        content: Text("Your score is: ${gameEngine.currentScore}"),
        actions: [
          TextButton(
          onPressed: () {
            resetGame();
            Navigator.pop(context);
          },
          child: const Text('Play again'))
        ],
      )
    );
  }

  void resetGame()
  {
    GameBoard.gameBoard = List.generate(
      GameBoard.colLength,
          (i) => List.generate(
        GameBoard.rowLength,
            (j) => null,
      ),
    );

    gameEngine.startGame();
  }

  void moveFigure(Direction direction)
  {
    if (!gameEngine.checkCollision(direction))
    {
      setState(() {
        gameEngine.getCurrentFigure().moveFigure(direction);
      });
    }
  }

  void rotateFigure()
  {
    setState(() {
      gameEngine.getCurrentFigure().rotate();
    });
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
              itemCount: GameBoard.rowLength * GameBoard.colLength,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: GameBoard.rowLength),
              itemBuilder: (context, index) {
                int rowNumber = (index / GameBoard.rowLength).floor();
                int colNumber = index % GameBoard.rowLength;
            
                if (gameEngine.getCurrentFigure().position.contains(index))
                {
                  return GridCell(
                      color: gameEngine.getCurrentFigure().color
                  );
                }
                else if (GameBoard.gameBoard[rowNumber][colNumber] != null)
                {
                  final TetrisFigureTypes? tetrisFigureType = GameBoard.gameBoard[rowNumber][colNumber];
                  return GridCell(color: tetrisFigureColors[tetrisFigureType]);
                }
                else
                {
                  return GridCell(
                      color: Colors.grey[900]
                  );
                }
              },
              ),
          ),

          Text(
            'Score: ${gameEngine.currentScore}',
            style: const TextStyle(color: Colors.white),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //left
                IconButton(
                  onPressed: () { moveFigure(Direction.left); },
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_back_ios_new)),
                //rotate
                IconButton(
                  onPressed: rotateFigure,
                  color: Colors.white,
                  icon: const Icon(Icons.rotate_right)),
                //right
                IconButton(
                  onPressed: () { moveFigure(Direction.right); },
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}