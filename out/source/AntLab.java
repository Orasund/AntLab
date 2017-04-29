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
static final int ANT_NUM = 2;
static final int WALL_NUM = 1;
static final int AIR_NUM = 0;

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

  gameLoop = new GameLoop(floor(60));

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
/**
 * Ant
 */
class Ant extends Being
{ 
  private boolean[] _c; //Color
  private float _size;
  private int _d;       //Direction
  private int _x;
  private int _y;
  
  Ant(HShape shape, boolean[] b_c, float size, int x, int y)
  {
    super(shape);
    _c = new boolean[]{b_c[0],b_c[1],b_c[2]};
    _size = size;
    _d = floor(random(4));
    _x = x;
    _y = y;
  }

  public void update() {
  }

  public int[] getCoords()
  {
    int[] out = {_x,_y};
    return out;
  }

  public float getSize()
  {
    return _size;
  }

  public int getDirection()
  {
    return _d;
  }

  public boolean[] getColor()
  {
    boolean[] out = {_c[0],_c[1],_c[2]};
    return out;
  }

  public void turnLeft()
  {
    _d = (_d+1)%4;
  }

  public void draw()
  {
		noStroke();
    fill(generateColor(_c));
		_shape.draw();

    int[] dir = getDir(_d);
    int temp_size = floor(_size/4);
    int offset = floor(_size-temp_size)/2;
    int temp_x = temp_size*dir[0]*1;
    int temp_y = temp_size*dir[1]*1;
    fill(255);
    rect(offset+temp_x,offset+temp_y,temp_size,temp_size);
  }
}
/**
 * SquareGroup
 */
class AntGroup extends Group<Ant>
{
  Board _board;

  AntGroup(World w, Board board)
  {
    super(w);

    _board = board;

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
        Ant s = new Ant(shape,c,shape.getWidth(),i,j);
        w.register(s);
        add(s);
      }
  }

  public void walk(Ant ant)
  {
    int cols = _board.getCols();
    int rows = _board.getRows();

    int[] offset = calcOffset(cols,rows);
    int[] dir = getDir(ant.getDirection());
    int[] coords = ant.getCoords();
    float size = ant.getSize();
    int temp_x = (coords[0]+dir[0]+cols)%cols;
    int temp_y = (coords[1]+dir[1]+rows)%rows;
    
    if(_board.set(temp_x,temp_y,ANT_NUM) != false)
      return;

    ant.setPosition(offset[0]+size*temp_x,offset[1]+size*temp_y);

    _board.clear(coords[0],coords[1]);
  }

  public void update()
  {
    if(gameLoop.getFrame()==0)
    {
      int cols = _board.getCols();
      int rows = _board.getRows();

      ArrayList<Ant> ants = getObjects();

      int size = ants.size();
      for(int i = 0; i < size; i++)
      {
        Ant a = ants.get(i);
          
        int[] dir = getDir(a.getDirection());
        int[] coord = a.getCoords();
        int temp_x = floor(coord[0]+dir[0]+cols)%cols;
        int temp_y = floor(coord[1]+dir[0]+rows)%rows;

        if(_board.get(temp_x,temp_y) == AIR_NUM)
        {
          walk(a);
        }
        else
        {
          a.turnLeft();
        }
      }
    }
    gameLoop.update();

    beings_counter += size();
  }
}
/**
 * Background
 */
class Background extends Being
{ 
  Background()
  {
    super(new HRectangle(0,0,WINDOW_WIDTH,WINDOW_HEIGHT));
  }

  public void update()
  {
    beings_counter += 1;
  }

  public void draw()
  {
		noStroke();
    fill(255);
		_shape.draw();
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
    /************************
     * GRID
     ************************/
    for(int i = 0; i < _cols; i++)
      for(int j = 0; j < _rows; j++)
      {
        //                Wall, Ant
        float[] chances = {0.33f,0.12f};
        int type = randomFromPool(chances);

        _grid[i][j] = type;
        _buffer[i][j] = type;
      }
    
    /************************
     * BUFFER
     ************************/
    /*for(int i = 0; i < _cols; i++)
      for(int j = 0 ; j < _rows; j++)
      {
        if(_grid[i][j] != ANT_NUM)
          continue;
        
        int[] coords = findEmptySpace(i,j,_grid);

        if(coords[0] == i && coords[1] == j)
          continue;
        
        _buffer[i][j] = AIR_NUM;
        _buffer[coords[0]][coords[1]] = ANT_NUM;
      }*/
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
    _buffer[x][y] = AIR_NUM;
  }

  public boolean set(int x, int y, int type)
  {
    if(_buffer[x][y] != AIR_NUM)
      return false;
    _buffer[x][y] = type;
    return true;
  }

