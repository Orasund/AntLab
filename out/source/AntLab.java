import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import hermes.*; 
import hermes.hshape.*; 
import hermes.animation.*; 
import hermes.physics.*; 
import hermes.postoffice.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AntLab extends PApplet {

/**
 * A template to get you started
 * Define your beings, groups, interactors and worlds in separate tabs
 * Put the pieces together in this top-level file!
 */







///////////////////////////////////////////////////
// CONSTANTS
///////////////////////////////////////////////////
/**
 * Constants should go up here
 * Making more things constants makes them easier to adjust and play with!
 */
static int WINDOW_WIDTH;// = 600;
static int WINDOW_HEIGHT; //= 600;
static final int PORT_IN = 8080;
static final int PORT_OUT = 8000;

int beings_counter = 0;

World currentWorld;
GameLoop gameLoop;

///////////////////////////////////////////////////
// PAPPLET
///////////////////////////////////////////////////

public void setup() {
  
  WINDOW_WIDTH = width;
  WINDOW_HEIGHT = height;
  Hermes.setPApplet(this);

  gameLoop = new GameLoop(floor(frameRate*8));

  currentWorld = new MapWorld(PORT_IN, PORT_OUT);       

  currentWorld.start(); // this should be the last line in setup() method
}

public void draw() {
  try
  {
    currentWorld.draw();
  }
  catch (Exception e)
  {
    println(e.getMessage());
    e.printStackTrace();
  }
}
class Board
{
  int[][] _grid;
  int[][] _buffer;
  int _cols;
  int _rows;

  Board(int cols, int rows)
  {
    _grid = new int[cols][rows];
    _buffer = new int[cols][rows];
    _cols = cols;
    _rows = rows;

    generateGrid();
  }

  private void generateGrid()
  {
    for(int i = 0; i < _cols; i++)
      for(int j = 0; j < _rows; j++)
      {
        int type = 0;

        switch(floor(random(6)))
        {
          case 0: //Ant
            type = 2;
            break;
          case 1: //Wall
          case 2:
            type = 1;
            break;
          default://Air
            break;
        }

        _grid[i][j] = type;
        _buffer[i][j] = type;
      }
  }

  public void update()
  {
    //set grid to buffer
    for(int i = 0; i < _cols; i++)
      for(int j = 0; j < _rows; j++)
        _grid[i][j] = _buffer[i][j];
  }

  public void clear(int x, int y)
  {
    _buffer[x][y] = 0;
  }

  public boolean set(int x, int y, int type)
  {
    if(_buffer[x][y] != 0)
      return false;
    _buffer[x][y] = type;
    return true;
  }

  public int get(int x, int y)
  {
    return _buffer[x][y];
  }

  public int[][] getGrid()
  {
    int[][] out = new int[_grid.length][_grid[0].length];
    for(int i = 0; i < _grid.length; i++)
      for(int j = 0; j < _grid[0].length; j++)
        out[i][j] = _grid[i][j];
    return out;
  }

  public int[][] getBuffer()
  {
    int[][] out = new int[_grid.length][_grid[0].length];
    for(int i = 0; i < _grid.length; i++)
      for(int j = 0; j < _grid[0].length; j++)
        out[i][j] = _buffer[i][j];
    return out;
  }
}
class GameLoop
{
  int _max_frames;
  int _frame;

  GameLoop(int max)
  {
    _frame = 0;
    _max_frames = max;
  }

  public void update()
  {
    _frame = (_frame+1)%_max_frames;
  }

  public int getFrame()
  {
    return _frame;
  }

  public int getMax()
  {
    return _max_frames;
  }
}
/**
 * MapWorld
 * You'll need to add stuff to setup().
 */
class MapWorld extends World
{
  MapWorld(int portIn, int portOut)
  {
    super(portIn, portOut);
  }

  public void setup()
  {
    int cols = 20;
    int rows = 20;

    Board board = new Board(cols,rows);

    WallGroup wallGroup = new WallGroup(this,board);
    register(wallGroup);
    SquareGroup squareGroup = new SquareGroup(this,board);
    register(squareGroup);
    ShadowGroup shadowGroup = new ShadowGroup(this,board);
    register(shadowGroup);
  }

  public void preUpdate()
  {
    beings_counter = 0;

    gameLoop.update();
  }

  public void postUpdate()
  {
    println("POSTUPDATE: "+beings_counter+" Beings exist.");
  }
}
/**
 * shadowSquare
 */
class Shadow extends Being
{ 
  boolean[] _dot_color;
  boolean _is_dot_visible;
  float _size;
  
  Shadow(HShape shape, boolean[] d_c, float size)
  {
    super(shape);
    _dot_color = new boolean[]{d_c[0],d_c[1],d_c[2]};
    _is_dot_visible = true;
    _size = size;
  }

  public void update()
  {
  }

  public void draw()
  {
    int max = gameLoop.getMax();
    int frame = gameLoop.getFrame()+1;
    int temp_size = floor(_size/2*sin((PI*max)/(2*frame)));
    int offset = floor(_size - temp_size)/2;
		noStroke();
    fill(generateColor(_dot_color));
    rect(offset,offset,temp_size,temp_size);
  }
}
/**
 * ShadowGroup
 */
class ShadowGroup extends Group<Shadow>
{
  int periode = floor(frameRate/2);
  int frame;

  ShadowGroup(World w, Board board) {
    super(w);

    frame = 0;

    int[][] grid = board.getGrid();
    int cols = grid.length;
    int rows = grid[0].length;

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        if(grid[i][j] != 2) //Ant
          continue;

        int[][] dir = {{0,-1},{1,0},{0,1},{-1,0}};
        
        /* finding empty spot */
        int x = i;
        int y = j;
        for(int k = 0; k < 4; k++)
        {
          int r = floor(random(4));
          int temp_x = (i + dir[r][0] + cols)%cols;
          int temp_y = (j + dir[r][1] + rows)%rows;

          int temp = grid[temp_x][temp_y];
          if(temp != 1) //Wall
          {
            x = temp_x;
            y = temp_y;
            break;
          }
        }

        if(x == i && y == j)
          continue;
        
        boolean c[] = new boolean[]{true,true,true};
        c[floor(random(3))] = false;
        int r = floor(random(2));
        if(c[r] == false)
          r++;
        c[r] = false;
          
        HRectangle shape = createSquareShape(x, y, cols, rows);
        Shadow s = new Shadow(shape,c,shape.getWidth());
        w.register(s);
        add(s);
      }
  }

  private HRectangle createSquareShape(int x, int y, int cols, int rows)
  {
    check(
      (cols > 0) &&
      (rows > 0) &&
      (x >= 0 && x<cols) &&
      (y >= 0 && y<rows)
    );

    int size = min(WINDOW_WIDTH/cols,WINDOW_HEIGHT/rows);
    int offset_x = (WINDOW_WIDTH-size*cols)/2;
    int offset_y = (WINDOW_HEIGHT-size*rows)/2;
    int pos_x = size*x;
    int pos_y = size*y;

    check(
      (abs(offset_x*2 + size*cols - WINDOW_WIDTH) < 1) &&
      (abs(offset_y*2 + size*rows - WINDOW_HEIGHT) < 1)
    );

    return new HRectangle(offset_x+pos_x, offset_y+pos_y, size, size);
  }

  public void update()
  {
  }
}
/**
 * Square
 * the Square is part of the gameboard
 */
