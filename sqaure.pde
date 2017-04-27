/**
 * Square
 * the Square is part of the gameboard
 */
class Square extends Being
{ 
  boolean[] _c;
  float _size;
  
  Square(HShape shape, boolean[] b_c, float size)
  {
    super(shape);
    _c = new boolean[]{b_c[0],b_c[1],b_c[2]};
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