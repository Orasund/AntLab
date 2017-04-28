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

    Background background = new Background();
    register(background);
    WallGroup wallGroup = new WallGroup(this,board);
    register(wallGroup);
    AntGroup antGroup = new AntGroup(this,board);
    register(antGroup);
    ShadowGroup shadowGroup = new ShadowGroup(this,board);
    register(shadowGroup);
  }

  void preUpdate()
  {
    beings_counter = 0; //for Debuging
    gameLoop.update();
  }

  void postUpdate()
  {
    println("POSTUPDATE: "+beings_counter+" Beings exist.");
  }
}