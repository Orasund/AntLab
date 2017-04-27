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
    ShadowSquareGroup shadowSquareGroup = new ShadowSquareGroup(this,board);
    register(shadowSquareGroup);
  }

  void preUpdate()
  {
    beings_counter = 0;
  }

  void postUpdate()
  {
    println("POSTUPDATE: "+beings_counter+" Beings exist.");
  }
}