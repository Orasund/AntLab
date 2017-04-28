class GameLoop
{
  int _max_frames;
  int _frame;

  GameLoop(int max)
  {
    _frame = 0;
    _max_frames = max;
  }

  void update()
  {
    _frame = (_frame+1)%_max_frames;
  }

  int getFrame()
  {
    return _frame;
  }

  int getMax()
  {
    return _max_frames;
  }
}