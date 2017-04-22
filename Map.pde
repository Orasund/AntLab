class Map
{
  /*int[][] grid;
  int[][] buffer;
  Arraylist<Organism> organisms;*/
  private Cell[][] grid;
  private Cell[][] buffer;

  Map(int cols, int rows)
  {
    /*organisms = new Arraylist<Organism>;
    int[][] grid = new int[cols][rows];
    int[][] buffer = new int[cols][rows];*/
    grid = new Cell[cols][rows];
    buffer = new Cell[cols][rows];
    for(int i = 0; i < cols; i++)
      for(int j = 0; j < rows; j++)
      {
        grid[i][j] = new Cell();
        buffer[i][j] = grid[i][j].copy();
      }
  }

  /*******************
  * F U N C T I O N S
  ********************/

  void update()
  {
    //set grid to buffer
    for(int i = 0; i < cols; i++)
      for(int j = 0; j < rows; j++)
      grid[i][j] = buffer[i][j].copy();
  }

  Organism getOrganism(int x, int y)
  {
    Organism out = new Organism(x, y,grid);
    //out.createFromCell(x, y,grid);
    return out;
  }

  void setOrganism(int x, int y, Organism life)
  {
    buffer[x][y].chanceFromOrganism(life);
  }

  int getType(int x, int y)
  {
    return grid[x][y].getType();
  }

  boolean[] getColor(int x, int y)
  {
    return grid[x][y].getColor();
  }

  boolean move(int x1, int y1, int x2, int y2)
  {
    if(
      buffer[x1][y1].getType() != grid[x1][y1].getType() || 
      buffer[x2][y2].getType() != 0
    )
      return false;

    buffer[x2][y2] = grid[x1][y1].copy();
    setEmpty(x1,y1);
    return true;
  }

  void setEmpty(int x, int y)
  {
    buffer[x][y].chanceToAir();
  }

  void display()
  {
    for (int i = 0; i < cols; i++)
      for (int j = 0; j < rows; j++)
      {
        buffer[i][j].display(i,j,S);
      }
    for (int i = 0; i < cols; i++)
      for (int j = 0; j < rows; j++)
      {
        grid[i][j].display(i,j,S/2);
      }
  }
}