class Square extends Being
{ 
  boolean[] _c;
  float _size;
  
  Square(HShape shape, boolean[] b_c, float size)
  {
    super(shape);
    _c = new boolean[]{b_c[0],b_c[1],b_c[2]};
    _size = size;
  }

  public void update() {
    // Add update method here
  }

  public void draw()
  {
		noStroke();
    fill(generateColor(_c));
		_shape.draw();
  }
}
/**
 * SquareGroup
 */
class SquareGroup extends Group<Square>
{

  SquareGroup(World w, Board board)
  {
    super(w);

    int[][] grid = board.getGrid();
    int cols = grid.length;
    int rows = grid[0].length;

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        boolean c[] = new boolean[]{true,true,true};
        switch(grid[i][j])
        {
          case 2: //Ant
            c[floor(random(3))] = false;
            int r = floor(random(2));
            if(c[r] == false)
              r++;
            c[r] = false;
            break;
          default://Air
            continue;
        }
          
        HRectangle shape = createSquareShape(i, j, cols, rows);
        Square s = new Square(shape,c,shape.getWidth());
        w.register(s);
        add(s);
      }
  }

  public void update()
  {
    beings_counter += size();
  }
}
/**
 * Template being
 */
class TemplateBeing extends Being {
  TemplateBeing(HShape shape) {
    super(shape);
    //Add your constructor info here
  }

