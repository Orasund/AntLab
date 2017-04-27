/**
 * SquareGroup
 */
class SquareGroup extends Group<Square>
{

  SquareGroup(World w, Board board)
  {
    super(w);

    int[][] grid = board.getGrid();
    int cols = grid.length;
    int rows = grid[0].length;

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        boolean c[] = new boolean[]{true,true,true};
        switch(grid[i][j])
        {
          case 2: //Ant
            c[floor(random(3))] = false;
            int r = floor(random(2));
            if(c[r] == false)
              r++;
            c[r] = false;
            break;
          default://Air
            continue;
        }
          
        HRectangle shape = createSquareShape(i, j, cols, rows);
        Square s = new Square(shape,c,shape.getWidth());
        w.register(s);
        add(s);
      }
  }

  public void update()
  {
    beings_counter += size();
  }
}