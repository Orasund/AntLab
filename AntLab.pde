// 2D Array of objects
Cell[][] grid;
Cell[][] buffergrid;

// Number of columns and rows in the grid
int cols = 40;
int rows = 40;
int r;

void setup() {
  size(800,800);
  frameRate(4);
  grid = new Cell[cols][rows];
  buffergrid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Initialize each object
      r = int(random(30));
      if(r == 0){ //alive
        grid[i][j] = new Cell(i,j,2);
        buffergrid[i][j] = new Cell(i,j,2);
      } else if(r < 10){ //dead
        grid[i][j] = new Cell(i,j,1);
        buffergrid[i][j] = new Cell(i,j,1);
      } else { //air
        grid[i][j] = new Cell(i,j,0);
        buffergrid[i][j] = new Cell(i,j,0);
      }
    }
  }
}

void draw() {
  background(0);
  // The counter variables i and j are also the column and row numbers and 
  // are used as arguments to the constructor for each object in the grid.  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // display each object
      grid[i][j].display();
      grid[i][j].action();
    }
  }
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      buffergrid[i][j].copyCell();
    }
  }
  //grid = buffergrid;
  println("NEWLINE");
}

// A Cell object
class Cell {
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
  Cell(int tempX, int tempY, int tempTyp) {
    x = tempX;
    y = tempY;
    //w = tempW;
    //h = tempH;
    typ = tempTyp;
    health = 100;
    u[0] = int(random(2));
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
  
  void algo1(){
    u[1]--;
    if(u[1]<0){u[1]=3;}
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
  
  void algo2(){
    u[1]--;
    if(u[1]<0){u[1]=3;}
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
            //u[1] += 2;
            if(u[1] >3){u[1]-=4;}
            turn();
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
              algo2();
              break;
          }
        }
        break;
      case 3: //fruit
        break;
    }
  }

  void display() {
    stroke(255);
    if(typ == 2){fill(team[u[0]]);} else {fill(c[typ]);}
    rect(x*width/cols,y*width/cols,width/cols,height/rows); 
  }
}
