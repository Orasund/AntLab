/*// 2D Array of objects
Cell[][] grid;
Cell[][] buffergrid;

// Number of columns and rows in the grid
int cols = 40;
int rows = 40;
int r;

void setup() {
  size(800,800);
  frameRate(4);
  noStroke();
  
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
      grid[i][j].action();
      buffergrid[i][j].display();
      grid[i][j].displayShadow();
    }
  }
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      buffergrid[i][j].copyCell();
    }
  }
  //grid = buffergrid;
  println("NEWLINE");
}*/