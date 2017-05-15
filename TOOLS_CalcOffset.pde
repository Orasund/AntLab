int[] calcOffset(int cols, int rows)
{
  int size = min(WINDOW_WIDTH/cols,WINDOW_HEIGHT/rows);
  int[] out = {
    (WINDOW_WIDTH-size*cols)/2,
    (WINDOW_HEIGHT-size*rows)/2
  };

  return out;
}