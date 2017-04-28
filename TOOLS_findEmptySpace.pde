int[] findEmptySpace(int x, int y, int[][] grid)
{
  int[][] dir = {{0,-1},{1,0},{0,1},{-1,0}};

  int cols = grid.length;
  int rows = grid[0].length;

  int[] out = {x,y};
  for(int k = 0; k < 4; k++)
  {
    int r = floor(random(4));
    int temp_x = (x + dir[r][0] + cols)%cols;
    int temp_y = (y + dir[r][1] + rows)%rows;

    int temp = grid[temp_x][temp_y];
    if(temp != WALL_NUM)
    {
      out[0] = temp_x;
      out[1] = temp_y;
      break;
    }
  }

  return out;
}