  public int get(int x, int y)
  {
    return _grid[x][y];
  }

  public int getCols()
  {
    return _grid.length;
  }

  public int getRows()
  {
    return _grid[0].length;
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
  private int _max;
  private int _frame;

  GameLoop(int max)
  {
    _frame = 0;
    _max = max;
  }

  public void update()
  {
    _frame = (_frame+1)%_max;
  }

  public int getFrame()
  {
    return _frame;
  }

  public int getMax()
  {
    return _max;
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

    Background background = new Background();
    register(background);
    WallGroup wallGroup = new WallGroup(this,board);
    register(wallGroup);
    AntGroup antGroup = new AntGroup(this,board);
    register(antGroup);
    ShadowGroup shadowGroup = new ShadowGroup(this,board);
    register(shadowGroup);
  }

  public void preUpdate()
  {
    beings_counter = 0; //for Debuging
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
    float max_size = _size/2;
    float multiplier = sin(((PI/2)*frame)/max);
    int temp_size = floor(max_size*multiplier);
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
  //int periode = floor(frameRate/2);
  //int frame;
  Board _board;

  ShadowGroup(World w, Board board)
  {
    super(w);
    _board = board;
    //frame = 0;
    readFromBoard();
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

  private void readFromBoard()
  {
    World w = getWorld();
    int[][] grid = _board.getBuffer();

    int cols = grid.length;
    int rows = grid[0].length;

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        if(grid[i][j] != ANT_NUM) //Ant
          continue;

        boolean c[] = new boolean[]{true,true,true};
        c[floor(random(3))] = false;
        int r = floor(random(2));
        if(c[r] == false)
          r++;
        c[r] = false;
          
        HRectangle shape = createSquareShape(i, j, cols, rows);
        Shadow s = new Shadow(shape,c,shape.getWidth());
        w.register(s);
        add(s);
      }
  }

  public void update()
  {
    if(gameLoop.getFrame()==0)
    {
      clear();
      readFromBoard();
    }

    beings_counter += size();
  }
}
public int[] findEmptySpace(int x, int y, int[][] grid)
{
  int cols = grid.length;
  int rows = grid[0].length;

  int[] out = {x,y};
  for(int k = 0; k < 4; k++)
  {
    int r = floor(random(4));
    int[] dir = getDir(r);

    int temp_x = (x + dir[0] + cols)%cols;
    int temp_y = (y + dir[1] + rows)%rows;

    int temp = grid[temp_x][temp_y];
    if(temp != WALL_NUM)
    {
      out[0] = temp_x;
      out[1] = temp_y;
      break;
    }
  }

  return out;
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
public int[] getDir(int k)
{
  check(k >= 0 && k < 4);

  int[][] dir = {{0,-1},{1,0},{0,1},{-1,0}};
  
  return dir[k];
}
public int randomFromPool(float[] chances)
{
  //---------------------------
  //- INPUT CONDITION
  //---------------------------
  float sum = 0;
  for(int i = 0; i < chances.length; i++)
  {
    check(chances[i]>=0 && chances[i]<1);
    sum += chances[i];
  }
  check(sum<1);

  //---------------------------
  //- FUNCTION
  //---------------------------
  float r = random(1);
  int out = 0;
  float chance = 0;
  for(int i = 0; i < chances.length; i++)
  {
    chance += chances[i];

    if(r<chance)
    {
      out = i+1;
      break;
    }
  }

  //---------------------------
  //- OUTPUT CONDITION
  //---------------------------
  check(out>=0 && out <= chances.length);

  return out;
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
class TemplateInteractor extends Interactor<Ant, Ant>
{
  TemplateInteractor()
  {
    super();
    //Add your constructor info here
  }

  public boolean detect(Ant being1, Ant being2)
  {
    //Add your detect method here
    return true;
  }

  public void handle(Ant being1, Ant being2)
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

  public void update()
  {
    
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
  int[] offset = calcOffset(cols, rows);
  int pos_x = size*x;
  int pos_y = size*y;

  check(
    (abs(offset[0]*2 + size*cols - WINDOW_WIDTH) < 1) &&
    (abs(offset[1]*2 + size*rows - WINDOW_HEIGHT) < 1)
  );

  return new HRectangle(offset[0]+pos_x, offset[1]+pos_y, size, size);
}

public int[] calcOffset(int cols, int rows)
{
  int size = min(WINDOW_WIDTH/cols,WINDOW_HEIGHT/rows);
  int[] out = {
    (WINDOW_WIDTH-size*cols)/2,
    (WINDOW_HEIGHT-size*rows)/2
  };

  return out;
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
