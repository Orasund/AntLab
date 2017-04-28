/**
 * SquareGroup
 */
class AntGroup extends Group<Ant>
{
  Board _board;

  AntGroup(World w, Board board)
  {
    super(w);

    _board = board;

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
        Ant s = new Ant(shape,c,shape.getWidth(),i,j);
        w.register(s);
        add(s);
      }
  }

  public void update()
  {
    int cols = _board.getCols();
    int rows = _board.getRows();

    ArrayList<Ant> ants = getObjects();

    int size = ants.size();
    for(int i = 0; i < size; i++)
    {
      Ant a = ants.get(i);
        
      int[] dir = getDir(a.getDirection());
      int[] coord = a.getCoords();
      int temp_x = floor(coord[0]+dir[0]+cols)%cols;
      int temp_y = floor(coord[1]+dir[0]+rows)%rows;

      if(_board.get(temp_x,temp_y) == 0)
      {
        _board.set(temp_x,temp_y,ANT_NUM);
        a.walk(cols,rows);

        _board.clear(coord[0],coord[1]);
      }
      else
      {
        a.turnLeft();
      }
    }
    beings_counter += size();
  }
}