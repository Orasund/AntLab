/**
 * WallGroup
 */
class WallGroup extends Group<Wall>
{

  WallGroup(World w, Board board)
  {
    super(w);

    int[][] grid = board.getGrid();
    int cols = grid.length;
    int rows = grid[0].length;

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        if(grid[i][j] != 1)
          continue;
          
        HRectangle shape = createSquareShape(i, j, cols, rows);
        Wall s = new Wall(shape,shape.getWidth());
        w.register(s);
        add(s);
      }
  }

  public void update()
  {
    beings_counter += size();
  }
}