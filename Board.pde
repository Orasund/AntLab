class Board
{
  int[][] _grid;
  int[][] _buffer;
  int _cols;
  int _rows;

  Board(int cols, int rows)
  {
    _grid = new int[cols][rows];
    _buffer = new int[cols][rows];
    _cols = cols;
    _rows = rows;

    generateGrid();
  }

  private void generateGrid()
  {
    /************************
     * GRID
     ************************/
    for(int i = 0; i < _cols; i++)
      for(int j = 0; j < _rows; j++)
      {
        //                Wall, Ant
        float[] chances = {0.33,0.12};
        int type = randomFromPool(chances);

        _grid[i][j] = type;
        _buffer[i][j] = type;
      }
    
    /************************
     * BUFFER
     ************************/
    /*for(int i = 0; i < _cols; i++)
      for(int j = 0 ; j < _rows; j++)
      {
        if(_grid[i][j] != ANT_NUM)
          continue;
        
        int[] coords = findEmptySpace(i,j,_grid);

        if(coords[0] == i && coords[1] == j)
          continue;
        
        _buffer[i][j] = AIR_NUM;
        _buffer[coords[0]][coords[1]] = ANT_NUM;
      }*/
  }

  void update()
  {
    //set grid to buffer
    for(int i = 0; i < _cols; i++)
      for(int j = 0; j < _rows; j++)
        _grid[i][j] = _buffer[i][j];
  }

  void clear(int x, int y)
  {
    _buffer[x][y] = AIR_NUM;
  }

  boolean set(int x, int y, int type)
  {
    if(_buffer[x][y] != AIR_NUM)
      return false;
    _buffer[x][y] = type;
    return true;
  }

  int get(int x, int y)
  {
    return _grid[x][y];
  }

  int getCols()
  {
    return _grid.length;
  }

  int getRows()
  {
    return _grid[0].length;
  }

  int[][] getGrid()
  {
    int[][] out = new int[_grid.length][_grid[0].length];
    for(int i = 0; i < _grid.length; i++)
      for(int j = 0; j < _grid[0].length; j++)
        out[i][j] = _grid[i][j];
    return out;
  }

  int[][] getBuffer()
  {
    int[][] out = new int[_grid.length][_grid[0].length];
    for(int i = 0; i < _grid.length; i++)
      for(int j = 0; j < _grid[0].length; j++)
        out[i][j] = _buffer[i][j];
    return out;
  }
}