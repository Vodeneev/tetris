import 'TetrisFigureInfo.dart';

class TetrisFigure
{
  TetrisFigureTypes type;
  List<int> position = [];

  TetrisFigure({required this.type});

  void initializeTetrisFigure()
  {
    switch (type)
    {
      case TetrisFigureTypes.L:
        position = [
          4, 14, 24, 25
        ];
        break;

      default:
    }
  }

  void moveFigure(Direction direction)
  {
    switch (direction)
    {
      case Direction.down:
        for (int i = 0; i < position.length; ++i)
        {
          position[i] += ROW_LENGTH;
        }
        break;

      case Direction.left:
        for (int i = 0; i < position.length; ++i)
        {
          position[i] -= 1;
        }
        break;

      case Direction.right:
        for (int i = 0; i < position.length; ++i)
        {
          position[i] += 1;
        }
        break;

      default:
    }
  }
}