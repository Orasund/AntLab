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
    int cols = 14;
    int rows = 10;
    Board g = new Board(this,cols,rows);
    register(g);
  }
}