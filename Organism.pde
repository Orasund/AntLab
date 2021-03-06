class Organism
{
  boolean[] c;
  boolean[][] sight;
  int health;
  int dir;
  /*final int idle = 0;
  final int walk = 1;
  final int turn_r = 2;
  final int turn_l = 3;*/
  Organism(int x, int y,Cell[][] buffergrid)
  {
    createFromCell(x, y, buffergrid);
    //createFromCell(0,0,grid);
  }

  private color generateColor()
  {
    color[][][] colors = 
    {
      {//RED = FALSE
        {color(0,0,0),color(0,0,255)},//GREEN = FALSE
        {color(0,255,0),color(0,255,255)}
      },
      {
        {color(255,0,0),color(255,0,255)},//GREEN = FALSE
        {color(255,255,0),color(255,255,255)}
      }
    };
    return colors[int(c[0])][int(c[1])][int(c[2])];
  }

  void display(int x, int y, int size)
  {
    fill(generateColor());
    int offset = S-size;
    rect(x*S+offset/2,y*S+offset/2,size,size); 
  }

  void createFromCell(int x, int y,Cell[][] buffergrid)
  {
    c = buffergrid[x][y].getColor();
    health = buffergrid[x][y].getHealth();
    dir = buffergrid[x][y].getDir();
    sight = getSight(x,y,buffergrid);

  }

  /*
  * returns: [mid,left,right]
  */
  boolean[][] getSight(int x, int y, Cell[][] buffergrid)
  {
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
    
    int[][] eyes = {{0,-1},{-1,-1},{1,-1}};
    int[] pos = new int[2];
    boolean[][] out = new boolean[4][3];
    for(int i=0;i<eyes.length;i++)
    {
      int rel_x = eyes[i][0]*mat[floor(dir/2)][0][0]+eyes[i][1]*mat[floor(dir/2)][0][1];
      pos[0] = (x+rel_x+cols)%cols;
      int rel_y = eyes[i][0]*mat[floor(dir/2)][1][0]+eyes[i][1]*mat[floor(dir/2)][1][1];
      pos[1] = (y+rel_y+rows)%rows;
      out[i] = buffergrid[pos[0]][pos[1]].getColor();
    }
    return out;
  }
}