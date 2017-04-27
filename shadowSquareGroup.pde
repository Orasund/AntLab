/**
 * ShadowSquareGroup
 */
class ShadowSquareGroup extends Group<ShadowSquare>
{

  ShadowSquareGroup(World w, Board board) {
    super(w);

    int[][] grid = board.getGrid();
    int cols = grid.length;
    int rows = grid[0].length;

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        if(grid[i][j] != 2) //Ant
          continue;

        int[][] dir = {{0,-1},{1,0},{0,1},{-1,0}};
        
        /* finding empty spot */
        int x = i;
        int y = j;
        for(int k = 0; k < 4; k++)
        {
          int r = floor(random(4));
          int temp_x = (i + dir[r][0] + cols)%cols;
          int temp_y = (j + dir[r][1] + rows)%rows;

          int temp = grid[temp_x][temp_y];
          if(temp != 1) //Wall
          {
            x = temp_x;
            y = temp_y;
            break;
          }
        }

        if(x == i && y == j)
          continue;
        
        boolean c[] = new boolean[]{true,true,true};
        c[floor(random(3))] = false;
        int r = floor(random(2));
        if(c[r] == false)
          r++;
        c[r] = false;
          
        HRectangle shape = createSquareShape(x, y, cols, rows);
        ShadowSquare s = new ShadowSquare(shape,c,shape.getWidth());
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
    beings_counter += size();
  }
}