/**
 * ShadowGroup
 */
class ShadowGroup extends Group<Shadow>
{
  //int periode = floor(frameRate/2);
  //int frame;
  Board _board;

  ShadowGroup(World w, Board board)
  {
    super(w);
    _board = board;
    //frame = 0;
    readFromBoard();
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

  private void readFromBoard()
  {
    World w = getWorld();
    int[][] grid = _board.getGrid();

    int cols = grid.length;
    int rows = grid[0].length;

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        if(grid[i][j] != ANT_NUM) //Ant
          continue;

        boolean c[] = new boolean[]{true,true,true};
        c[floor(random(3))] = false;
        int r = floor(random(2));
        if(c[r] == false)
          r++;
        c[r] = false;
          
        HRectangle shape = createSquareShape(i, j, cols, rows);
        Shadow s = new Shadow(shape,c,shape.getWidth());
        w.register(s);
        add(s);
      }
  }

  public void update()
  {
    if(gameLoop.getFrame()==0)
    {
      destroy();
      readFromBoard();
    }

    beings_counter += size();
  }
}