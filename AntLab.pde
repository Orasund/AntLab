/**
 * A template to get you started
 * Define your beings, groups, interactors and worlds in separate tabs
 * Put the pieces together in this top-level file!
 */

import hermes.*;
import hermes.hshape.*;
import hermes.animation.*;
import hermes.physics.*;
import hermes.postoffice.*;

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

void setup() {
  size(600, 600);
  WINDOW_WIDTH = width;
  WINDOW_HEIGHT = height;
  Hermes.setPApplet(this);

  gameLoop = new GameLoop(floor(60));

  currentWorld = new MapWorld(PORT_IN, PORT_OUT);       

  currentWorld.start(); // this should be the last line in setup() method
}

void draw() {
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