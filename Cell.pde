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
    d = (d+1)%4;
  }
  
  void turnLeft()
  {
    d = (d+3)%4;
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
  
  //**********************
  // GET - Functions
  //**********************
  
  /*public int[] getCoords()
  {
    int[] out = {x,y};
    return out;
  }*/
  
  public boolean[] getColor()
  {
    boolean[] out = {c[0],c[1],c[2]};
    return out;
  }
  
  public int getDir(){return d;}
  public int getType(){return type;}
  public int getHealth(){return health;}
}

/*
// A Cell object
class Cell_old {
  // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
  int x,y,i,j;   // x,y location
  int typ;
  color[] c = {color(255, 255, 255),color(0, 0, 0),color(0, 255, 0),color(255,0,0)};
  color[] team = {color(0, 255, 0),color(0, 0, 255)};
  int health;
  //int[] u = 0-team;1-direction
  int[] u = {0,0};
  int[] p = {0,0,0,0,0};

  // Cell Constructor
  Cell_old(int tempX, int tempY, int tempTyp) {
    x = tempX;
    y = tempY;
    //w = tempW;
    //h = tempH;
    typ = tempTyp;
    health = 100;
    //u[0] = int(random(2));
    u[0] = 0;
  }
  
  void copyCell(){
    grid[x][y].typ = typ;
    grid[x][y].health = health;
    grid[x][y].u = u;
  }
  
  void move(){
    if(buffergrid[i][j].typ == 0){
      buffergrid[i][j].typ = 2;
      buffergrid[x][y].typ = 0;
      buffergrid[i][j].health = health-1;
      buffergrid[i][j].u = u;
      buffergrid[i][j].p = p;
      println("MOVE:" + x + y + " LEBEN:" + buffergrid[x][y].health);
    }
  }
  
  void create(){
    if(buffergrid[i][j].typ == 0 && health >5){
      health -= 5;
      buffergrid[i][j].typ = 2;
      buffergrid[i][j].u = u;
      buffergrid[i][j].p = p;
      buffergrid[i][j].health = floor(health/2);
      buffergrid[x][y].health = floor(health/2);
    }
  }
  
  void eat(){
    if(buffergrid[i][j].typ == 3){
      buffergrid[i][j].typ = 2;
      buffergrid[i][j].u = u;
      buffergrid[i][j].p = p;
      buffergrid[x][y].typ = 0;
      buffergrid[i][j].health = health+50;
    }
  }
  
  void attack(){
    if(buffergrid[i][j].typ == 2){
      if(buffergrid[i][j].health >= health){//verloren
        buffergrid[i][j].health += floor(health/2);
        buffergrid[x][y].typ = 0;
      } else {//gewonnen
        health += floor(buffergrid[i][j].health/2);
        buffergrid[i][j].health = health;
        buffergrid[i][j].u = u;
        buffergrid[i][j].p = p;
        buffergrid[x][y].typ = 0;
      }
    }
  }
  
  void turn(){
    switch(u[1]){
       case 0:
         if(x+1 < cols){i = x+1;}else{i = 0;}
         j = y;
         break;
       case 1:
         if(y-1 >= 0){j = y-1;}else{j = rows-1;}
         i = x;
         break;
       case 2:
         if(x-1 >= 0){i = x-1;}else{i = cols-1;}
         j = y;
         break;
       case 3:
       default:
         if(y+1 < rows){j = y+1;}else{j = 0;}
         i = x;
         break;
    }
  }
  
  int[] getNeighbours()
  {
    int[] out = new int[4];
    for(int i = 0; i<4; i++)
    {
      out[i] = grid[i][j].typ;
      turn();
    }
    return out;
  }
  
  void algo1(){
    //u[1]--;
    //if(u[1]<0){u[1]=3;}
    u[1]=(u[1]+3)%4;
    turn();
    if(buffergrid[i][j].typ != 3){
      u[1]++;
      if(u[1] >3){u[1]-=4;}
      turn();
      if(buffergrid[i][j].typ != 3){
        u[1]++;
        if(u[1] >3){u[1]-=4;}
        turn();
        if(buffergrid[i][j].typ != 3){
          u[1]++;
          if(u[1] >3){u[1]-=4;}
          turn();
          if(buffergrid[i][j].typ != 3){
            u[1] += 1+int(random(3));
            //u[1]++;
            if(u[1]>3){u[1]-=4;}
            turn();
            if(buffergrid[i][j].typ == 1){
              u[1]++;
              if(u[1] >3){u[1]-=4;}
              turn();
              if(buffergrid[i][j].typ == 1){
                u[1]++;
                if(u[1] >3){u[1]-=4;}
                turn();
                if(buffergrid[i][j].typ == 1){
                  u[1]++;
                  if(u[1] >3){u[1]-=4;}
                  turn();
                  if(buffergrid[i][j].typ == 1){
                    u[1] += 1+int(random(3));
                    //u[1] += 2;
                    if(u[1] >3){u[1]-=4;}
                    turn();
                  }
                }
              }
            }
          }
        }
      }
    }
    switch(buffergrid[i][j].typ){
      case 0:
        if(health>100){create();}
        else if(health<20 && health >5){create();}
        else {move();}
        break;
      case 2:
        if(buffergrid[i][j].health < health){attack();}
        break;
      case 3:
        eat();
        break;
    }
  }
  
  void algoWrapper()
  {
    algo2();
  }
  
  void algo2()
  {
    
    
    u[1]=(u[1]+3)%4;
    turn();
    for(int k=3; grid[i][j].typ != 3 && k>=0;k--)
    {
      if(k==0)
      {
        u[1] = (u[1]+1+int(random(3)))%4;
        //if(u[1] >3){u[1]-=4;}
        turn();
        break;
      }
      
      u[1]=(u[1]+1)%4;
      turn();
    }
    
    
    switch(grid[i][j].typ){
      case 0:
        if(health>100)
        {
          create();
          return;
        }
        else if(health<20 && health >5)
        {
          create();
          return;
        }
        move();
        break;
      case 2:
        if(grid[i][j].health < health)
        {
          attack();
          return;
        }
        break;
      case 3:
        eat();
        break;
    }
  }
  
  // action
  void action() {
    switch(typ){
      case 0: //air
        break;
      case 1: //dead
        r = int(random(400));
        if(r==0){buffergrid[x][y].typ = 3;}
        break;
      case 2: //alive
        if(health <= 0){
          buffergrid[x][y].typ = 1;
        } else {
          switch(u[0]){
            case 0:
              algo1();
              break;
            case 1:
              algoWrapper();
              //algo2();
              break;
          }
        }
        break;
      case 3: //fruit
        break;
    }
  }
  
  void displayShadow()
  {
    display(width/(cols*2));
  }
  
  void display()
  {
    display(width/cols);
  }

  void display(int size) {
    if(typ == 2)
      fill(team[u[0]]);
    else
      fill(c[typ]);
    
    int w = width/cols;
    int h = height/rows;
    int offset = w-size;
    rect(x*w+offset/2,y*h+offset/2,size,size); 
  }
}*/