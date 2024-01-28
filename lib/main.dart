import 'package:flutter/material.dart';

import 'GameBoard.dart';

void main()
{
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget
{
  const TetrisApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
          home: GameBoard()
        );
  }
}
