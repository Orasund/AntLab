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
    Board board = new Board(this,cols,rows);
    register(board);
    ShadowSquareGroup shadowSquareGroup = new ShadowSquareGroup(this,cols,rows);
    register(shadowSquareGroup);
  }
}