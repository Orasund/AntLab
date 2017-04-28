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

  void setup()
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

  void preUpdate()
  {
    beings_counter = 0;

    noStroke();
    fill(255);
    rect(0,0,WINDOW_WIDTH,WINDOW_HEIGHT);

    gameLoop.update();
  }

  void postUpdate()
  {
    println("POSTUPDATE: "+beings_counter+" Beings exist.");
  }
}