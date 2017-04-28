int[] getDir(int k)
{
  check(k >= 0 && k < 4);

  int[][] dir = {{0,-1},{1,0},{0,1},{-1,0}};
  
  return dir[k];
}