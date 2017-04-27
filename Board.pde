/**
 * Board
 * the playing board
 */
class Board extends Group<Square>
{

  Board(World w, int cols, int rows)
  {
    super(w);

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        boolean c[] = new boolean[]{true,true,true};
        switch(floor(random(6)))
        {
          case 0: //Ant
            c[floor(random(3))] = false;
            int r = floor(random(2));
            if(c[r] == false)
              r++;
            c[r] = false;
            break;
          case 1: //Wall
          case 2:
            c[0] = false;
            c[1] = false;
            c[2] = false;
            break;
          default://Air
            break;
        }
          
        HRectangle shape = createSquareShape(i, j, cols, rows);
        Square s = new Square(shape,c,shape.getWidth());
        w.register(s);
        add(s);
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