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