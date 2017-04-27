/**
 * ShadowSquareGroup
 */
class ShadowSquareGroup extends Group<ShadowSquare>
{

  ShadowSquareGroup(World w, int cols, int rows) {
    super(w);

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        boolean c[] = new boolean[3];
        for(int k = 0; k < 3; k++)
        {
          c[k] = boolean(floor(random(2)));
        }
          
        HRectangle shape = createSquareShape(i, j, cols, rows);
        ShadowSquare sh = new ShadowSquare(shape,c,shape.getWidth());
        w.register(sh);
        add(sh);
      }
  }

  private HRectangle createSquareShape(int x, int y, int cols, int rows)
  {
    check(
      (cols > 0) &&
      (rows > 0) &&
      (x >= 0 && x<cols) &&
      (y >= 0 && y<rows)
    );

    int size = min(WINDOW_WIDTH/cols,WINDOW_HEIGHT/rows);
    int offset_x = (WINDOW_WIDTH-size*cols)/2;
    int offset_y = (WINDOW_HEIGHT-size*rows)/2;
    int pos_x = size*x;
    int pos_y = size*y;

    check(
      (abs(offset_x*2 + size*cols - WINDOW_WIDTH) < 1) &&
      (abs(offset_y*2 + size*rows - WINDOW_HEIGHT) < 1)
    );

    return new HRectangle(offset_x+pos_x, offset_y+pos_y, size, size);
  }

  public void update()
  {
  }
}