/**
 * shadowSquare
 */
class ShadowSquare extends Being
{ 
  boolean[] _dot_color;
  boolean _is_dot_visible;
  float _size;
  
  ShadowSquare(HShape shape, boolean[] d_c, float size)
  {
    super(shape);
    _dot_color = new boolean[]{d_c[0],d_c[1],d_c[2]};
    _is_dot_visible = true;
    _size = size;
  }

  public void update() {
    // Add update method here
  }

  public void draw()
  {
		noStroke();
    fill(generateColor(_dot_color));
    rect(_size/4,_size/4,_size/2,_size/2);
  }
}