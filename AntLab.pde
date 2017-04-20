// 2D Array of objects
Cell[][] grid;

// Number of columns and rows in the grid
int cols = 40;
int rows = 40;
int H,W;  //height, Width
int S; //Size of a Cell
int r; //random

void setup() {
  size(800,800);
  frameRate(4);
  noStroke();

  H = height;
  W = width;
  S = max(H/cols,W/rows);
  
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = new Cell();
    }
  }
}

void draw() {
  background(0);

  Cell[][] buffergrid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++)
    for (int j = 0; j < rows; j++)
      buffergrid[i][j] = grid[i][j].copy();
  
  for (int i = 0; i < cols; i++)
    for (int j = 0; j < rows; j++)
      action(i,j);

  render(buffergrid);
}