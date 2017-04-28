class GameLoop
{
  private int _max;
  private int _frame;

  GameLoop(int max)
  {
    _frame = 0;
    _max = max;
  }

  public void update()
  {
    _frame = (_frame+1)%_max;
  }

  public int getFrame()
  {
    return _frame;
  }

  public int getMax()
  {
    return _max;
  }
}