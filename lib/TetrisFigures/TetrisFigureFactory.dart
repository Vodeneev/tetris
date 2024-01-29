import 'package:tetris/TetrisFigures/ITetrisFigure.dart';
import 'package:tetris/TetrisFigures/LTetrisFigure.dart';
import 'package:tetris/TetrisFigures/OTetrisFigure.dart';
import 'package:tetris/TetrisFigures/TetrisFigure.dart';
import 'package:tetris/TetrisFigures/TetrisFigureInfo.dart';

class TetrisFigureFactory
{
  TetrisFigure createTetrisFigure(TetrisFigureTypes type) {
    switch (type) {
      case TetrisFigureTypes.L:
        return LTetrisFigure();
      case TetrisFigureTypes.I:
        return ITetrisFigure();
      case TetrisFigureTypes.O:
        return OTetrisFigure();
      default:
        throw Exception("Unsupported figure type");
    }
  }
}