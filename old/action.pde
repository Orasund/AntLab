void action(int x, int y)
{
  switch(map.getType(x,y))
  //buffergrid[x][y].type)
  {
    case 1:
      break;
    case 2:
      //ant.createFromCell(x, y);//,buffergrid);
      //int a = ant.getAction();
      Organism ant = map.getOrganism(x,y);
      int a = getAction(ant);
      switch(a)
      {
        case 2: //turn Right
          turnRight(x,y);//,buffergrid);
          break;
        case 1: //Walk
          walk(x,y);//,buffergrid);
          break;
        case 0:
        default:
          break;
      }
      break;
    case 0:
    default:
      break;
  }
}

/*void turnRight(int x, int y,Cell[][] buffergrid)
{
  turnRight(x,y);
}

void turnLeft(int x, int y,Cell[][] buffergid)
{
  turnLeft(x,y);
}*/

void turnRight(int x, int y)
{
  Organism ant = map.getOrganism(x,y);
  ant.dir = (ant.dir+2)%8;
  map.setOrganism(x,y,ant);
  //grid[x][y].turnRight();
}

void turnLeft(int x, int y)
{
  Organism ant = map.getOrganism(x,y);
  ant.dir = (ant.dir+6)%8;
  map.setOrganism(x,y,ant);
  //grid[x][y].turnLeft();
}

void walk(int x, int y)//,Cell[][] buffergrid)
{
  int directions[][] = {{0,-1},{1,0},{0,1},{-1,0}};
  int dir = floor(map.getOrganism(x,y).dir/2);
  //int dir = buffergrid[x][y].getDir();
  int temp_x = (x+directions[dir][0]+cols)%cols;
  int temp_y = (y+directions[dir][1]+rows)%rows;
  map.move(x,y,temp_x,temp_y);
  //grid[temp_x][temp_y].chanceToLife(x,y,buffergrid);
  //grid[x][y].chanceToAir();
}