class Cell
{
  //private int x; //x-coord
  //private int y; //y-coord
  private int d; //direction
  private boolean[] c; //color
  private int type;
  private int health;

  /*** OLD **/
  /*Cell(int x_, int y_, int type_)
  {
    generate(type_)
  }*/

  Cell()
  {
    float r = random(30);
    if(r < 1)
      generate(2);//alive
    else if(r < 10)
      generate(1);//dead
    else
      generate(0);//air
  }

  Cell(int type_)
  {
    generate(type);
  }

  void generate(int type_)
  {
    type = type_;
    
    d = floor(random(4)*2);
    health = 100;
    c = new boolean[3];
    boolean[][] c_types;
    c_types = new boolean[][]{
      {true, true, true}, //Air
      {false, false, false}, //Wall
      {false, true, false} //Alive
    };
    for(int i = 0; i<3; i++) //default color: black
      c[i] = c_types[type][i];
  }

  Cell copy()
  {
    Cell out = new Cell(d,c,type,health);
    return out;
  }

  //Copy-Contructor
  Cell(int d_,boolean[] c_,int type_,int health_)
  {
    d = d_;
    type = type_;
    health = health_;
    c = new boolean[3];
    for(int i = 0; i <3; i++)
    c[i] = c_[i];
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

  void turnRight()
  {
    d = (d+2)%8;
  }
  
  void turnLeft()
  {
    d = (d+6)%8;
  }

  void chanceFromOrganism(Organism life)
  {
    d = life.dir;
    c[0] = life.c[0];
    c[1] = life.c[1];
    c[2] = life.c[2];
    type = 2;//life.type;
    health = life.health;
  }

  void chanceToLife(int x, int y,Cell[][] buffergrid)
  {
    d = buffergrid[x][y].getDir();
    c = buffergrid[x][y].getColor();
    type = buffergrid[x][y].getType();
    health = buffergrid[x][y].getHealth();
  }

  void chanceToAir()
  {
    d = 0;
    c[0] = true;
    c[1] = true;
    c[2] = true;
    type = 0;
    health = 100;
  }

  void display(int x, int y, int size)
  {
    fill(generateColor());
    int offset = S-size;
    rect(x*S+offset/2,y*S+offset/2,size,size); 
  }

  void displayEye(int x, int y, int size)
  {
    int[][] dir = {{0,-1},{1,0},{0,1},{-1,0}};
    fill(255);
    int offset = S-size;
    rect(x*S+offset/2+dir[floor(d/2)][0]*size,y*S+offset/2+dir[floor(d/2)][1]*size,size,size); 
  }
  
  //**********************
  // GET - Functions
  //**********************
  
  public boolean[] getColor()
  {
    boolean[] out = {c[0],c[1],c[2]};
    return out;
  }
  
  public int getDir(){return d;}
  public int getType(){return type;}
  public int getHealth(){return health;}
}