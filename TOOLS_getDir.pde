int[][] getDir(int k)
{
  check(k >= 0 && k < 4);

  //int[][] dir = {{0,-1},{1,0},{0,1},{-1,0}};
  int mat[][][] = {
      {
        {1,0},
        {0,1}
      },
      {
        {0,-1},
        {1,0}
      },
      {
        {-1,0},
        {0,-1}
      },
      {
        {0,1},
        {-1,0}
      }
    };
  
  return mat[k];
}

int[] lookingAt(int k)
{
  int[][] dir = getDir(k);
  int[] view = {0,-1};
  int[] out = 
  {
    view[0]*dir[0][0]+view[1]*dir[0][1],
    view[0]*dir[1][0]+view[1]*dir[1][1]
  };
  return out;
}