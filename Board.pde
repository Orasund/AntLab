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
    for(int i = 0; i < _cols; i++)
      for(int j = 0; j < _rows; j++)
      {
        int type = 0;

        switch(floor(random(6)))
        {
          case 0: //Ant
            type = 2;
            break;
          case 1: //Wall
          case 2:
            type = 1;
            break;
          default://Air
            break;
        }

        _grid[i][j] = type;
        _buffer[i][j] = type;
      }
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
    _buffer[x][y] = 0;
  }

  boolean set(int x, int y, int type)
  {
    if(_buffer[x][y] != 0)
      return false;
    _buffer[x][y] = type;
    return true;
  }

  int get(int x, int y)
  {
    return _buffer[x][y];
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