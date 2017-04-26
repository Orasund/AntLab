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

  currentWorld = new TemplateWorld(PORT_IN, PORT_OUT);       

  //Important: don't forget to add setup to TemplateWorld!

  currentWorld.start(); // this should be the last line in setup() method
}

public void draw() {
  currentWorld.draw();
}
/**
 * Template World
 * You'll need to add stuff to setup().
 */
class TemplateWorld extends World {
  TemplateWorld(int portIn, int portOut) {
    super(portIn, portOut);
  }

  public void setup() {
    //IMPORTANT: put all other setup here
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
