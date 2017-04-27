/**
 * Wall
 */
class Wall extends Being
{ 
  boolean[] _c = {false,false,false};
  float _size;
  
  Wall(HShape shape, float size)
  {
    super(shape);
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