  public void update() {
    // Add update method here
  }

  public void draw() {
    // Add your draw method here
  }
}
/**
 * Template interactor between a TemplateBeing and another TemplateBeing
 * Don't forget to change TemplateBeing-s to
 * the names of the Being-types you want to interact
 */
class TemplateInteractor extends Interactor<Square, Square>
{
  TemplateInteractor()
  {
    super();
    //Add your constructor info here
  }

  public boolean detect(Square being1, Square being2)
  {
    //Add your detect method here
    return true;
  }

  public void handle(Square being1, Square being2)
  {
    //Add your handle method here
  }
}
/**
 * Wall
 */
class Wall extends Being
{ 
  boolean[] _c = {false,false,false};
  float _size;
  
  Wall(HShape shape, float size)
  {
    super(shape);
    _size = size;
  }

  public void update() {
    // Add update method here
  }

  public void draw()
  {
		noStroke();
    fill(generateColor(_c));
		_shape.draw();
  }
}
/**
 * WallGroup
 */
class WallGroup extends Group<Wall>
{

  WallGroup(World w, Board board)
  {
    super(w);

    int[][] grid = board.getGrid();
    int cols = grid.length;
    int rows = grid[0].length;

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        if(grid[i][j] != 1)
          continue;
          
        HRectangle shape = createSquareShape(i, j, cols, rows);
        Wall s = new Wall(shape,shape.getWidth());
        w.register(s);
        add(s);
      }
  }

  public void update()
  {
    beings_counter += size();
  }
}
public void check(boolean argument)
{
  if(argument == false)
    throw new RuntimeException("CheckingError");
}
public HRectangle createSquareShape(int x, int y, int cols, int rows)
{
  check(
    (cols > 0) &&
    (rows > 0) &&
    (x >= 0 && x<cols) &&
    (y >= 0 && y<rows)
  );

  int size = min(WINDOW_WIDTH/cols,WINDOW_HEIGHT/rows);
  int offset_x = (WINDOW_WIDTH-size*cols)/2;
  int offset_y = (WINDOW_HEIGHT-size*rows)/2;
  int pos_x = size*x;
  int pos_y = size*y;

  check(
    (abs(offset_x*2 + size*cols - WINDOW_WIDTH) < 1) &&
    (abs(offset_y*2 + size*rows - WINDOW_HEIGHT) < 1)
  );

  return new HRectangle(offset_x+pos_x, offset_y+pos_y, size, size);
}
public int generateColor(boolean c[])
{
  int[][][] colors = 
  {
    {//RED = FALSE
      {//GREEN = FALSE
        color(0,0,0), //BLACK
        color(64, 48, 117) //BLUE
      },
      {
        color(45, 136, 45), //GREEN
        color(41, 79, 109) //GREEN-BLUE
      }
    },
    {
      {
        color(170, 57, 57), //RED
        color(111, 37, 111) //RED-BLUE
      },//GREEN = FALSE
      {
        color(170, 151, 57), //RED-GREEN
        color(255,255,255) //WHITE
      }
    }
  };

  return colors[PApplet.parseInt(c[0])][PApplet.parseInt(c[1])][PApplet.parseInt(c[2])];
}
  public void settings() {  size(600, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AntLab" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
