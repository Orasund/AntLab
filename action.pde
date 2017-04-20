void action(int x, int y)
{
  switch(cell[x][y].type)
  {
    case 1:
      break;
    case 2:
      int[][] sight = getSight(int x, int y);
      Ant.getAction(sight,cell[x][y])
      break;
    case 0:
    default:
      break;
  }
}

/*
* returns: [mid,left,right]
*/
int[][] getSight(int x, int y)
{
  int[][] eyes = {{0,-1},{-1,-2},{1,-2}}
  int[] pos = new int[2];
  int[][] out = new int[4][3];
  for(int i=0;i<4;i++)
  {
    pos[0] = (eyes[i][0]+cols+x)%cols;
    pos[1] = (eyes[i][1]+rows+y)%rows;
    out[i] = grid[pos[0]][pos[1]].getColor();
  }
  return out;
}