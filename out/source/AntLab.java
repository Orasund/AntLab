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

World currentWorld;

///////////////////////////////////////////////////
// PAPPLET
///////////////////////////////////////////////////

public void setup() {
  
  WINDOW_WIDTH = width;
  WINDOW_HEIGHT = height;
  Hermes.setPApplet(this);

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
 * Board
 * the playing board
 */
class Board extends Group<Square>
{

  Board(World w, int cols, int rows)
  {
    super(w);

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        boolean c[] = new boolean[]{true,true,true};
        switch(floor(random(6)))
        {
          case 0: //Ant
            c[floor(random(3))] = false;
            int r = floor(random(2));
            if(c[r] == false)
              r++;
            c[r] = false;
            break;
          case 1: //Wall
          case 2:
            c[0] = false;
            c[1] = false;
            c[2] = false;
            break;
          default://Air
            break;
        }
          
        HRectangle shape = createSquareShape(i, j, cols, rows);
        Square s = new Square(shape,c,shape.getWidth());
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
    Board board = new Board(this,cols,rows);
    register(board);
    ShadowSquareGroup shadowSquareGroup = new ShadowSquareGroup(this,cols,rows);
    register(shadowSquareGroup);
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
public void check(boolean argument)
{
  if(argument == false)
    throw new RuntimeException("CheckingError");
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
/**
 * shadowSquare
 */
class ShadowSquare extends Being
{ 
  boolean[] _dot_color;
  boolean _is_dot_visible;
  float _size;
  
  ShadowSquare(HShape shape, boolean[] d_c, float size)
  {
    super(shape);
    _dot_color = new boolean[]{d_c[0],d_c[1],d_c[2]};
    _is_dot_visible = true;
    _size = size;
  }

  public void update() {
    // Add update method here
  }

  public void draw()
  {
		noStroke();
    fill(generateColor(_dot_color));
    rect(_size/4,_size/4,_size/2,_size/2);
  }
}
/**
 * ShadowSquareGroup
 */
class ShadowSquareGroup extends Group<ShadowSquare>
{

  ShadowSquareGroup(World w, int cols, int rows) {
    super(w);

    for(int i = 0; i < cols; i++)
      for(int j = 0 ; j < rows; j++)
      {
        boolean c[] = new boolean[3];
        for(int k = 0; k < 3; k++)
        {
          c[k] = PApplet.parseBoolean(floor(random(2)));
        }
          
        HRectangle shape = createSquareShape(i, j, cols, rows);
        ShadowSquare sh = new ShadowSquare(shape,c,shape.getWidth());
        w.register(sh);
        add(sh);
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
