/**
 * Template World
 * You'll need to add stuff to setup().
 */
class TemplateWorld extends World
{
  TemplateWorld(int portIn, int portOut)
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