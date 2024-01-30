import 'package:flutter/material.dart';

class StartPage extends StatelessWidget
{
  const StartPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Tetris"),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, "/game", (route) => false);
            },
            child: const Text("Start game"),
          ),
        ),
      ),
    );
  }
}