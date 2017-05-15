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

  public int[] getEyes(Ant ant)
  {
    int[] out = new int[3];

    int[][] eyes = {{0,-1},{-1,0},{1,0}};

    int[] temp_coords = getTempCoords(ant);
    out[0] = _board.get(temp_coords[0],temp_coords[1]);
    out[1] = out[0];
    out[2] = out[0];
    return out;
  }

  public int[] getTempCoords(Ant ant)
  {
    int cols = _board.getCols();
    int rows = _board.getRows();
    int[] dir = lookingAt(ant.getDirection());
    int[] coords = ant.getCoords();
    int[] temp_coords =
    {
      (coords[0]+dir[0]+cols)%cols,
      (coords[1]+dir[1]+rows)%rows
    };
    
    return temp_coords;
  }

  public void walk(Ant ant)
  {
    int cols = _board.getCols();
    int rows = _board.getRows();

    int[] offset = calcOffset(cols,rows);
    int[] coords = ant.getCoords();
    float size = ant.getSize();
    int[] temp_coords = getTempCoords(ant);

    if(_board.set(temp_coords[0],temp_coords[1],ANT_NUM) == false)
      return;

    ant.setCoords(temp_coords,offset);

    _board.clear(coords[0],coords[1]);
  }

  public void update()
  {
    if(gameLoop.getFrame()==0)
    {
      ArrayList<Ant> ants = getObjects();

      int size = ants.size();
      for(int i = 0; i < size; i++)
      {
        Ant a = ants.get(i);
          
        //int[] temp_coords = getTempCoords(a);

        int[] eyes = getEyes(a);

        //if(_board.get(temp_coords[0],temp_coords[1]) == AIR_NUM)
        if(eyes[0] == AIR_NUM)
        {
          walk(a);
        }
        else
        {
          a.turnLeft();
        }
      }

      _board.update();
    }
   

    beings_counter += size();
  }
}