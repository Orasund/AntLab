HRectangle createSquareShape(int x, int y, int cols, int rows)
{
  check(
    (cols > 0) &&
    (rows > 0) &&
    (x >= 0 && x<cols) &&
    (y >= 0 && y<rows)
  );

  int size = min(WINDOW_WIDTH/cols,WINDOW_HEIGHT/rows);
  int[] offset = calcOffset(cols, rows);
  int pos_x = size*x;
  int pos_y = size*y;

  check(
    (abs(offset[0]*2 + size*cols - WINDOW_WIDTH) < 1) &&
    (abs(offset[1]*2 + size*rows - WINDOW_HEIGHT) < 1)
  );

  return new HRectangle(offset[0]+pos_x, offset[1]+pos_y, size, size);
}

int[] calcOffset(int cols, int rows)
{
  int size = min(WINDOW_WIDTH/cols,WINDOW_HEIGHT/rows);
  int[] out = {
    (WINDOW_WIDTH-size*cols)/2,
    (WINDOW_HEIGHT-size*rows)/2
  };

  return out;
}